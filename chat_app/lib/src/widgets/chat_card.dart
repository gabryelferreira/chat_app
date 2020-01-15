import 'dart:convert';

import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/screens/contact/contact_view.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;

  var format = new DateFormat("HH:mm");

  String myId;

  ChatCard({
    @required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return Container(
      child: InkWell(
        onTap: () {
          ChatsProvider _chatsProvider =
              Provider.of<ChatsProvider>(context, listen: false);
          _chatsProvider.setSelectedChat(chat.id);
          Navigator.of(context).pushNamed(ContactScreen.routeName);
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            top: 10,
            bottom: 0,
          ),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/contact.jpg'),
                  radius: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      bottom: 5,
                    ),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                      'hey',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      chat.messages[chat.messages.length - 1]
                                          .text,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15, left: 30),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      messageDate(chat
                                          .messages[chat.messages.length - 1]
                                          .sendAt),
                                      style: TextStyle(
                                        color: _numberOfUnreadMessagesByMe() > 0 ? Theme.of(context).primaryColor : Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    unreadMessages(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Color(0xFFDDDDDD),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String messageDate(int milliseconds) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return format.format(date);
  }

  int _numberOfUnreadMessagesByMe() {
    return chat.messages.where((message) => message.unreadByMe).length;
  }

  Widget unreadMessages() {
    final _unreadMessages = _numberOfUnreadMessagesByMe();
    if (_unreadMessages == 0) {
      return Container(width: 0, height: 0);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
      ),
      child: Text(
        _unreadMessages.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
