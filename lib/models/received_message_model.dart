class ReceivedMessageModel {
  final String id;
  final MessageUser sender;
  final MessageUser receiver;
  final String content;
  bool seen;
  DateTime createdAt;

  ReceivedMessageModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.seen,
    required this.createdAt,
  });

  factory ReceivedMessageModel.fromJson(Map<String, dynamic> json) {
    return ReceivedMessageModel(
      id: json['id'],
      sender: MessageUser.fromJson(json['sender']),
      receiver: MessageUser.fromJson(json['receiver']),
      content: json['content'],
      seen: json['seen'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class MessageUser {
  final String id;
  final String name;
  final String imageUrl;

  MessageUser({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory MessageUser.fromJson(Map<String, dynamic> json) {
    return MessageUser(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
