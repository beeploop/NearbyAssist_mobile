import 'package:flutter/material.dart';
import 'package:nearby_assist/screens/home.dart';
import 'package:nearby_assist/screens/login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const Homapage());
      case "/login":
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('error page'),
        ),
      ),
    );
  }
}
