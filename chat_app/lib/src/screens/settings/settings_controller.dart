import 'dart:async';

import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/data/repositories/register_repository.dart';
import 'package:chat_app/src/data/repositories/user_repository.dart';
import 'package:chat_app/src/screens/home/home_view.dart';
import 'package:chat_app/src/screens/login/login_view.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:chat_app/src/utils/socket_controller.dart';
import 'package:chat_app/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SettingsController extends StateControl {

  final BuildContext context;

  UserRepository _userRepository = UserRepository();

  IO.Socket socket = SocketController.socket;

  User myUser;

  SettingsController({
    @required this.context,
  }) {
    this.init();
  }

  void init() {
    getMyUser();
  }

  getMyUser() async {
    myUser = await CustomSharedPreferences.getMyUser();
    print("myuserrr ${myUser.name}");
    notifyListeners();
  }

  showAlertDialog(String message) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alerta = AlertDialog(
      title: Text("Verifique os erros"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  void emitUserLeft() async {
    socket.emit("user-left");
  }

  logout() async {
    emitUserLeft();
    _userRepository.saveUserFcmToken(null);
    await CustomSharedPreferences.remove('user');
    await CustomSharedPreferences.remove('token');
    Provider.of<ChatsProvider>(context).clearDatabase();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginScreen.routeName, (_) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }

}