import 'dart:convert';

import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/utils/custom_http_client.dart';
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:chat_app/src/utils/my_urls.dart';

class LoginRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> login(String username, String password) async {
    try {
      var body = jsonEncode({'username': username, 'password': password});
      var response = await http.post(
        '${MyUrls.serverUrl}/auth',
        body: body,
      );
      final dynamic loginResponse = jsonDecode(response.body);

      if (loginResponse['error'] != null) {
        return CustomError.fromJson(loginResponse);
      }
      await CustomSharedPreferences.setString('token', loginResponse['token']);
      final User user = User.fromJson(loginResponse['user']);
      await CustomSharedPreferences.setString('user', user.toString());
      return user;
    } catch (err) {
      return CustomError(
        error: true,
        errorMessage: "Ocorreu um erro! Tente novamente",
      );
    }
  }
}
