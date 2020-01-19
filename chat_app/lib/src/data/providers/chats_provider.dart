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

  bool _noMoreSelectedChatMessages = false;
  bool get noMoreSelectedChatMessages => _noMoreSelectedChatMessages;

  bool _loadingMoreMessages = false;

  updateChats() async {
    _chats = await DBProvider.db.getChatsWithMessages();
    notifyListeners();
  }

  setSelectedChat(Chat selectedChat) async {
    _selectedChat = selectedChat;
    _noMoreSelectedChatMessages = false;
    _loadingMoreMessages = false;
    if (_selectedChat != null) {
      notifyListeners();
      _selectedChat.messages = await DBProvider.db.getChatMessages(selectedChat.id);
      _readSelectedChatMessages();
    }
  }

  loadMoreSelectedChatMessages() async {
    if (!noMoreSelectedChatMessages && selectedChat.messages.length > 0 && !_loadingMoreMessages) {
      _loadingMoreMessages = true;
      int lastMessageId = _selectedChat.messages[_selectedChat.messages.length - 1].localId;
      List<Message> newMessages = await DBProvider.db.getChatMessagesWithOffset(selectedChat.id, lastMessageId);
      if (newMessages.length == 0) {
        _noMoreSelectedChatMessages = true;
        return;
      }
      // newMessages.forEach((message) {
      //   print("messageee ${message.toJson()}");
      // });
      _selectedChat.messages = _selectedChat.messages + newMessages;
      _loadingMoreMessages = false;
      notifyListeners();
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

  Future<void> clearDatabase() async {
    await DBProvider.db.clearDatabase();
    updateChats();
  }

}