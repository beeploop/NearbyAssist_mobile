class UserInfo {
  String name;
  String email;
  String imageUrl;

  UserInfo({
    required this.name,
    required this.email,
    required this.imageUrl,
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
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}
