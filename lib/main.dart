import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/router/app_router.dart';
import 'package:nearby_assist/services/feature_flag_service.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/message_service.dart';
import 'package:nearby_assist/services/vendor_service.dart';
import 'package:nearby_assist/services/search_service.dart';

GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<FeatureFlagService>(FeatureFlagService());
  getIt.registerSingleton<AuthModel>(AuthModel());
  getIt.registerSingleton<SearchingService>(SearchingService());
  getIt.registerSingleton<LocationService>(LocationService());
  getIt.registerSingleton<VendorService>(VendorService());
  getIt.registerSingleton<MessageService>(MessageService());

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
