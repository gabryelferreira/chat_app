import 'package:chat_app/src/data/local_database/db_provider.dart';
import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/chat_repository.dart';
import 'package:flutter/material.dart';

class ChatsProvider with ChangeNotifier {

  ChatRepository _chatRepository = ChatRepository();

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  Chat _selectedChat;
  Chat get selectedChat => _selectedChat;

  updateChats() async {
    _chats = await DBProvider.db.getChatsWithMessages();
    notifyListeners();
  }

  setSelectedChat(Chat selectedChat) async {
    _selectedChat = selectedChat;
    if (_selectedChat != null) {
      notifyListeners();
      _selectedChat.messages = await DBProvider.db.getChatMessages(selectedChat.id);
      // notifyListeners();
      print("messages = ${ _selectedChat.messages.length}");
      _readSelectedChatMessages();
      // _chatRepository.readChat(_selectedChatId);
    }
  }

  _readSelectedChatMessages() async {
    await DBProvider.db.readChatMessages(_selectedChat.id);
    updateChats();
  }

  addMessageToSelectedChat(Message message) {
    DBProvider.db.addMessage(message);
    updateChats();
  }

  createUserIfNotExists(User user) async {
    await DBProvider.db.createUserIfNotExists(user);
    updateChats();
  }

  createChatIfNotExists(Chat chat) async {
    await DBProvider.db.createChatIfNotExists(chat);
    updateChats();
  }

  createChatAndUserIfNotExists(Chat chat) async {
    await DBProvider.db.createUserIfNotExists(chat.user);
    await DBProvider.db.createChatIfNotExists(chat);
    updateChats();
  }
  
  addMessageToChat(Message message) async {
    await DBProvider.db.addMessage(message);
    updateChats();
    setSelectedChat(selectedChat);
  }

}