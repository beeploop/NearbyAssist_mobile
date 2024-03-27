import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:http/http.dart' as http;

class ComplaintService extends ChangeNotifier {
  Future<List> fetchComplaints() async {
    final server = getIt.get<SettingsModel>().getServerAddr();
    final userId = getIt.get<AuthModel>().getUserId();

    if (userId == null) {
      return [];
    }

    try {
      final resp = await http.get(Uri.parse('$server/v1/complaints/$userId'));

      if (resp.statusCode != 200) {
        throw HttpException(
            'Server responded with status code: ${resp.statusCode}');
      }

      return [];
    } catch (e) {
      print('Error fetching complaints: $e');
      return [];
    }
  }
}
