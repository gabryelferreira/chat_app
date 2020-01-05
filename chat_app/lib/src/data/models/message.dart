class Message {
  String text;
  String socketId;

  Message({
    this.text,
    this.socketId = 'MY_SOCKET_ID',
  });

  Message.fromJson(Map<String, dynamic> json) {
    text = json['message'];
    socketId = json['from'];
  }

}