class UserInfo {
  String name;
  String email;
  String imageUrl;
  int? userId;

  UserInfo({
    required this.name,
    required this.email,
    required this.imageUrl,
    this.userId,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      name: json['name'],
      imageUrl: json['picture']['data']['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}
