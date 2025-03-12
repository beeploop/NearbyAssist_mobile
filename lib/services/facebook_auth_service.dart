import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nearby_assist/models/third_party_login_payload_model.dart';

class FacebookAuthService {
  Future<ThirdPartyLoginPayloadModel> login() async {
    try {
      final result = await FacebookAuth.instance.login(
        loginBehavior: LoginBehavior.dialogOnly,
      );
      if (result.status != LoginStatus.success) {
        throw FacebookAuthException(result.status.toString());
      }

      final userData = await FacebookAuth.instance.getUserData();

      return ThirdPartyLoginPayloadModel.fromFacebook(userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (error) {
      rethrow;
    }
  }
}

class FacebookAuthException implements Exception {
  final String message;

  FacebookAuthException(this.message);
}
