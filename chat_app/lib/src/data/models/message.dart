import 'package:flutter/material.dart';

class Message {

  String id;
  String userId;
  String text;
  String createdAt;

  Message({
    this.id,
    this.userId,
    this.text,
    this.createdAt,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    text = json['text'];
    createdAt = json['createdAt'];
  }

}