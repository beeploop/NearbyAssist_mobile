import 'dart:convert';
import 'package:nearby_assist/services/request/request.dart';
import 'package:http/http.dart' as http;

class UnauthenticatedRequest<T extends Object> extends Request {
  @override
  Future<T> request(String endpoint, String method,
      {Map<String, dynamic>? body}) async {
    http.Response response = await makeRequest(endpoint, method, body: body);

    T data = jsonDecode(response.body);
    return data;
  }
}
