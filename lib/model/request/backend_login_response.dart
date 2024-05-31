class BackendLoginResponse {
  String accessToken;
  String refreshToken;
  int userId;

  BackendLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  factory BackendLoginResponse.fromJson(Map<String, dynamic> json) {
    return BackendLoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': userId,
    };
  }
}
