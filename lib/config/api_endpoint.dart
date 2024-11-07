import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoint {
  final String _baseUrl;

  ApiEndpoint({required String baseUrl}) : _baseUrl = baseUrl;

  factory ApiEndpoint.fromEnv() {
    final endpoint = dotenv.get('API_URL', fallback: 'http://localhost:3000');
    return ApiEndpoint(baseUrl: endpoint);
  }

  String get baseUrl => _baseUrl;

  // Health check
  String get healthcheck => '$_baseUrl/api/v1/health/protected';

  // Auth Routes
  String get login => '$_baseUrl/api/v1/user/login';
  String get logout => '$_baseUrl/api/v1/user/logout';
  String get refresh => '$_baseUrl/api/v1/user/refresh';
}
