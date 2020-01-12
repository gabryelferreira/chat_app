import 'dart:convert';

import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String username;

  User({
    @required this.id,
    @required this.name,
    @required this.username,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
    };
  }

  @override
  String toString() {
    return '{"_id":"$id","name":"$name","username":"$username"}';
  }
}
