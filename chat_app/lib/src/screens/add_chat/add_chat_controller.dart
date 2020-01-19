import 'dart:async';
import 'dart:convert';

import 'package:chat_app/src/data/local_database/db_provider.dart';
import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/data/repositories/chat_repository.dart';
import 'package:chat_app/src/data/repositories/user_repository.dart';
import 'package:chat_app/src/screens/contact/contact_view.dart';
import 'package:chat_app/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class AddChatController extends StateControl {
  UserRepository _userRepository = UserRepository();
  ChatRepository _chatRepository = ChatRepository();

  final BuildContext context;

  bool _loading = true;
  bool get loading => _loading;

  bool _error = false;
  bool get error => _error;

  List<User> _users = [];
  List<User> get users => _users;

  Chat _chat;

  ProgressDialog _progressDialog;

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

  void newChat(User user) async {
    
    // _showProgressDialog();

    final Chat chat = Chat(
      id: user.chatId,
      user: user,
    );
    final _provider = Provider.of<ChatsProvider>(context, listen: false);
    _provider.createUserIfNotExists(chat.user);
    _provider.createChatIfNotExists(chat);
    _provider.setSelectedChat(chat);
    Navigator.of(context).popAndPushNamed(ContactScreen.routeName);
    // _dismissProgressDialog();
    // Provider.of<ChatsProvider>(context, listen: false).setSelectedChat(chat.id);
    _loading = false;
    notifyListeners();
  }

  void _showProgressDialog() {
    _progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    _progressDialog.style(
        message: 'Carregando...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CupertinoActivityIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    _progressDialog.show();
  }

  Future<bool> _dismissProgressDialog() {
    return _progressDialog.hide();
  }

  void closeScreen() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
