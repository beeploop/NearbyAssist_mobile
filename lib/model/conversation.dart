class Conversation {
  String userId;
  String name;
  String imageUrl;
  String lastMessage;
  String lastMessageDate;

  Conversation({
    required this.name,
    required this.imageUrl,
    required this.userId,
    required this.lastMessage,
    required this.lastMessageDate,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId: json['userId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      lastMessage: json['lastMessage'],
      lastMessageDate: json['lastMessageDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': name,
      'imageUrl': imageUrl,
      'lastMessage': lastMessage,
      'lastMessageDate': lastMessageDate,
    };
  }
}
