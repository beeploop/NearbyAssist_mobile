import 'package:flutter/foundation.dart';

class TokenChangeNotifier extends ChangeNotifier {
  static final TokenChangeNotifier _instance = TokenChangeNotifier._internal();

  TokenChangeNotifier._internal();

  factory TokenChangeNotifier() => _instance;

  void notifyTokenRefreshed() {
    notifyListeners();
  }
}
