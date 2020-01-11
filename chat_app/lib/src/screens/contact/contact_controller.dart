import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/repositories/chat_repository.dart';
import 'package:chat_app/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';

class ContactController extends StateControl {
  BuildContext context;
  Chat chat;

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
    // socket.on('message', (dynamic data) {
    //   Map<String, dynamic> json = data;
    //   Message message = Message.fromJson(json['message']);
    //   addMessage(message);
    // });
  }

  void sendMessage() {
    String text = textController.text;
    _chatRepository.sendMessage(chat.id, text);
    textController.text = "";
    Message message = Message(
      text: text,
      userId: chat.myUser.id,
    );
    addMessage(message);
  }

  void addMessage(Message message) {
    
    chat.messages.add(message);
    notifyListeners();
  }

  void dispose() {
    super.dispose();
    textController.dispose();
  }
}
