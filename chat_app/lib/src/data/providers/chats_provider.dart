import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/repositories/chat_repository.dart';
import 'package:flutter/material.dart';

class ChatsProvider with ChangeNotifier {

  ChatRepository _chatRepository = ChatRepository();

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
    if (selectedChat != null) {
      _readSelectedChatMessages();
      _chatRepository.readChat(_selectedChat.id);
      notifyListeners();
    }
  }

  _readSelectedChatMessages() {
    _selectedChat.messages = _selectedChat.messages.map((message) {
      message.unreadByMe = false;
      return message;
    }).toList();
    updateSelectedChatInChats();
  }

  addMessageToSelectedChat(Message message) {
    _selectedChat.messages.add(message);
    updateSelectedChatInChats();
  }

  updateSelectedChatInChats() {
    List<Chat> newChats = _chats.map((chat) {
      if (chat.id == _selectedChat.id) {
        chat = _selectedChat;
      }
      return chat;
    }).toList();
    setChats(newChats);
  }

}