import 'package:chat_app/src/data/models/user.dart';
import 'package:flutter/material.dart';

class UserWithToken  {

  User user;
  String token;

  UserWithToken({
    this.user,
    this.token
  });

  UserWithToken.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    token = json['token'];
  }

  @override
  String toString() {
    return '{"user":${user.toString()},"token":"$token"}';
  }

}
