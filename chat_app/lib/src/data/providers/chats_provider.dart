import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:flutter/material.dart';

class ChatsProvider with ChangeNotifier {

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  Chat _selectedChat;
  Chat get selectedChat => _selectedChat;

  setChats(List<Chat> chats) {
    List<Chat> newChats = new List<Chat>.from(chats);
    newChats.sort((a, b) {
      if (a.messages.length == 0) return 1;
      if (b.messages.length == 0) return -1;
      int millisecondsA = a.messages[a.messages.length - 1].createdAt;
      int millisecondsB = b.messages[b.messages.length - 1].createdAt;
      return millisecondsA > millisecondsB ? -1 : 1;
    });
    _chats = newChats;
    notifyListeners();
  }

  setSelectedChat(Chat selectedChat) {
    _selectedChat = selectedChat;
    notifyListeners();
  }

  addMessageToSelectedChat(Message message) {
    _selectedChat.messages.add(message);
    setChats(_chats);
  }

}