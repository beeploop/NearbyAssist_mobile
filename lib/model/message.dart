class Message {
  int id;
  int sender;
  int receiver;
  String content;

  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'content': content,
    };
  }
}
