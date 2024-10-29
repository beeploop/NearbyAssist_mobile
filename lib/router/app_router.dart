import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/screens/account_page.dart';
import 'package:nearby_assist/screens/add_service.dart';
import 'package:nearby_assist/screens/chat.dart';
import 'package:nearby_assist/screens/destination_route.dart';
import 'package:nearby_assist/screens/edit_service.dart';
import 'package:nearby_assist/screens/home.dart';
import 'package:nearby_assist/screens/information.dart';
import 'package:nearby_assist/screens/location_picker.dart';
import 'package:nearby_assist/screens/profile_page.dart';
import 'package:nearby_assist/screens/search.dart';
import 'package:nearby_assist/screens/service_detail.dart';
import 'package:nearby_assist/screens/login.dart';
import 'package:nearby_assist/screens/conversations.dart';
import 'package:nearby_assist/screens/map_page.dart';
import 'package:nearby_assist/screens/my_services.dart';
import 'package:nearby_assist/screens/report_issue.dart';
import 'package:nearby_assist/screens/settings.dart';
import 'package:nearby_assist/screens/vendor.dart';
import 'package:nearby_assist/screens/vendor_register.dart';
import 'package:nearby_assist/screens/verify_identity.dart';
import 'package:nearby_assist/services/logger_service.dart';
import 'package:nearby_assist/widgets/scaffold_with_navbar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

enum RoutPath {
  login(path: "/login"),

  home(path: "/home"),

  search(path: "/search"),
  map(path: "map"),
  vendor(path: "vendor"),
  route(path: "route"),

  messages(path: "/messages"),

  chat(path: "/chat"),

  account(path: "/account"),

  profile(path: "/profile"),

  settings(path: "/settings"),

  services(path: "/services"),
  detail(path: "detail"),
  locationPicker(path: "locationPicker"),
  editLocation(path: "editLocation"),
  addService(path: "addService"),
  editService(path: "editService"),

  verifyIdentity(path: "/verifyIdentity"),
  registerVendor(path: "/registerVendor"),

  information(path: "/information"),
  report(path: "/report");

  const RoutPath({required this.path});
  final String path;
}

class AppRouter {
  final router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      redirect: (context, state) {
        try {
          final loginStatus = getIt.get<AuthModel>().getLoginStatus();
          getIt.get<AuthModel>().getTokens();

          if (loginStatus == AuthStatus.unauthenticated) {
            throw Exception('User is not authenticated');
          }
          return null;
        } catch (e) {
          ConsoleLogger().log('Redirecting to login due to error: $e');
          return '/login';
        }
      },
      refreshListenable: getIt.get<AuthModel>(),
      initialLocation: RoutPath.home.path,
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
                path: RoutPath.home.path,
                name: RoutPath.home.name,
                builder: (context, state) => const Homepage(),
              ),
            ]),
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
                                return Vendor(serviceId: serviceId);
                              },
                              routes: [
                                GoRoute(
                                    path: RoutPath.route.path,
                                    name: RoutPath.route.name,
                                    builder: (context, state) {
                                      final serviceId = state
                                          .uri.queryParameters['serviceId']!;
                                      return DestinationRoute(
                                          serviceId: serviceId);
                                    }),
                              ]),
                        ]),
                  ]),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: RoutPath.messages.path,
                name: RoutPath.messages.name,
                builder: (context, state) => const Conversations(),
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
            path: RoutPath.chat.path,
            name: RoutPath.chat.name,
            builder: (context, state) {
              final userId = state.uri.queryParameters['userId']!;
              final vendorName = state.uri.queryParameters['vendorName']!;

              return Chat(recipientId: userId, name: vendorName);
            }),
        GoRoute(
            path: RoutPath.profile.path,
            name: RoutPath.profile.name,
            builder: (context, state) => const ProfilePage()),
        GoRoute(
            path: RoutPath.settings.path,
            name: RoutPath.settings.name,
            builder: (context, state) => const Settings()),
        GoRoute(
            path: RoutPath.services.path,
            name: RoutPath.services.name,
            builder: (context, state) => const MyServices(),
            routes: [
              GoRoute(
                path: RoutPath.addService.path,
                name: RoutPath.addService.name,
                builder: (context, state) => const AddService(),
                routes: [
                  GoRoute(
                    path: RoutPath.locationPicker.path,
                    name: RoutPath.locationPicker.name,
                    builder: (context, state) => const LocationPicker(),
                  ),
                ],
              ),
              GoRoute(
                  path: RoutPath.detail.path,
                  name: RoutPath.detail.name,
                  builder: (context, state) {
                    final serviceId = state.uri.queryParameters['serviceId']!;
                    return ServiceDetail(serviceId: serviceId);
                  }),
              GoRoute(
                  path: RoutPath.editService.path,
                  name: RoutPath.editService.name,
                  builder: (context, state) {
                    final serviceId = state.uri.queryParameters['serviceId']!;
                    return EditService(serviceId: serviceId);
                  },
                  routes: [
                    GoRoute(
                        path: RoutPath.editLocation.path,
                        name: RoutPath.editLocation.name,
                        builder: (context, state) => const LocationPicker())
                  ]),
            ]),
        GoRoute(
            path: RoutPath.verifyIdentity.path,
            name: RoutPath.verifyIdentity.name,
            builder: (context, state) => const VerifyIdentity()),
        GoRoute(
            path: RoutPath.registerVendor.path,
            name: RoutPath.registerVendor.name,
            builder: (context, state) => const VendorRegister()),
        GoRoute(
            path: RoutPath.report.path,
            name: RoutPath.report.name,
            builder: (context, state) => const ReportIssue()),
        GoRoute(
            path: RoutPath.information.path,
            name: RoutPath.information.name,
            builder: (context, state) => const InformationPage()),
      ]);
}
