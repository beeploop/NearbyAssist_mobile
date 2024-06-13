import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/services/request/request.dart';

class AuthenticatedRequest<T extends Object> extends Request {
  String accessToken;
  int retryCount = 0;
  int maxRetries = 5;

  AuthenticatedRequest({required this.accessToken});

  @override
  Future<T> getRequest(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$serverAddr/$endpoint'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      T data = jsonDecode(response.body);

      return data;
    } catch (e) {
      debugPrint('endpoint responded with error: $e');
      rethrow;
    }
  }

  @override
  Future postRequest(String endpoint, body) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        return HttpException(response.body);
      }

      T data = jsonDecode(response.body);
      return data;
    } catch (e) {
      debugPrint('endpoint responded with error: $e');
      rethrow;
    }
  }

  void updateAccessToken() {
    final tokens = getIt.get<AuthModel>().getUserTokens();
    if (tokens == null) {
      debugPrint('cannot retrieve access token');
      return;
    }

    this.accessToken = tokens.accessToken;
  }
}
