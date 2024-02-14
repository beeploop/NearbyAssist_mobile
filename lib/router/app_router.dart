import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/screens/home.dart';
import 'package:nearby_assist/screens/login.dart';

class AppRouter {
  final router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            return const Homapage();
          }),
      GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            return const LoginPage();
          }),
    ],
    redirect: (context, state) {
      final loginStatus = getIt.get<AuthModel>().getLoginStatus();

      if (loginStatus == AuthStatus.unauthenticated) {
        return '/login';
      }

      return '/';
    },
    refreshListenable: getIt.get<AuthModel>(),
  );
}
