class ThirdPartyLoginPayloadModel {
  String name;
  String email;
  String imageUrl;

  ThirdPartyLoginPayloadModel({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory ThirdPartyLoginPayloadModel.fromFacebook(
      Map<String, dynamic> response) {
    return ThirdPartyLoginPayloadModel(
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
