import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/router/app_router.dart';
import 'package:nearby_assist/services/auth_service.dart';
import 'package:nearby_assist/services/complaint_service.dart';
import 'package:nearby_assist/services/storage_service.dart';
import 'package:nearby_assist/services/feature_flag_service.dart';
import 'package:nearby_assist/services/history_service.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/services/routing_service.dart';
import 'package:nearby_assist/services/system_complaint_service.dart';
import 'package:nearby_assist/services/transaction_service.dart';
import 'package:nearby_assist/services/vendor_service.dart';
import 'package:nearby_assist/services/search_service.dart';
import 'package:nearby_assist/services/verify_identity_service.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  getIt.registerSingleton<FeatureFlagService>(FeatureFlagService());
  getIt.registerSingleton<AuthModel>(AuthModel());
  getIt.registerSingleton<SettingsModel>(SettingsModel());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<SearchingService>(SearchingService());
  getIt.registerSingleton<LocationService>(LocationService());
  getIt.registerSingleton<VendorService>(VendorService());
  getIt.registerSingleton<MessageService>(MessageService());
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<TransactionService>(TransactionService());
  getIt.registerSingleton<HistoryService>(HistoryService());
  getIt.registerSingleton<ComplaintService>(ComplaintService());
  getIt.registerSingleton<SystemComplaintService>(SystemComplaintService());
  getIt.registerSingleton<VerifyIdentityService>(VerifyIdentityService());
  getIt.registerSingleton<RoutingService>(RoutingService());

  // Load settings
  getIt.get<SettingsModel>().loadSettings();
  await getIt.get<StorageService>().loadData();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      routerConfig: AppRouter().router,
    );
  }
}
