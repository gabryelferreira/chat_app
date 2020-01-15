import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/repositories/chat_repository.dart';
import 'package:flutter/material.dart';

class ChatsProvider with ChangeNotifier {

  ChatRepository _chatRepository = ChatRepository();

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  String _selectedChatId;
  String get selectedChatId => _selectedChatId;

  setChats(List<Chat> chats) {
    List<Chat> newChats = new List<Chat>.from(chats);
    newChats.sort((a, b) {
      if (a.messages.length == 0) return 1;
      if (b.messages.length == 0) return -1;
      int millisecondsA = a.messages[a.messages.length - 1].sendAt;
      int millisecondsB = b.messages[b.messages.length - 1].sendAt;
      return millisecondsA > millisecondsB ? -1 : 1;
    });
    _chats = newChats;
    notifyListeners();
  }

  setSelectedChat(String selectedChatId) {
    _selectedChatId = selectedChatId;
    if (selectedChatId != null) {
      _readSelectedChatMessages();
      _chatRepository.readChat(_selectedChatId);
      notifyListeners();
    }
  }

  _readSelectedChatMessages() {
    List<Chat> updatedChats = _chats;
    updatedChats = updatedChats.map((chat) {
      if (chat.id == _selectedChatId) {
        chat.messages = chat.messages.map((message) {
          message.unreadByMe = false;
          return message;
        }).toList();
      }
      return chat;
    }).toList();
    setChats(updatedChats);
  }

  addMessageToSelectedChat(Message message) {
    List<Chat> updatedChats = _chats;
    updatedChats = updatedChats.map((chat) {
      if (chat.id == _selectedChatId) {
        chat.messages.add(message);
      }
      return chat;
    }).toList();
    setChats(updatedChats);
  }

}