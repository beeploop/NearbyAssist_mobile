class InboxPreviewModel {
  String userId;
  String name;
  String imageUrl;
  String lastMessage;
  String lastMessageSender;
  DateTime lastMessageDate;
  bool seen;

  InboxPreviewModel({
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageSender,
    required this.lastMessageDate,
    required this.seen,
  });

  factory InboxPreviewModel.fromJson(Map<String, dynamic> json) {
    return InboxPreviewModel(
      userId: json['userId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      lastMessageSender: json['lastMessageSender'],
      lastMessage: json['lastMessage'],
      lastMessageDate:
          DateTime.tryParse(json['lastMessageDate']) ?? DateTime.now(),
      seen: json['seen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl,
      'lastMessage': lastMessage,
      'lastMessageDate': lastMessageDate.toIso8601String(),
      'seen': seen,
    };
  }
}
