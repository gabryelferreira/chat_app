import 'dart:convert';

import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/utils/custom_http_client.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:chat_app/src/utils/my_urls.dart';

class RegisterRepository {

  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> register(String name, String username, String password) async {
    try {
      var body = jsonEncode({ 'name': name, 'username': username, 'password': password });
      var response = await http.post(
        '${MyUrls.serverUrl}/user',
        body: body,
      );
      final dynamic registerResponse = jsonDecode(response.body);
      await CustomSharedPreferences.setString('token', registerResponse['token']);

      if (registerResponse['error'] != null) {
        return CustomError.fromJson(registerResponse);
      }

      final User user = User.fromJson(registerResponse['user']);
      return user;
    } catch (err) {
      throw err;
    }
  }
}
