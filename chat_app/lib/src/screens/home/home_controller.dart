import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_app/src/data/local_database/chat_table.dart';
import 'package:chat_app/src/data/local_database/local_database.dart';
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

class HomeController extends StateControl {
  ChatRepository _chatRepository = ChatRepository();

  UserRepository _userRepository = UserRepository();

  LocalDatabase _localDatabase;

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
    _firebaseMessaging = FirebaseMessaging();
    requestPushNotificationPermission();
    configureFirebaseMessaging();
    _localDatabase = LocalDatabase();
    this.initializeChatTable();
  }

  initializeChatTable() {
    _localDatabase.open('fala_comigo.db');
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
      print("token $token");
      if (token != null) {
        _userRepository.saveUserFcmToken(token);
      }
    });
  }

  void initProvider() {
    _chatsProvider = Provider.of<ChatsProvider>(context);
  }

  void openAddChatScreen() async {
    // Navigator.of(context).pushNamed(AddChatScreen.routeName);
    // final chatToInsert = Chat(
    //   id: 'j8899jf23t2gi4',
    //   myId: '2w3f23wqf',
    //   otherUserId: '32fgvew',
    // );
    // await _localDatabase.insert(chatToInsert);
    // final chats = await _localDatabase.getChats();
    // chats.forEach((chat) {
    //   print("chat = ${chat.id}");
    // });
    User user = User(
      id: 'fera',
      name: 'Fera',
      username: 'fera',
    );
    final userCreated = await _localDatabase.createUser(user);
    Chat chat = Chat(
      id: 'chat-foda',
      userId: userCreated.id,
    );
    final chatCreated = await _localDatabase.insert(chat);
    final Message message = Message(
      chatId: chatCreated.id,
      id: 'kkk',
      sendAt: 432141512,
      text: 'Eai parsa',
      unreadByMe: true,
      userId: 'fera'
    );
    await _localDatabase.addMessage(message);
    final Message message2 = Message(
      chatId: chatCreated.id,
      id: 'kkkjjj',
      sendAt: 432141512,
      text: 'Eai parsa',
      unreadByMe: true,
      userId: 'fera'
    );
    await _localDatabase.addMessage(message2);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
