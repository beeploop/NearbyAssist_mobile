import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/secure_storage.dart';

enum WelcomePageType {
  type1(id: 'type1', name: 'version 1'),
  type2(id: 'type2', name: 'version 2');

  const WelcomePageType({required this.id, required this.name});
  final String id;
  final String name;
}

class SystemSettingProvider extends ChangeNotifier {
  String _serverURL = endpoint.baseUrl;
  WelcomePageType _welcomePage = WelcomePageType.type2;

  static final SystemSettingProvider _instance =
      SystemSettingProvider._internal();

  SystemSettingProvider._internal();

  factory SystemSettingProvider() => _instance;

  String get serverURL => _serverURL;
  WelcomePageType get welcomePage => _welcomePage;
  bool get isWelcomePageV2 => _welcomePage == WelcomePageType.type2;

  Future<void> changeServerURL(String url) async {
    logger.logDebug('changed server url: $url');
    _serverURL = url;
    endpoint.changeURL(url);
    await SecureStorage().saveSettings(this);
    notifyListeners();
  }

  Future<void> changeWelcomePage(WelcomePageType type) async {
    logger.logDebug('changed welcome page type: ${type.name}');
    _welcomePage = type;
    await SecureStorage().saveSettings(this);
    notifyListeners();
  }

  loadFromJson(Map<String, dynamic> json) {
    logger.logDebug('loaded setting from json: $json');
    final welcomeType = switch (json['welcome_page_type'] as String) {
      'type1' => WelcomePageType.type1,
      'type2' => WelcomePageType.type2,
      _ => WelcomePageType.type1,
    };

    _serverURL =
        json['server_url'] == '' ? endpoint.baseUrl : json['server_url'];
    _welcomePage = welcomeType;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'server_url': serverURL,
      'welcome_page_type': welcomePage.id,
    };
  }
}
