import 'package:flutter/material.dart';
import 'package:nearby_assist/providers/auth_provider.dart';
import 'package:nearby_assist/providers/inbox_provider.dart';
import 'package:nearby_assist/routing/app_router.dart';
import 'package:nearby_assist/services/logger.dart';
import 'package:provider/provider.dart';

final logger = ConsoleLogger();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => InboxProvider()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _App();
}

class _App extends State<App> {
  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthProvider>().status;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'NearbyAssist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      routerConfig: generateRoutes(authStatus),
    );
  }
}
