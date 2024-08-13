class UserInfo {
  String name;
  String email;
  String imageUrl;
  int id;
  bool verified;

  UserInfo({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.id,
    required this.verified,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      id: json['id'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'verified': verified,
    };
  }
}
