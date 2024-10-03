import 'package:flutter/material.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/logger_service.dart';

class HistoryService extends ChangeNotifier {
  Future<List> fetchHistory() async {
    try {
      const url = "/api/v1/transactions/history";
      final request = DioRequest();
      final response = await request.get(url);

      return response.data["history"];
    } catch (e) {
      ConsoleLogger().log('Error fetching history: $e');
      rethrow;
    }
  }
}
