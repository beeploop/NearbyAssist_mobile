class LoginPayloadModel {
  String name;
  String email;
  String imageUrl;

  LoginPayloadModel({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'image': imageUrl,
    };
  }
}
