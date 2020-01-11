import 'dart:convert';

import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:flutter/material.dart';

class Chat {

  String id;
  User lowerIdUser;
  User higherIdUser;
  List<Message> messages;
  User myUser;
  User otherUser;

  Chat({
    @required this.id,
    @required this.lowerIdUser,
    @required this.higherIdUser,
    @required this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    lowerIdUser = User.fromJson(json['lowerId']);
    higherIdUser = User.fromJson(json['higherId']);
    List<dynamic> _messages = json['messages'];
    messages = _messages.map((message) => Message.fromJson(message)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['_id'] = id;
    json['lowerId'] = lowerIdUser.toJson();
    json['higherId'] = higherIdUser.toJson();
    json['messages'] = messages.map((message) => message.toJson()).toList();
    return json;
  }

  Future<Chat> formatChat() async {
    adjustChatUsers();
    return this;
  }

  void adjustChatUsers() async {
    final String userString = await CustomSharedPreferences.get('user');
    final Map<String, dynamic> userJson = jsonDecode(userString);
    final myUserFromSharedPreferences = User.fromJson(userJson);
    if (myUserFromSharedPreferences.id == lowerIdUser.id) {
      myUser = lowerIdUser;
      otherUser = higherIdUser;
    } else {
      otherUser = lowerIdUser;
      myUser = higherIdUser;
    }
  }

}