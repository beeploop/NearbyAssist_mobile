import 'package:google_sign_in/google_sign_in.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/login_payload_model.dart';

class GoogleAuthService {
  final List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  Future<LoginPayloadModel> login() async {
    try {
      final user = await GoogleSignIn(scopes: scopes).signIn();
      if (user == null) {
        throw GoogleNullUserException('Google sign in returned null user');
      }

      return LoginPayloadModel(
        name: user.displayName ?? '',
        email: user.email,
        imageUrl: user.photoUrl ?? fallbackUserImage,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn(scopes: scopes).signOut();
    } catch (error) {
      rethrow;
    }
  }
}

class GoogleNullUserException implements Exception {
  final String message;

  GoogleNullUserException(this.message);
}
