import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoint {
  final String _baseUrl;
  final String _wsUrl;

  ApiEndpoint({required String baseUrl, required String wsUrl})
      : _baseUrl = baseUrl,
        _wsUrl = wsUrl;

  factory ApiEndpoint.fromEnv() {
    final baseUrl = dotenv.get('API_URL', fallback: 'http://localhost:3000');
    final wsUrl = dotenv.get('WS_URL', fallback: 'ws://localhost:3000');
    return ApiEndpoint(baseUrl: baseUrl, wsUrl: wsUrl);
  }

  String get baseUrl => _baseUrl;

  // Health check
  String get healthcheck => '$_baseUrl/api/v1/health/protected';

  String get reverseGeocoding => 'https://nominatim.openstreetmap.org/reverse';

  // Auth Routes
  String get login => '$_baseUrl/api/v1/user/login';
  String get logout => '$_baseUrl/api/v1/user/logout';
  String get refresh => '$_baseUrl/api/v1/user/refresh';

  String get saveKeys => '$_baseUrl/api/v1/e2ee';
  String get getKeys => '$_baseUrl/api/v1/e2ee/keys';
  String get getPublicKey => '$_baseUrl/api/v1/e2ee/key';

  String get me => '$_baseUrl/api/v1/user/protected/me';

  String get privacyPolicy => '$_baseUrl/privacy_policy';
  String get termsAndConditions => '$_baseUrl/terms_and_conditions';

  String get verifyAccount => '$_baseUrl/api/v1/verification/identity';
  String get vendorApplication => '$_baseUrl/api/v1/applications';

  String get search => '$_baseUrl/api/v1/services/search';
  String get serviceDetails => '$_baseUrl/api/v1/services';
  String get findRoute => '$_baseUrl/api/v1/services/route';

  String get websocket => '$_wsUrl/api/v1/chat/ws';
  String get conversations => '$_baseUrl/api/v1/chat/conversations';
  String get getMessages => '$_baseUrl/api/v1/chat/messages';
  String get sendMessage => '$_baseUrl/api/v1/chat/send';

  String get vendor => '$_baseUrl/api/v1/vendors';
  String get vendorServices => '$_baseUrl/api/v1/vendors/services';

  String get addService => '$_baseUrl/api/v1/services';

  String get savedServices => '$_baseUrl/api/v1/services/get-saved';
  String get saveService => '$_baseUrl/api/v1/services/save';
  String get unsaveService => '$_baseUrl/api/v1/services/unsave';

  String get createBooking => '$_baseUrl/api/v1/transactions';
  String get cancelBooking => '$_baseUrl/api/v1/transactions/cancel';
  String get getTransaction => '$_baseUrl/api/v1/transactions';
  String get recent => '$_baseUrl/api/v1/transactions/recent';
  String get history => '$_baseUrl/api/v1/transactions/history';
  String get ongoing => '$_baseUrl/api/v1/transactions/ongoing';
  String get myRequests => '$_baseUrl/api/v1/transactions/mine';
  String get clientRequests => '$_baseUrl/api/v1/transactions/mine';

  String get expertiseList => '$_baseUrl/api/v1/tags/expertise';
}
