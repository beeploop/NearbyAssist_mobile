import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/secure_storage.dart';

enum SearchPageVersion {
  version1(id: 'version1', name: 'version 1'),
  version2(id: 'version2', name: 'version 2');

  const SearchPageVersion({required this.id, required this.name});
  final String id;
  final String name;
}

class SystemSettingProvider extends ChangeNotifier {
  String _serverURL = endpoint.baseUrl;
  SearchPageVersion _searchPageVersion = SearchPageVersion.version2;

  static final SystemSettingProvider _instance =
      SystemSettingProvider._internal();

  SystemSettingProvider._internal();

  factory SystemSettingProvider() => _instance;

  String get serverURL => _serverURL;
  SearchPageVersion get welcomePage => _searchPageVersion;
  bool get isSearchPageV2 => _searchPageVersion == SearchPageVersion.version2;

  Future<void> changeServerURL(String url) async {
    logger.logDebug('changed server url: $url');
    _serverURL = url;
    endpoint.changeURL(url);
    await SecureStorage().saveSettings(this);
    notifyListeners();
  }

  Future<void> changeWelcomePage(SearchPageVersion type) async {
    logger.logDebug('changed welcome page type: ${type.name}');
    _searchPageVersion = type;
    await SecureStorage().saveSettings(this);
    notifyListeners();
  }

  loadFromJson(Map<String, dynamic> json) {
    logger.logDebug('loaded setting from json: $json');
    final welcomeType = switch (json['welcome_page_type'] as String) {
      'version1' => SearchPageVersion.version1,
      'version2' => SearchPageVersion.version2,
      _ => SearchPageVersion.version1,
    };

    _serverURL =
        json['server_url'] == '' ? endpoint.baseUrl : json['server_url'];
    _searchPageVersion = welcomeType;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'server_url': serverURL,
      'welcome_page_type': welcomePage.id,
    };
  }
}
