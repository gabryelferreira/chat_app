import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/data/repositories/chat_repository.dart';
import 'package:chat_app/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ContactController extends StateControl {
  BuildContext context;

  ChatRepository _chatRepository = ChatRepository();

  ChatsProvider _chatsProvider;
  Chat chat;

  TextEditingController textController = TextEditingController();

  bool _error = false;
  bool get error => _error;

  bool _loading = true;
  bool get loading => _loading;

  ContactController({
    @required this.context,
  }) {
    this.init();
  }

  void init() {
  }

  void dispose() {
    super.dispose();
    textController.dispose();
    _chatsProvider.setSelectedChat(null);
  }
}
