import 'dart:convert';

import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/utils/custom_http_client.dart';
import 'package:chat_app/src/utils/my_urls.dart';

class ChatRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> getChats() async {
    try {
      var response = await http.get('${MyUrls.serverUrl}/chats');
      final List<dynamic> chatsResponse = jsonDecode(response.body)['chats'];
      final List<Chat> chats =
          chatsResponse.map((chat) => Chat.fromJson(chat)).toList();
      return chats;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> sendMessage(String chatId, String text) async {
    try {
      var body = jsonEncode({'text': text});
      var response = await http.post(
        '${MyUrls.serverUrl}/chats/$chatId/message',
        body: body,
      );
      final dynamic chatResponse = jsonDecode(response.body)['chat'];
      final Chat chat = Chat.fromJson(chatResponse);
      return chat;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }
}
