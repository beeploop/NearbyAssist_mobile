import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:http/http.dart' as http;
import 'package:nearby_assist/model/transaction.dart';

class TransactionService extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  Future<List<Transaction>> fetchInProgressTransactions() async {
    final serverAddr = getIt.get<SettingsModel>().getServerAddr();
    final userId = getIt.get<AuthModel>().getUserId();

    if (userId == null) {
      return _transactions;
    }

    try {
      final resp = await http.get(
        Uri.parse('$serverAddr/backend/v1/transactions/ongoing/vendor/$userId'),
      );

      if (resp.statusCode != 200) {
        throw HttpException(
            'Server responded with status code: ${resp.statusCode}');
      }

      List json = jsonDecode(resp.body);
      _transactions.clear();
      for (var something in json) {
        final transaction = Transaction.fromJson(something);
        _transactions.add(transaction);
      }
    } catch (e) {
      print('An error occurred: $e');

      _transactions.clear();
    }

    notifyListeners();
    return _transactions;
  }
}
