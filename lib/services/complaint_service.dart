import 'package:flutter/material.dart';
import 'package:nearby_assist/request/dio_request.dart';

class ComplaintService extends ChangeNotifier {
  Future<List> fetchComplaints() async {
    try {
      const url = "/api/v1/complaints";
      final request = DioRequest();
      final response = await request.get(url);

      return response.data["complaints"];
    } catch (e) {
      debugPrint('Error fetching complaints: $e');
      return [];
    }
  }
}
