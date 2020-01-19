
class Message {

  int localId;
  String id;
  String chatId;
  String message;
  String from;
  String to;
  int sendAt;
  bool unreadByMe;

  Message({
    this.localId,
    this.id,
    this.chatId,
    this.message,
    this.from,
    this.to,
    this.sendAt,
    this.unreadByMe,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    chatId = json['chatId'];
    message = json['message'];
    from = json['from']['_id'];
    to = json['to']['_id'];
    unreadByMe = json['unreadByMe'] ?? true;
    sendAt = json['sendAt'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['_id'] = id;
    json['chatId'] = chatId;
    json['message'] = message;
    json['from'] = from;
    json['to'] = to;
    json['sendAt'] = sendAt;
    return json;
  }

  Message.fromLocalDatabaseMap(Map<String, dynamic> json) {
    localId = json['id_message'];
    id = json['_id'];
    chatId = json['chat_id'];
    message = json['message'];
    from = json['from_user'];
    to = json['to_user'];
    sendAt = json['send_at'];
    unreadByMe = json['unread_by_me'] == 1;
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['chat_id'] = chatId;
    map['message'] = message;
    map['from_user'] = from;
    map['to_user'] = to;
    map['send_at'] = sendAt;
    map['unread_by_me'] = unreadByMe ?? false;
    return map;
  }

  Message copyWith({
    int localId,
    String id,
    bool unreadByMe,
  }) {
    return Message(
      localId: localId ?? this.localId,
      id: id ?? this.id,
      chatId: this.chatId,
      message: this.message,
      from: this.from,
      to: this.to,
      sendAt: this.sendAt,
      unreadByMe: unreadByMe ?? this.unreadByMe,
    );
  }

}