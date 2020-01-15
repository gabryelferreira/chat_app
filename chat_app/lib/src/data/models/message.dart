
class Message {

  String localId;
  String id;
  String chatId;
  String text;
  String userId;
  int sendAt;
  bool unreadByMe;

  Message({
    this.id,
    this.chatId,
    this.text,
    this.userId,
    this.sendAt,
    this.unreadByMe,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    chatId = json['chatId'];
    text = json['text'];
    userId = json['userId'];
    sendAt = json['sendAt'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['_id'] = id;
    json['chatId'] = chatId;
    json['text'] = text;
    json['userId'] = userId;
    json['sendAt'] = sendAt;
    return json;
  }

  Message.fromLocalDatabaseMap(Map<String, dynamic> json) {
    id = json['_id'];
    chatId = json['chat_id'];
    text = json['text'];
    userId = json['user_id'];
    sendAt = json['send_at'];
    unreadByMe = json['unread_by_me'];
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['chat_id'] = chatId;
    map['text'] = text;
    map['user_id'] = userId;
    map['send_at'] = sendAt;
    map['unread_by_me'] = unreadByMe ?? false;
    return map;
  }

}