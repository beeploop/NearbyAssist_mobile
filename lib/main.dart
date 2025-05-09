import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:nearby_assist/providers/client_booking_provider.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/notifications_provider.dart';
import 'package:nearby_assist/providers/recommendation_provider.dart';
import 'package:nearby_assist/providers/system_setting_provider.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/one_signal_service.dart';
import 'package:nearby_assist/config/api_endpoint.dart';
import 'package:nearby_assist/providers/expertise_provider.dart';
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
import 'package:nearby_assist/services/secure_storage.dart';
import 'package:provider/provider.dart';

final logger = CustomLogger();
late ApiEndpoint endpoint;

void main() async {
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // Load .env file dynamically via --dart-define
  const env = String.fromEnvironment('ENV_FILE', defaultValue: '.env');
  await dotenv.load(fileName: env);

  // Initialize the API endpoints
  endpoint = ApiEndpoint.fromEnv();

  // Load saved settings
  await SecureStorage().loadSettings();

  OneSignalService().initialize();

  final websockerProvider = WebsocketProvider();
  websockerProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SystemSettingProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
        ChangeNotifierProvider(create: (context) => VendorProvider()),
        ChangeNotifierProvider(create: (context) => RouteProvider()),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
        ChangeNotifierProvider(create: (context) => websockerProvider),
        ChangeNotifierProvider(create: (context) => SavesProvider()),
        ChangeNotifierProvider(create: (context) => ExpertiseProvider()),
        ChangeNotifierProvider(create: (context) => NotificationsProvider()),
        ChangeNotifierProvider(create: (context) => RecommendationProvider()),
        ChangeNotifierProvider(create: (context) => ClientBookingProvider()),
        ChangeNotifierProvider(create: (context) => ControlCenterProvider()),
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
    try {
      logger.logDebug('called initialization in main.dart');
      await LocationService().requestPermissions();
      await loadUser();
      await loadTags();
    } catch (error) {
      logger.logError(error.toString());
    } finally {
      FlutterNativeSplash.remove();
    }
  }

  Future<void> loadUser() async {
    await context.read<UserProvider>().tryLoadUser();
  }

  Future<void> loadTags() async {
    await context.read<ExpertiseProvider>().tryLoadLocal();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final websocketProvider = context.read<WebsocketProvider>();
    final messageProvider = context.read<MessageProvider>();
    final notificationProvider = context.read<NotificationsProvider>();
    final clientBookingProvider = context.read<ClientBookingProvider>();
    final expertiseProvider = context.read<ExpertiseProvider>();

    websocketProvider.setMessageProvider(messageProvider);
    websocketProvider.setNotifProvider(notificationProvider);
    websocketProvider.setUserProvider(userProvider);
    websocketProvider.setClientBookingProvider(clientBookingProvider);

    notificationProvider.fetchNotifications();
    expertiseProvider.fetchExpertise();

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
