import 'package:flutter/material.dart';
import 'package:nearby_assist/services/logger_service.dart';

class ComplaintService extends ChangeNotifier {
  Future<List> fetchComplaints() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      throw Exception("Unimplemeted method");
    } catch (e) {
      ConsoleLogger().log('Error fetching complaints: $e');
      rethrow;
    }
  }
}
