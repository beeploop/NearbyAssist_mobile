import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/account/account_page.dart';
import 'package:nearby_assist/pages/account/information_page.dart';
import 'package:nearby_assist/pages/account/profile/profile_page.dart';
import 'package:nearby_assist/pages/account/profile/verify_account_page.dart';
import 'package:nearby_assist/pages/account/report_page.dart';
import 'package:nearby_assist/pages/account/services/add_service_page.dart';
import 'package:nearby_assist/pages/account/services/edit_service_page.dart';
import 'package:nearby_assist/pages/account/services/manage_services_page.dart';
import 'package:nearby_assist/pages/account/services/service_detail_page.dart';
import 'package:nearby_assist/pages/account/services/vendor_application_page.dart';
import 'package:nearby_assist/pages/account/settings/settings_page.dart';
import 'package:nearby_assist/pages/saves/saves_page.dart';
import 'package:nearby_assist/pages/chat/chat_page.dart';
import 'package:nearby_assist/pages/chat/inbox_page.dart';
import 'package:nearby_assist/pages/login/login_page.dart';
import 'package:nearby_assist/pages/search/map_page.dart';
import 'package:nearby_assist/pages/search/route_page.dart';
import 'package:nearby_assist/pages/search/search_page.dart';
import 'package:nearby_assist/pages/test_page.dart';
import 'package:nearby_assist/routing/route_name.dart';
import 'package:nearby_assist/routing/scaffold_with_navbar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutPath.login.path,
  routes: [
    GoRoute(
      path: RoutPath.login.path,
      name: RoutPath.login.name,
      builder: (context, state) => const LoginPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => ScaffoldWithNavBar(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
              path: RoutPath.search.path,
              name: RoutPath.search.name,
              builder: (context, state) => const SearchPage(),
              routes: [
                GoRoute(
                    path: RoutPath.map.path,
                    name: RoutPath.map.name,
                    builder: (context, state) => const MapPage(),
                    routes: [
                      GoRoute(
                          path: RoutPath.vendor.path,
                          name: RoutPath.vendor.name,
                          builder: (context, state) {
                            final serviceId =
                                state.uri.queryParameters['serviceId']!;
                            return ServiceDetailPage(serviceId: serviceId);
                          }),
                    ]),
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: RoutPath.inbox.path,
            name: RoutPath.inbox.name,
            builder: (context, state) => const InboxPage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: RoutPath.saves.path,
            name: RoutPath.saves.name,
            builder: (context, state) => const SavesPage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: RoutPath.account.path,
              name: RoutPath.account.name,
              builder: (context, state) => const AccountPage()),
        ]),
      ],
    ),
    GoRoute(
        path: RoutPath.route.path,
        name: RoutPath.route.name,
        builder: (context, state) {
          final serviceId = state.uri.queryParameters['serviceId']!;
          return RoutePage(serviceId: serviceId);
        }),
    GoRoute(
        path: RoutPath.chat.path,
        name: RoutPath.chat.name,
        builder: (context, state) {
          final recipientId = state.uri.queryParameters['recipientId']!;
          final recipient = state.uri.queryParameters['recipient']!;

          return ChatPage(recipientId: recipientId, recipient: recipient);
        }),
    GoRoute(
        path: RoutPath.profile.path,
        name: RoutPath.profile.name,
        builder: (context, state) => const ProfilePage()),
    GoRoute(
        path: RoutPath.settings.path,
        name: RoutPath.settings.name,
        builder: (context, state) => const SettingsPage()),
    GoRoute(
        path: RoutPath.manage.path,
        name: RoutPath.manage.name,
        builder: (context, state) => const ManageServices(),
        routes: [
          GoRoute(
            path: RoutPath.addService.path,
            name: RoutPath.addService.name,
            builder: (context, state) => const AddServicePage(),
            routes: [
              GoRoute(
                path: RoutPath.locationPicker.path,
                name: RoutPath.locationPicker.name,
                builder: (context, state) => const TestPage(),
              ),
            ],
          ),
          GoRoute(
              path: RoutPath.detail.path,
              name: RoutPath.detail.name,
              builder: (context, state) {
                final serviceId = state.uri.queryParameters['serviceId']!;
                return ServiceDetailPage(serviceId: serviceId, edittable: true);
              }),
          GoRoute(
              path: RoutPath.editService.path,
              name: RoutPath.editService.name,
              builder: (context, state) {
                final serviceId = state.uri.queryParameters['serviceId']!;
                return EditServicePage(serviceId: serviceId);
              },
              routes: [
                GoRoute(
                    path: RoutPath.editLocation.path,
                    name: RoutPath.editLocation.name,
                    builder: (context, state) => const TestPage())
              ]),
        ]),
    GoRoute(
        path: RoutPath.verifyAccount.path,
        name: RoutPath.verifyAccount.name,
        builder: (context, state) => const VerifyAccountPage()),
    GoRoute(
        path: RoutPath.vendorApplication.path,
        name: RoutPath.vendorApplication.name,
        builder: (context, state) => const VendorApplicationPage()),
    GoRoute(
        path: RoutPath.report.path,
        name: RoutPath.report.name,
        builder: (context, state) => const ReportPage()),
    GoRoute(
        path: RoutPath.information.path,
        name: RoutPath.information.name,
        builder: (context, state) => const InformationPage()),
  ],
);
