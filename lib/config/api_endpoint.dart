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

  String get search => '$_baseUrl/api/v1/services/search';
  String get serviceDetails => '$_baseUrl/api/v1/services';
  String get findRoute => '$_baseUrl/api/v1/services/route';

  String get websocket => '$_wsUrl/api/v1/chat/ws';
  String get conversations => '$_baseUrl/api/v1/chat/conversations';
}
