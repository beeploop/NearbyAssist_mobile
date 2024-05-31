class LogoutRequest {
  String token;

  LogoutRequest({
    required this.token,
  });

  factory LogoutRequest.fromJson(Map<String, dynamic> json) {
    return LogoutRequest(
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
