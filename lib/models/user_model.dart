class UserModel {
  String id;
  String name;
  String email;
  String imageUrl;
  bool isVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      isVerified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'isVerified': isVerified,
    };
  }
}
