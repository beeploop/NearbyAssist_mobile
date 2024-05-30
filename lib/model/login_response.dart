class LoginResponse {
  String accessToken;
  String refreshToken;
  int userId;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
    );
  }
}
