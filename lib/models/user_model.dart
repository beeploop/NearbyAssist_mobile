class UserModel {
  String id;
  String name;
  String email;
  String imageUrl;
  bool isVerified;
  bool isVendor;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.isVerified,
    required this.isVendor,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      isVerified: json['isVerified'],
      isVendor: json['isVendor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'isVerified': isVerified,
      'isVendor': isVendor,
    };
  }
}
