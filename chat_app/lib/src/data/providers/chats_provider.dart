import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:flutter/material.dart';

class ChatsProvider with ChangeNotifier {

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  Chat _selectedChat;
  Chat get selectedChat => _selectedChat;

  setChats(List<Chat> chats) {
    _chats = chats;
    notifyListeners();
  }

  setSelectedChat(Chat selectedChat) {
    _selectedChat = selectedChat;
    notifyListeners();
  }

  addMessageToSelectedChat(Message message) {
    _selectedChat.messages.add(message);
    notifyListeners();
  }

}