class Conversation {
  String name;
  String imageUrl;
  int userId;

  Conversation({
    required this.name,
    required this.imageUrl,
    required this.userId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      name: json['Name'],
      imageUrl: json['ImageUrl'],
      userId: json['Id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
