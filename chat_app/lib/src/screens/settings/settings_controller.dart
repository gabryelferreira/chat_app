import 'dart:async';
import 'dart:io';

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
    notifyListeners();
  }

  openModalDeleteChats() {
    String title = "Apagar conversas";
    String description =
        "Tem certeza que desejar apagar suas conversas? Você não poderá recuperá-las.";
    List<Widget> actions = [
      FlatButton(
        child: Text(Platform.isIOS ? 'Cancelar' : 'CANCELAR'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text(
          Platform.isIOS ? 'Excluir' : 'EXCLUIR',
          style: TextStyle(color: Platform.isIOS ? Colors.red : Colors.blue),
        ),
        onPressed: () {
          Navigator.pop(context);
          deleteChats();
        },
      ),
    ];
    showAlertDialog(title, description, actions);
  }

  deleteChats() async {
    await Provider.of<ChatsProvider>(context, listen: false).clearDatabase();
    String title = "Sucesso";
    String description = "Suas conversas foram excluidas.";
    List<Widget> actions = [
      FlatButton(
        child: Text(Platform.isIOS ? 'Ok' : 'OK'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ];
    showAlertDialog(title, description, actions);
  }

  openModalExitApp() {
    String title = "Sair";
    String description =
        "Tem certeza que deseja sair? Suas conversas serão perdidas.";
    List<Widget> actions = [
      FlatButton(
        child: Text(Platform.isIOS ? 'Cancelar' : 'CANCELAR'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text(
          Platform.isIOS ? 'Sair' : 'SAIR',
          style: TextStyle(color: Platform.isIOS ? Colors.red : Colors.blue),
        ),
        onPressed: () {
          Navigator.pop(context);
          logout();
        },
      ),
    ];
    showAlertDialog(title, description, actions);
  }

  showAlertDialog(String title, String description, List<Widget> actions) {
    var alertDialog;
    if (Platform.isIOS) {
      alertDialog = CupertinoAlertDialog(
        title: Text(title),
        content: Text(description),
        actions: actions,
      );
    } else {
      alertDialog = AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: actions,
      );
    }
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
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
    Provider.of<ChatsProvider>(context, listen: false).clearDatabase();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginScreen.routeName, (_) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
