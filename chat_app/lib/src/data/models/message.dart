
class Message {

  String id;
  String userId;
  String text;
  int createdAt;
  bool unreadByLowerIdUser;
  bool unreadByHigherIdUser;
  bool unreadByMe;
  bool unreadByOtherUser;

  Message({
    this.id,
    this.userId,
    this.text,
    this.createdAt,
    this.unreadByMe,
    this.unreadByOtherUser,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    text = json['text'];
    createdAt = json['createdAt'];
    unreadByLowerIdUser = json['unreadByLowerIdUser'] ?? false;
    unreadByHigherIdUser = json['unreadByHigherIdUser'] ?? false;
    unreadByMe = json['unreadByMe'] ?? true;
    unreadByOtherUser = json['unreadByOtherUser'] ?? false;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['_id'] = id;
    json['userId'] = userId;
    json['text'] = text;
    json['createdAt'] = createdAt;
    json['unreadByLowerIdUser'] = unreadByLowerIdUser ?? false;
    json['unreadByHigherIdUser'] = unreadByHigherIdUser ?? false;
    json['unreadByMe'] = unreadByMe ?? false;
    json['unreadByOtherUser'] = unreadByOtherUser ?? false;
    return json;
  }

}