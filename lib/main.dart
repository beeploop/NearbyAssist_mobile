import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:nearby_assist/config/api_endpoint.dart';
import 'package:nearby_assist/providers/managed_service_provider.dart';
import 'package:nearby_assist/providers/message_provider.dart';
import 'package:nearby_assist/providers/route_provider.dart';
import 'package:nearby_assist/providers/saves_provider.dart';
import 'package:nearby_assist/providers/search_provider.dart';
import 'package:nearby_assist/providers/service_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/providers/vendor_provider.dart';
import 'package:nearby_assist/providers/websocket_provider.dart';
import 'package:nearby_assist/routing/app_router.dart';
import 'package:nearby_assist/services/logger.dart';
import 'package:provider/provider.dart';

final logger = ConsoleLogger();
late ApiEndpoint endpoint;

void main() async {
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize the API endpoints
  endpoint = ApiEndpoint.fromEnv();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
        ChangeNotifierProvider(create: (context) => VendorProvider()),
        ChangeNotifierProvider(create: (context) => RouteProvider()),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
        ChangeNotifierProvider(create: (context) => WebsocketProvider()),
        ChangeNotifierProvider(create: (context) => SavesProvider()),
        ChangeNotifierProvider(create: (context) => ManagedServiceProvider()),
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
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    await context.read<UserProvider>().tryLoadUser();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final websocketProvider = context.read<WebsocketProvider>();
    final messageProvider = context.read<MessageProvider>();
    websocketProvider.setMessageProvider(messageProvider);

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
      routerConfig: generateRoutes(userProvider, websocketProvider),
    );
  }
}
