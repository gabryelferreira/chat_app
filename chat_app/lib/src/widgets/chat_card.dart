import 'dart:convert';
import 'dart:math';

import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/screens/contact/contact_view.dart';
import 'package:chat_app/src/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;

  final format = new DateFormat("HH:mm");

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.lightBlue,
    Colors.purple,
    Colors.black,
    Colors.cyan,
  ];

  final rng = new Random();

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
          _chatsProvider.setSelectedChat(chat);
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
                  child: Text(
                    chat.user.name[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  radius: 20,
                  backgroundColor: Colors.blue,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 2,
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
                                      chat.user.name,
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
                                      chat.messages[0].message,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      UtilDates.getSendAtDayOrHour(chat.messages[0].sendAt),
                                      style: TextStyle(
                                        color: _numberOfUnreadMessagesByMe() > 0
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
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
                          SizedBox(
                            height: 5,
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
