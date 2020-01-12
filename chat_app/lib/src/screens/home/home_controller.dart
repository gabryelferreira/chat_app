import 'dart:async';
import 'dart:convert';

import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/custom_error.dart';
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

class HomeController extends StateControl {
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

  HomeController({
    @required this.context,
  }) {
    this.init();
  }

  void init() {
    getChats();
    initSocket();
    _firebaseMessaging = FirebaseMessaging();
    requestPushNotificationPermission();
    configureFirebaseMessaging();
  }

  void requestPushNotificationPermission() {
    _firebaseMessaging.requestNotificationPermissions();
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
    _firebaseMessaging.getToken().then((token){
      print("token $token");
      if (token != null) {
        _userRepository.saveUserFcmToken(token);
      }
    });
  }

  void initProvider() {
    _chatsProvider = Provider.of<ChatsProvider>(context);
  }

  void initSocket() {
    emitUserIn();
    onMessage();
  }

  void emitUserIn() async {
    User user = await getUserFromSharedPreferences();
    Map<String, dynamic> json = user.toJson();
    socket.emit("user-in", json);
  }

  void onMessage() async {
    socket.on("message", (dynamic data) async {
      Map<String, dynamic> json = data;
      Chat chat = Chat.fromJson(json);
      int chatIndex = chats.indexWhere((_chat) => _chat.id == chat.id);
      List<Chat> newChats = new List<Chat>.from(chats);
      if (chatIndex > -1) {
        newChats[chatIndex].messages = chat.messages;
        newChats[chatIndex] = await newChats[chatIndex].formatChat();
      } else {
        newChats.add(await chat.formatChat());
      }
      _chatsProvider.setChats(newChats);
      if (_chatsProvider.selectedChatId != null) {
        _chatsProvider.chats.forEach((chat) {
          if (chat.id == _chatsProvider.selectedChatId) {
            _chatsProvider.setSelectedChat(chat.id);
            return;
          }
        });
      }
    });
  }

  void emitUserLeft() async {
    socket.emit("user-left");
  }

  void getChats() async {
    final dynamic chatResponse = await _chatRepository.getChats();
    if (chatResponse is CustomError) {
      _error = true;
    }
    if (chatResponse is List<Chat>) {
      List<Chat> chats = await formatChats(chatResponse);
      _chatsProvider.setChats(chats);
    }

    _loading = false;
    notifyListeners();
  }

  Future<List<Chat>> formatChats(List<Chat> chats) async {
    return await Future.wait(chats.map((chat) => chat.formatChat()));
  }

  int calculateChatsWithMessages() {
    return chats.where((chat) => chat.messages.length > 0).length;
  }

  Future<User> getUserFromSharedPreferences() async {
    final savedUser = await CustomSharedPreferences.get('user');
    User user = User.fromJson(jsonDecode(savedUser));
    return user;
  }

  void logout() async {
    emitUserLeft();
    // _userRepository.saveUserFcmToken(null);
    await CustomSharedPreferences.remove('user');
    await CustomSharedPreferences.remove('token');
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginScreen.routeName, (_) => false);
  }

  void openAddChatScreen() {
    Navigator.of(context).pushNamed(AddChatScreen.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    emitUserLeft();
  }
}
