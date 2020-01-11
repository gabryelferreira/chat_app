import 'dart:async';
import 'dart:convert';

import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/chat_repository.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:chat_app/src/utils/socket_controller.dart';
import 'package:chat_app/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ContactController extends StateControl {
  BuildContext context;
  Chat chat;

  IO.Socket socket = SocketController.socket;

  ChatRepository _chatRepository = ChatRepository();

  TextEditingController textController = TextEditingController();

  bool _error = false;
  bool get error => _error;

  bool _loading = true;
  bool get loading => _loading;

  ContactController({
    @required this.context,
    @required this.chat,
  }) {
    this.init();
  }

  void init() {
    socket.on('new-chat', (dynamic data) {
      print("haha $data");
    });
    socket.on('new-message', (dynamic data) {
      print("hehe $data");
    });
  }

  void sendMessage() {
    String text = textController.text;
    _chatRepository.sendMessage(chat.id, text);
    addMessage(text);
    textController.text = "";
    notifyListeners();
  }

  void addMessage(String text) {
    Message message = Message(
      text: text,
      userId: chat.myUser.id,
    );
    chat.messages.add(message);
  }

  disconnectSocket() {
    if (socket.connected) {
      socket.disconnect();
    }
  }

  void dispose() {
    super.dispose();
    textController.dispose();
    disconnectSocket();
  }
}
