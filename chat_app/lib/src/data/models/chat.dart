import 'dart:convert';

import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:flutter/material.dart';

class Chat {

  String id;
  String userId;
  List<Message> messages;
  User user;

  Chat({
    @required this.id,
    this.userId,
    this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['_id'] = id;
    json['userId'] = userId;
    return json;
  }

  Chat.fromLocalDatabaseMap(Map<String, dynamic> map) {
    id = map['_id'];
    userId = map['user_id'];
    user = User.fromLocalDatabaseMap({
      '_id': map['user_id'],
      'name': map['name'],
      'username': map['username'],
    });
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['user_id'] = userId;
    return map;
  }

  Future<Chat> formatChat() async {
    return this;
  }

}