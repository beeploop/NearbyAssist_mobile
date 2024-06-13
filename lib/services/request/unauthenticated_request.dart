import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearby_assist/services/request/request.dart';
import 'package:http/http.dart' as http;

class UnauthenticatedRequest<T extends Object> extends Request {
  @override
  Future<dynamic> getRequest(String endpoint) async {
    try {
      final response = await http.post(Uri.parse('$serverAddr/$endpoint'));

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

  @override
  Future<dynamic> postRequest(String endpoint, body) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
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
}
