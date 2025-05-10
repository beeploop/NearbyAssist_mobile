import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/config/assets.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/account/account_page.dart';
import 'package:nearby_assist/pages/account/bookings/confirmed/confirmed_requests_page.dart';
import 'package:nearby_assist/pages/account/bookings/history/client_history_page.dart';
import 'package:nearby_assist/pages/account/bookings/pending/pending_request_page.dart';
import 'package:nearby_assist/pages/account/bookings/to_rate/to_rate_page.dart';
import 'package:nearby_assist/pages/account/profile/profile_page.dart';
import 'package:nearby_assist/pages/account/profile/verify_account_page.dart';
import 'package:nearby_assist/pages/account/report/report_issue_page.dart';
import 'package:nearby_assist/pages/account/vendor_application/application_page.dart';
import 'package:nearby_assist/pages/account/settings/app_settings_page.dart';
import 'package:nearby_assist/pages/account/control_center/control_center_page.dart';
import 'package:nearby_assist/pages/notification/notification_list_page.dart';
import 'package:nearby_assist/pages/saves/saves_page.dart';
import 'package:nearby_assist/pages/chat/chat_page.dart';
import 'package:nearby_assist/pages/chat/inbox_page.dart';
import 'package:nearby_assist/pages/login/login_page.dart';
import 'package:nearby_assist/pages/search/map_page.dart';
import 'package:nearby_assist/pages/search/route_page.dart';
import 'package:nearby_assist/pages/search/search_page.dart';
import 'package:nearby_assist/pages/search/service_view_page.dart';
import 'package:nearby_assist/pages/vendor/vendor_page.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/providers/websocket_provider.dart';
import 'package:nearby_assist/routing/route_name.dart';
import 'package:nearby_assist/routing/scaffold_with_navbar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter generateRoutes(
  UserProvider userProvider,
  WebsocketProvider websocketProvider,
) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePath.search.path,
    refreshListenable: userProvider,
    redirect: (context, state) async {
      if (userProvider.status == AuthStatus.unauthenticated) {
        logger.logDebug('user provider status: unauthenticated');
        websocketProvider.disconnect();
        return RoutePath.login.path;
      }

      // If authenticated and on login page, redirect to search page
      if (state.uri == Uri.parse('/login')) {
        return RoutePath.search.path;
      }

      await websocketProvider.connect();

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePath.login.path,
        name: RoutePath.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ScaffoldWithNavBar(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePath.search.path,
              name: RoutePath.search.name,
              builder: (context, state) => const SearchPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePath.inbox.path,
              name: RoutePath.inbox.name,
              builder: (context, state) => const InboxPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePath.saves.path,
              name: RoutePath.saves.name,
              builder: (context, state) => const SavesPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: RoutePath.account.path,
                name: RoutePath.account.name,
                builder: (context, state) => const AccountPage()),
          ]),
        ],
      ),
      GoRoute(
          path: RoutePath.map.path,
          name: RoutePath.map.name,
          builder: (context, state) => const MapPage()),
      GoRoute(
          path: RoutePath.notifications.path,
          name: RoutePath.notifications.name,
          builder: (context, state) {
            return const NotificationListPage();
          }),
      GoRoute(
          path: RoutePath.viewService.path,
          name: RoutePath.viewService.name,
          builder: (context, state) {
            final serviceId = state.uri.queryParameters['serviceId']!;
            return ServiceViewPage(serviceId: serviceId);
          }),
      GoRoute(
          path: RoutePath.vendorPage.path,
          name: RoutePath.vendorPage.name,
          builder: (context, state) {
            final vendorId = state.uri.queryParameters['vendorId']!;
            return VendorPage(vendorId: vendorId);
          }),
      GoRoute(
          path: RoutePath.route.path,
          name: RoutePath.route.name,
          builder: (context, state) {
            final serviceId = state.uri.queryParameters['serviceId']!;
            final vendorName = state.uri.queryParameters['vendorName'] ?? '';
            return RoutePage(serviceId: serviceId, vendorName: vendorName);
          }),
      GoRoute(
          path: RoutePath.chat.path,
          name: RoutePath.chat.name,
          builder: (context, state) {
            final recipientId = state.uri.queryParameters['recipientId']!;
            final recipient = state.uri.queryParameters['recipient']!;

            return ChatPage(recipientId: recipientId, recipient: recipient);
          }),
      GoRoute(
          path: RoutePath.profile.path,
          name: RoutePath.profile.name,
          builder: (context, state) => const ProfilePage()),
      GoRoute(
          path: RoutePath.settings.path,
          name: RoutePath.settings.name,
          builder: (context, state) => const AppSettingPage()),
      GoRoute(
          path: RoutePath.verifyAccount.path,
          name: RoutePath.verifyAccount.name,
          builder: (context, state) => const VerifyAccountPage()),
      GoRoute(
          path: RoutePath.vendorApplication.path,
          name: RoutePath.vendorApplication.name,
          builder: (context, state) => const ApplicationPage()),
      GoRoute(
          path: RoutePath.reportIssue.path,
          name: RoutePath.reportIssue.name,
          builder: (context, state) => const ReportIssuePage()),
      GoRoute(
          path: RoutePath.pendings.path,
          name: RoutePath.pendings.name,
          builder: (context, state) => const PendingRequestPage()),
      GoRoute(
          path: RoutePath.confirmed.path,
          name: RoutePath.confirmed.name,
          builder: (context, state) => const ConfirmedRequestsPage()),
      GoRoute(
          path: RoutePath.toRate.path,
          name: RoutePath.toRate.name,
          builder: (context, state) => const ToRatePage()),
      GoRoute(
          path: RoutePath.history.path,
          name: RoutePath.history.name,
          builder: (context, state) => const ClientHistoryPage()),
      GoRoute(
          path: RoutePath.controlCenter.path,
          name: RoutePath.controlCenter.name,
          builder: (context, state) => const ControlCenterPage()),
      GoRoute(
          path: RoutePath.licenses.path,
          name: RoutePath.licenses.name,
          builder: (context, state) => LicensePage(
                applicationName: appName,
                applicationVersion: appVersion,
                applicationLegalese: appLegalese,
                applicationIcon:
                    Image.asset(Assets.splashIcon, width: 100, height: 100),
              )),
    ],
  );
}
