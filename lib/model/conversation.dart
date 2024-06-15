class Conversation {
  int userId;
  String name;
  String email;
  String imageUrl;

  Conversation({
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.userId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'image': imageUrl,
    };
  }
}
