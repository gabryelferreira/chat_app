import 'dart:convert';

import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/custom_error.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/utils/custom_http_client.dart';
import 'package:chat_app/src/utils/my_urls.dart';

class ChatRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> getMessages() async {
    try {
      var response = await http.get('${MyUrls.serverUrl}/message');
      final List<dynamic> chatsResponse = jsonDecode(response.body)['messages'];
      final List<Chat> chats =
          chatsResponse.map((json) {
          Map<String, dynamic> userJson = json['from'];
          final chat = Chat.fromJson({
            "_id": json['chatId'],
            "user": userJson,
          });
          Message message = Message.fromJson(json);
          chat.messages.add(message);
          return chat;
          }).toList();
          chats.forEach((chat) {

          });
      return chats;
    } catch (err) {
      print(err);
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> sendMessage(String message, String to) async {
    try {
      var body = jsonEncode({'message': message, 'to': to});
      var response = await http.post(
        '${MyUrls.serverUrl}/message',
        body: body,
      );
      final dynamic messageResponse = jsonDecode(response.body)['message'];
      Message _message = Message.fromJson(messageResponse);
      return _message;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> getChatByUsersIds(String userId) async {
    try {
      var response = await http.get('${MyUrls.serverUrl}/chats/user/$userId');
      final dynamic chatResponse = jsonDecode(response.body)['chat'];

      final Chat chat = Chat.fromJson(chatResponse);
      return chat;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> readChat(String chatId) async {
    try {
      var response = await http.post('${MyUrls.serverUrl}/chats/$chatId/read');
      final dynamic chatResponse = jsonDecode(response.body)['chat'];

      final Chat chat = Chat.fromJson(chatResponse);
      return chat;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await http.delete('${MyUrls.serverUrl}/message/$messageId');
    } catch (err) {
      print("Error $err");
    }
  }

}
