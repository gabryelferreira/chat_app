import 'dart:async';
import 'dart:io';

import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/data/repositories/chat_repository.dart';
import 'package:chat_app/src/data/repositories/user_repository.dart';
import 'package:chat_app/src/screens/add_chat/add_chat_view.dart';
import 'package:chat_app/src/screens/login/login_view.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:chat_app/src/utils/socket_controller.dart';
import 'package:chat_app/src/utils/state_control.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:firebase_messaging/firebase_messaging.dart';

class HomeController extends StateControl with WidgetsBindingObserver {
  ChatRepository _chatRepository = ChatRepository();

  UserRepository _userRepository = UserRepository();

  ChatsProvider _chatsProvider;

  IO.Socket socket = SocketController.socket;

  FirebaseMessaging _firebaseMessaging;

  final BuildContext context;

  bool _error = false;
  bool get error => _error;

  List<Chat> get chats => _chatsProvider.chats;

  bool _loading = true;
  bool get loading => _loading;

  List<User> _users = [];
  List<User> get users => _users;

  AppLifecycleState _notification;

  final duration = const Duration(milliseconds: 100);

  bool isSocketConnected = false;

  HomeController({
    @required this.context,
  }) {
    this.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _notification = state;
    print("state $state");
    if (state == AppLifecycleState.inactive) {
      disconnectSocket();
    }
    if (state == AppLifecycleState.resumed) {
      // socket.connect();
      connectSocket();
    }
  }

  connectSocket() {
    disconnectSocket();
    socket.connect();
    _loading = true;
    notifyListeners();
    Timer.periodic(duration, (timer) {
      print("socket connected ${socket.connected}");
      if (socket.connected) {
        if (timer != null) timer.cancel();
        initSocket();
      }
    });
  }

  disconnectSocket() {
    socket.disconnect();
    isSocketConnected = false;
    inactiveSocketFunctions();
  }

  inactiveSocketFunctions() {
    socket.off("user-in");
    socket.off("message");
  }

  void init() {
    _firebaseMessaging = FirebaseMessaging();
    requestPushNotificationPermission();
    configureFirebaseMessaging();
    connectSocket();
    WidgetsBinding.instance.addObserver(this);
  }

  void initSocket() {
    if (!isSocketConnected) {
      isSocketConnected = true;
      emitUserIn();
      onMessage();
      onUserIn();
    }
  }

  void emitUserIn() async {
    User user = await CustomSharedPreferences.getMyUser();
    Map<String, dynamic> json = user.toJson();
    socket.emit("user-in", json);
  }

  void onUserIn() async {
    socket.on("user-in", (_) {
      _loading = false;
      notifyListeners();
    });
  }

  void onMessage() async {
    socket.on("message", (dynamic data) async {
      print("message $data");
      Map<String, dynamic> json = data['message'];
      Map<String, dynamic> userJson = json['from'];
      Chat chat = Chat.fromJson({
        "_id": json['chatId'],
        "user": userJson,
      });
      Message message = Message.fromJson(json);
      Provider.of<ChatsProvider>(context, listen: false)
          .createChatAndUserIfNotExists(chat);
      Provider.of<ChatsProvider>(context, listen: false)
          .addMessageToChat(message);
      await _chatRepository.deleteMessage(message.id);
    });
  }

  void emitUserLeft() async {
    socket.emit("user-left");
  }

  void requestPushNotificationPermission() {
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(
          alert: true,
          badge: true,
          provisional: false,
        ),
      );
    }
  }

  void configureFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.getToken().then((token) {
      if (token != null) {
        _userRepository.saveUserFcmToken(token);
      }
    });
  }

  void initProvider() {
    _chatsProvider = Provider.of<ChatsProvider>(context);
  }

  void openAddChatScreen() async {
    Navigator.of(context).pushNamed(AddChatScreen.routeName);
  }

  void openSettings() async {
    Navigator.of(context).pushNamed('/settings');
  }

  @override
  void dispose() {
    super.dispose();
    emitUserLeft();
    disconnectSocket();
    WidgetsBinding.instance.removeObserver(this);
    disconnectSocket();
  }
}
