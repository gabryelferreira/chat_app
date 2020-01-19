import 'dart:convert';

import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/data/repositories/chat_repository.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:chat_app/src/utils/dates.dart';
import 'package:chat_app/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ContactController extends StateControl {
  BuildContext context;

  ChatRepository _chatRepository = ChatRepository();

  ScrollController scrollController;

  ChatsProvider _chatsProvider;

  Chat get selectedChat => _chatsProvider.selectedChat;
  List<Chat> get chats => _chatsProvider.chats;

  TextEditingController textController = TextEditingController();

  User myUser;

  bool _error = false;
  bool get error => _error;

  bool _loading = true;
  bool get loading => _loading;
  
  bool _showEmojiKeyboard = false;
  bool get showEmojiKeyboard => _showEmojiKeyboard;

  set showEmojiKeyboard(bool showEmojiKeyboard) {
    _showEmojiKeyboard = showEmojiKeyboard;
    notifyListeners();
  }

  ContactController({
    @required this.context,
  }) {
    this.init();
  }

  void init() {
    scrollController = new ScrollController()..addListener(_scrollListener);
    initMyUser();
  }

  initMyUser() async {
    myUser = await getMyUser();
    notifyListeners();
  }

  initProvider() {
    _chatsProvider = Provider.of<ChatsProvider>(context);
  }

  getMyUser() async {
    final userString = await CustomSharedPreferences.get("user");
    final userJson = jsonDecode(userString);
    return User.fromJson(userJson);
  }

  sendMessage() async {
    UtilDates.getTodayMidnight();
    final message = textController.text.trim();
    if (message.length == 0) return;
    final user = await CustomSharedPreferences.getMyUser();
    final myId = user.id;
    final selectedChat = Provider.of<ChatsProvider>(context, listen: false).selectedChat;
    final to = selectedChat.user.id;
    final newMessage = Message(
      chatId: selectedChat.id,
      from: myId,
      to: to,
      message: message,
      sendAt: DateTime.now().millisecondsSinceEpoch,
      unreadByMe: false,
    );
    textController.text = "";
    await Provider.of<ChatsProvider>(context, listen: false).addMessageToChat(newMessage);
    await _chatRepository.sendMessage(message, to);
    
  }

  String getNumberOfUnreadChatsToString() {
    final unreadChats = chats.where((chat) {
      return chat.messages.where((message) => message.unreadByMe).length > 0;
    }).length;
    if (unreadChats > 0) {
      return unreadChats.toString();
    }
    return '';
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter < 650) {
      _chatsProvider.loadMoreSelectedChatMessages();
    }
  }

  void dispose() {
    super.dispose();
    textController.dispose();
    _chatsProvider.setSelectedChat(null);
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }
}
