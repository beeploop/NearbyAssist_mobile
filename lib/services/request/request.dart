import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/settings_model.dart';

abstract class Request {
  String serverAddr = getIt.get<SettingsModel>().getServerAddr();

  Future request(String endpoint, String method, {Map<String, dynamic>? body});

  Future<http.Response> makeRequest(String endpoint, String method,
      {Map<String, dynamic>? body}) async {
    final tokens = getIt.get<AuthModel>().getUserTokens();
    if (tokens == null) {
      throw Exception('No tokens found');
    }

    final url = Uri.parse('$serverAddr/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokens.accessToken}',
    };

    http.Response response;
    switch (method) {
      case "GET":
        response = await http.get(
          url,
          headers: headers,
        );
        break;
      case "POST":
        response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
      default:
        throw Exception('Unsupported method');
    }

    return response;
  }
}
