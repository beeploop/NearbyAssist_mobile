import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/request/dio_request.dart';

class HistoryService extends ChangeNotifier {
  Future<List> fetchHistory() async {
    try {
      final userId = getIt.get<AuthModel>().getUserId();

      final url = "/v1/history/$userId";
      final request = DioRequest();
      final response = await request.get(url);

      return response.data["history"];
    } catch (e) {
      debugPrint('Error fetching history: $e');
      return [];
    }
  }
}
