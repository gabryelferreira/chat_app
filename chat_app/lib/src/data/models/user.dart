import 'dart:convert';

import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String username;
  String token;

  User({
    @required this.id,
    @required this.name,
    @required this.username,
    this.token,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'token': token,
    };
  }

  @override
  String toString() {
    Map<String, dynamic> userJson;
    userJson['_id'] = id;
    userJson['name'] = name;
    userJson['username'] = username;
    return json.encode(userJson);
  }
}
