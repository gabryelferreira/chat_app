
class Message {

  String id;
  String userId;
  String text;
  int createdAt;
  bool unread;

  Message({
    this.id,
    this.userId,
    this.text,
    this.createdAt,
  });

  Message.fromJson(Map<String, dynamic> json) {
    print("jsonMessage = $json");
    id = json['_id'];
    userId = json['userId'];
    text = json['text'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['_id'] = id;
    json['userId'] = userId;
    json['text'] = text;
    json['createdAt'] = createdAt;
    return json;
  }

}