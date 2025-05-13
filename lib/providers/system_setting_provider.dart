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

enum SugestionCriterion {
  price(name: 'price', identifier: 'p'),
  rating(name: 'rating', identifier: 'r'),
  distance(name: 'distance', identifier: 'd'),
  completedBookings(name: 'completed bookings', identifier: 'b'),
  ;

  const SugestionCriterion({required this.identifier, required this.name});
  final String identifier;
  final String name;
}

class SystemSettingProvider extends ChangeNotifier {
  String _serverURL = endpoint.baseUrl;
  SearchPageVersion _searchPageVersion = SearchPageVersion.version2;
  List<SugestionCriterion> _criteriaRanking = [
    SugestionCriterion.price,
    SugestionCriterion.distance,
    SugestionCriterion.rating,
    SugestionCriterion.completedBookings,
  ];

  static final SystemSettingProvider _instance =
      SystemSettingProvider._internal();

  SystemSettingProvider._internal();

  factory SystemSettingProvider() => _instance;

  String get serverURL => _serverURL;
  SearchPageVersion get welcomePage => _searchPageVersion;
  bool get isSearchPageV2 => _searchPageVersion == SearchPageVersion.version2;
  List<SugestionCriterion> get criteriaRanking => _criteriaRanking;

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

  Future<void> reorderCriterion(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = _criteriaRanking.removeAt(oldIndex);
    _criteriaRanking.insert(newIndex, item);
    await SecureStorage().saveSettings(this);
    notifyListeners();

    logger.logDebug('reordered criterion');
    for (final criteria in _criteriaRanking) {
      logger.logDebug(criteria.name);
    }
  }

  loadFromJson(Map<String, dynamic> json) {
    logger.logDebug('loaded setting from json: $json');
    final welcomeType = switch (json['welcome_page_type'] as String) {
      'version1' => SearchPageVersion.version1,
      'version2' => SearchPageVersion.version2,
      _ => SearchPageVersion.version1,
    };
    _searchPageVersion = welcomeType;

    _serverURL =
        json['server_url'] == '' ? endpoint.baseUrl : json['server_url'];

    _criteriaRanking =
        ((json['criteria_ranking'] ?? []) as List).map((criteria) {
      switch (criteria as String) {
        case 'p':
          return SugestionCriterion.price;
        case 'r':
          return SugestionCriterion.rating;
        case 'd':
          return SugestionCriterion.distance;
        case 'b':
          return SugestionCriterion.completedBookings;
        default:
          return SugestionCriterion.price;
      }
    }).toList();

    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'server_url': serverURL,
      'welcome_page_type': welcomePage.id,
      'criteria_ranking':
          _criteriaRanking.map((criteria) => criteria.identifier).toList(),
    };
  }
}
