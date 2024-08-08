import 'package:nearby_assist/model/user_info.dart';

class BackendLoginResponse {
  String accessToken;
  String refreshToken;
  UserInfo user;

  BackendLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory BackendLoginResponse.fromJson(Map<String, dynamic> json) {
    return BackendLoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: UserInfo.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
}
