import 'dart:async';
import 'dart:convert';

import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/chat_repository.dart';
import 'package:chat_app/src/screens/add_chat/add_chat_view.dart';
import 'package:chat_app/src/screens/login/login_view.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:chat_app/src/utils/socket_controller.dart';
import 'package:chat_app/src/utils/state_control.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeController extends StateControl {

  ChatRepository _chatRepository = ChatRepository();
  
  final BuildContext context;

  bool _error = false;
  bool get error => _error;

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

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
  }

  void getChats() async {
    final dynamic chatResponse = await _chatRepository.getChats();
    if (chatResponse is CustomError) {
      print("error bb $chatResponse");
      _error = true;
    }
    if (chatResponse is List<Chat>) {
      _chats = await Future.wait(chatResponse.map((chat) => chat.formatChat()));
      print("cai aqui nos chats $chats");
    }
    
    _loading = false;
    notifyListeners();
  }

  Future<User> getUserFromSharedPreferences() async {
    final savedUser = await CustomSharedPreferences.get('user');
    User user = User.fromJson(jsonDecode(savedUser));
    return user;
  }

  void logout() async {
    await CustomSharedPreferences.remove('user');
    await CustomSharedPreferences.remove('token');
    Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (_) => false);
  }

  void openAddChatScreen() {
    Navigator.of(context).pushNamed(AddChatScreen.routeName);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
