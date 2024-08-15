class Conversation {
  int userId;
  String name;
  String imageUrl;

  Conversation({
    required this.name,
    required this.imageUrl,
    required this.userId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId: json['userId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
