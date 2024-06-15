class Message {
  int sender;
  int receiver;
  String content;

  Message({
    required this.sender,
    required this.receiver,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      receiver: json['receiver'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'content': content,
    };
  }
}
