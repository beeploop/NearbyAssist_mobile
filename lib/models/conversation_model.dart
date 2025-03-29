class ConversationModel {
  String userId;
  String name;
  String imageUrl;
  String lastMessage;
  String date;

  ConversationModel({
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.date,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      userId: json['userId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      lastMessage: json['lastMessage'],
      date: json['lastMessageDate'],
    );
  }
}
