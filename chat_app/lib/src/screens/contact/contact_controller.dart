import 'dart:async';

import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/utils/socket_controller.dart';
import 'package:flutter/cupertino.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ContactController {
  BuildContext context;
  User user;

  bool userOnlineInMyChat = false;

  StreamController streamController = StreamController();
  TextEditingController textController = TextEditingController();

  IO.Socket socket = SocketController.socket;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  ContactController({
    @required this.context,
    @required this.user,
  }) {
    this.init();
  }

  void init() {
    initSocket();
  }

  void initSocket() async {
    socketOnMessage();
    socketEnteredChat();
    socketOnEnteredChat();
    socketOnLeaveChat();
  }

  void socketEnteredChat() {
    socket.emit("entered-chat", user.socketId);
  }

  void socketLeaveChat() {
    socket.emit("leave-chat", user.socketId);
  }

  void socketOnEnteredChat() {
    socket.on("entered-chat", (dynamic data) {
      String socketId = data;
      if (user.socketId == socketId) {
        if (!userOnlineInMyChat) {
          socketEnteredChat();
        }
        userOnlineInMyChat = true;
        notifyListeners();
      }
    });
  }

  void socketOnLeaveChat() {
    socket.on("leave-chat", (dynamic data) {
      String socketId = data;
      if (user.socketId == socketId) {
        userOnlineInMyChat = false;
        notifyListeners();
      }
    });
  }

  void socketOnMessage() {
    socket.on("message", (dynamic data) {
      Message message = Message.fromJson(data);
      addMessage(message.text, message.socketId);
    });
  }

  void sendMessage() async {
    String text = textController.value.text;
    socket.emit("message", {
      "to": user.socketId,
      "message": text,
    });
    textController.text = "";
    addMessage(text, 'MY_SOCKET_ID');
  }

  void addMessage(String text, String socketId) {
    messages.add(Message(text: text, socketId: socketId));
    notifyListeners();
  }

  void notifyListeners() {
    streamController.add('change');
  }

  void closeSocketEvents() {
    if (socket.connected) {
      socket.off('entered-chat');
      socket.off('leave-chat');
      socket.off('message');
    }
  }

  dispose() {
    socketLeaveChat();
    closeSocketEvents();
    textController.dispose();
    streamController.close();
  }
}
