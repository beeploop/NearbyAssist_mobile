import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/request/dio_request.dart';

class ComplaintService extends ChangeNotifier {
  Future<List> fetchComplaints() async {
    try {
      final userId = getIt.get<AuthModel>().getUserId();

      final url = "/backend/v1/complaints/$userId";
      final request = DioRequest();
      final response = await request.get(url);

      return response.data["complaints"];
    } catch (e) {
      debugPrint('Error fetching complaints: $e');
      return [];
    }
  }
}
