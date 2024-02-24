class Message {
  int fromId;
  int toId;
  String content;

  Message({
    required this.fromId,
    required this.toId,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      fromId: json['Sender'],
      toId: json['Reciever'],
      content: json['Content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': fromId,
      'reciever': toId,
      'content': content,
    };
  }
}
