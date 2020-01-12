
import 'package:chat_app/src/utils/custom_shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomHttpClient extends http.BaseClient{
  http.Client _httpClient = new http.Client();

  final Map<String, String> defaultHeaders = {
    "Content-Type": "application/json"
  };

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final String token = await CustomSharedPreferences.get('token');
    if (token != null) {
      defaultHeaders['Authorization'] = "Bearer $token";
    }
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }
}