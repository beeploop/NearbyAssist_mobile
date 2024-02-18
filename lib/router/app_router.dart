import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/screens/chat.dart';
import 'package:nearby_assist/screens/complaints.dart';
import 'package:nearby_assist/screens/history.dart';
import 'package:nearby_assist/screens/home.dart';
import 'package:nearby_assist/screens/in_progress.dart';
import 'package:nearby_assist/screens/login.dart';
import 'package:nearby_assist/screens/conversations.dart';
import 'package:nearby_assist/screens/map_page.dart';
import 'package:nearby_assist/screens/new_message.dart';

class AppRouter {
  final router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            return const Homapage();
          },
          routes: [
            GoRoute(
                path: 'map',
                name: 'map',
                builder: (context, state) {
                  return const MapPage();
                }),
          ]),
      GoRoute(
          path: '/messages',
          name: 'messages',
          builder: (context, state) {
            return const Conversations();
          },
          routes: [
            GoRoute(
                path: 'new-message',
                name: 'new-message',
                builder: (context, state) {
                  return const NewMessage();
                }),
            GoRoute(
                path: ':userId',
                name: 'chat',
                builder: (context, state) {
                  final userId = state.pathParameters['userId']!;
                  return Chat(userId: userId);
                }),
          ]),
      GoRoute(
          path: '/in-progress',
          name: 'in-progress',
          builder: (context, state) {
            return const InProgress();
          }),
      GoRoute(
          path: '/history',
          name: 'history',
          builder: (context, state) {
            return const History();
          }),
      GoRoute(
          path: '/complaints',
          name: 'complaints',
          builder: (context, state) {
            return const Complaints();
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

      return null;
    },
    refreshListenable: getIt.get<AuthModel>(),
  );
}
