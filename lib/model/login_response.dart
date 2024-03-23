class LoginResponse {
  String token;
  int userId;

  LoginResponse({
    required this.token,
    required this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      userId: json['userId'],
    );
  }
}
