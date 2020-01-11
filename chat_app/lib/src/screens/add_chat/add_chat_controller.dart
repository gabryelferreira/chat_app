import 'dart:async';
import 'dart:convert';

import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/user_repository.dart';
import 'package:chat_app/src/screens/login/login_view.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:chat_app/src/utils/socket_controller.dart';
import 'package:chat_app/src/utils/state_control.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class AddChatController extends StateControl {

  UserRepository _userRepository = UserRepository();
  
  final BuildContext context;

  bool _loading = true;
  bool get loading => _loading;

  bool _error = false;
  bool get error => _error;


  List<User> _users = [];
  List<User> get users => _users;

  AddChatController({
    @required this.context,
  }) {
    
    this.init();
  }

  @override
  void init() {
    getUsers();
  }

  void getUsers() async {
    dynamic response = await _userRepository.getUsers();
    if (response is CustomError) {
      _error = true;
    }
    if (response is List<User>) {
      _users = response;
    }
    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

}
