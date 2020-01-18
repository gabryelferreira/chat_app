import 'dart:convert';

import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String username;
  String chatId;

  User({
    @required this.id,
    @required this.name,
    @required this.username,
    this.chatId,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    chatId = json['chatId'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
    };
  }

  User.fromLocalDatabaseMap(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['username'] = username;
    return map;
  }

  @override
  String toString() {
    return '{"_id":"$id","name":"$name","username":"$username"}';
  }
}
