class LoginPayloadModel {
  String name;
  String email;
  String imageUrl;

  LoginPayloadModel({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory LoginPayloadModel.fromFacebook(Map<String, dynamic> response) {
    return LoginPayloadModel(
      name: response['name'],
      email: response['email'],
      imageUrl: response['picture']['data']['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'image': imageUrl,
    };
  }
}
