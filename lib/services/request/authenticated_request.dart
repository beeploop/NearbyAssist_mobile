import 'dart:convert';
import 'dart:io';
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

  Future<T> multipartRequest(
      String endpoint, List<File> files, List<MultipartFormData> data) async {
    http.StreamedResponse streamResponse =
        await _makeMultipartRequest(endpoint, files, data);

    if (streamResponse.statusCode == 401) {
      await _refreshToken();
      streamResponse = await _makeMultipartRequest(endpoint, files, data);
    }

    final response = await http.Response.fromStream(streamResponse);
    T responseData = jsonDecode(response.body);

    return responseData;
  }

  Future<http.StreamedResponse> _makeMultipartRequest(String endpoint,
      List<File> files, List<MultipartFormData> data) async {
    final tokens = getIt.get<AuthModel>().getUserTokens();
    if (tokens == null) {
      throw Exception('No tokens found');
    }

    final url = Uri.parse('$serverAddr/$endpoint');
    final request = http.MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer ${tokens.accessToken}';

    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('files', file.path));
    }

    for (var item in data) {
      request.fields[item.key] = item.value;
    }

    return await request.send();
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

class MultipartFormData {
  final String key;
  final String value;

  MultipartFormData({required this.key, required this.value});
}
