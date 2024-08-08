class UserInfo {
  String name;
  String email;
  String image;
  int userId;
  bool verified;

  UserInfo({
    required this.name,
    required this.email,
    required this.image,
    required this.userId,
    required this.verified,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      name: json['name'],
      image: json['imageUrl'],
      userId: json['id'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'image': image,
      'verified': verified,
    };
  }
}
