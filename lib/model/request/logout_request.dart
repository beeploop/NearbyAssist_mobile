class LogoutRequest {
  String refreshToken;

  LogoutRequest({
    required this.refreshToken,
  });

  factory LogoutRequest.fromJson(Map<String, dynamic> json) {
    return LogoutRequest(
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}
