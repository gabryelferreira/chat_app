import 'dart:async';
import 'dart:convert';

import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/screens/login/login_view.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:chat_app/src/utils/socket_controller.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeController {
  
  final BuildContext context;

  StreamController<String> streamController = StreamController();

  IO.Socket socket = SocketController.socket;


  List<User> _users = [];
  List<User> get users => _users;

  HomeController({
    @required this.context,
  }) {
    this.init();
  }

  void init() {
    initSocket();
  }

  void initSocket() async {
    // connectSocket();
    emitUserIn();
    socketOnUsersUpdate();
  }

  Future<User> getUserFromSharedPreferences() async {
    final savedUser = await CustomSharedPreferences.get('user');
    User user = User.fromJson(jsonDecode(savedUser));
    return user;
  }

  void emitUserIn() async {
    User user = await getUserFromSharedPreferences();
    Map<String, dynamic> userJson = user.toJson();
    socket.emit("user-in", userJson);
  }

  void socketOnUsersUpdate() {
    socket.on('users-update', (dynamic data) async {
      List<dynamic> usersData = data;
      List<User> newUsers = usersData.map((user) => User.fromJson(user)).toList();
      User user = await getUserFromSharedPreferences();

      _users = newUsers.where((newUser) => newUser.id != user.id).toList();
      notifyListeners();
    });
  }

  removeUser(String id) {
    _users.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void logout() async {
    disconnectSocket();
    
    await CustomSharedPreferences.remove('user');
    await CustomSharedPreferences.remove('token');
    Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (_) => false);
  }

  void notifyListeners() {
    streamController.add('change');
  }

  void connectSocket() {
    if (!socket.connected) {
      socket.connect();
    }
  }

  void disconnectSocket() {
    if (socket.connected) {
      // socket.disconnect();
      socket.emit('user-left');
      socket.off('users-update');
    }
  }

  void dispose() {
    disconnectSocket();
    streamController.close();
  }
}
