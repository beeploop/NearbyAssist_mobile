import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class SystemSettingProvider extends ChangeNotifier {
  String _serverURL = "";

  String get serverURL => _serverURL;

  Future<void> changeServerURL(String url) async {
    logger.logDebug(
        'called changeServerURL with value: $url, in system_settings_provider.dart');

    _serverURL = url;

    final storage = SecureStorage();
    await storage.updateServerURL(url);

    endpoint.changeURL(url);

    notifyListeners();
  }
}
