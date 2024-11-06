class ConversationModel {
  String recipientId;
  String recipient;
  String imageUrl;
  String lastMessage;
  String date;

  ConversationModel({
    required this.recipientId,
    required this.recipient,
    required this.imageUrl,
    required this.lastMessage,
    required this.date,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      recipientId: json['recipientId'],
      recipient: json['recipient'],
      imageUrl: json['imageUrl'],
      lastMessage: json['lastMessage'],
      date: json['date'],
    );
  }
}
