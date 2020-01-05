import 'dart:convert';

import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/user_with_token.dart';
import 'package:chat_app/src/utils/custom_http_client.dart';
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
      final dynamic loginResponse = jsonDecode(response.body);

      if (loginResponse['error'] != null) {
        return CustomError.fromJson(loginResponse);
      }

      final UserWithToken user = UserWithToken.fromJson(loginResponse);
      return user;
    } catch (err) {
      throw err;
    }
  }
}
