import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:http/http.dart' as http;

class TransactionService extends ChangeNotifier {
  Future<List<String>> fetchInProgressTransactions() async {
    final server = getIt.get<SettingsModel>().getServerAddr();
    final userId = getIt.get<AuthModel>().getUserId();

    if (userId == null) {
      return [];
    }

    try {
      final resp = await http.get(
        Uri.parse('$server/v1/transactions/progress/$userId'),
      );

      if (resp.statusCode != 200) {
        throw HttpException(
            'Server responded with status code: ${resp.statusCode}');
      }

      return ['hello', 'world'];
    } catch (e) {
      print('An error occurred: $e');
      return [];
    }
  }
}
