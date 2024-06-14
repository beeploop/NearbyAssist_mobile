import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/services/request/request.dart';

class AuthenticatedRequest<T extends Object> extends Request {
  @override
  Future<T> request(String endpoint, String method,
      {Map<String, dynamic>? body}) async {
    http.Response response = await makeRequest(endpoint, method, body: body);

    if (response.statusCode == 401) {
      await _refreshToken();
      response = await makeRequest(endpoint, method, body: body);
    }

    T data = jsonDecode(response.body);
    return data;
  }

  Future<void> _refreshToken() async {
    final tokens = getIt.get<AuthModel>().getUserTokens();
    if (tokens == null) {
      throw Exception('No tokens found');
    }

    final url = Uri.parse('$serverAddr/backend/auth/refresh');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokens.accessToken}',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'token': tokens.refreshToken,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to refresh token');
    }

    final updatedTokens = Token(
      accessToken: jsonDecode(response.body)['accessToken'],
      refreshToken: tokens.refreshToken,
    );

    getIt.get<AuthModel>().setUserTokens(updatedTokens);
  }
}
