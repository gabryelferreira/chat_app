import 'dart:convert';

import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/utils/custom_http_client.dart';
import 'package:chat_app/src/utils/my_urls.dart';

class UserRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> getUsers() async {
    try {
      var response = await http.get('${MyUrls.serverUrl}/users');
      final List<dynamic> usersResponse = jsonDecode(response.body)['users'];

      final List<User> users =
          usersResponse.map((user) => User.fromJson(user)).toList();
      return users;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<void> saveUserFcmToken(String fcmToken) async {
    try {
      var body = jsonEncode({'fcmToken': fcmToken});
      await http.post('${MyUrls.serverUrl}/fcm-token', body: body);
    } catch (err) {
      print("error $err");
    }
  }
}
