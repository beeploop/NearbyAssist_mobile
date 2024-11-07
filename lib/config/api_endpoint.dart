import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoint {
  final String _baseUrl;

  ApiEndpoint({required String baseUrl}) : _baseUrl = baseUrl;

  factory ApiEndpoint.fromEnv() {
    final endpoint = dotenv.get('API_URL', fallback: 'http://localhost:3000');
    return ApiEndpoint(baseUrl: endpoint);
  }

  String get baseUrl => _baseUrl;
  String get healthcheck => '$_baseUrl/api/v1/health';
}
