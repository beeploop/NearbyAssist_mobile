import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/user_model.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  UserModel? _user = UserModel(
    id: '1',
    name: 'John Doe',
    email: 'jd@email.com',
    imageUrl: 'assets/images/avatar.png',
    isVerified: true,
  );

  UserModel get user => _user!;

  AuthStatus get status =>
      _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;

  void login(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
