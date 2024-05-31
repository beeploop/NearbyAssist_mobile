class FacebookLoginResponse {
  String name;
  String email;
  String image;

  FacebookLoginResponse({
    required this.name,
    required this.email,
    required this.image,
  });

  factory FacebookLoginResponse.fromJson(Map<String, dynamic> json) {
    return FacebookLoginResponse(
      name: json['name'],
      email: json['email'],
      image: json['picture']['data']['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'image': image,
    };
  }
}
