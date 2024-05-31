class LoginRequest {
  String name;
  String email;
  String image;

  LoginRequest({
    required this.name,
    required this.email,
    required this.image,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      name: json['name'],
      email: json['email'],
      image: json['image'],
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
