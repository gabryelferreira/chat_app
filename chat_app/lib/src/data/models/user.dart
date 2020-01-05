import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String username;
  String socketId;
  String currentChatSocketId;

  User({
    @required this.id,
    @required this.name,
    @required this.username,
    this.socketId,
    this.currentChatSocketId,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    socketId = json['socketId'];
    currentChatSocketId = json['currentChatSocketId'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'socketId': socketId,
      'currentChatSocketId': currentChatSocketId,
    };
  }

  @override
  String toString() {
    return '{"_id":"$id","name":"$name","username":"$username","socketId":"$socketId","currentChatSocketId":"$currentChatSocketId"}';
  }
}
