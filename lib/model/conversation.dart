class Conversation {
  String name;
  String image;
  int userId;

  Conversation({
    required this.name,
    required this.image,
    required this.userId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      name: json['Name'],
      image: json['Image'],
      userId: json['Id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'userId': userId,
    };
  }
}
