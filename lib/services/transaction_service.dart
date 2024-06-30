import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/transaction.dart';
import 'package:nearby_assist/request/dio_request.dart';

class TransactionService extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  Future<List<Transaction>> fetchInProgressTransactions() async {
    try {
      final userId = getIt.get<AuthModel>().getUserId();

      final url = "/backend/v1/transactions/ongoing/vendor/$userId";
      final request = DioRequest();
      final response = await request.get(url);

      _transactions.clear();

      List data = response.data["transactions"];

      final transactions = data.map((transaction) {
        return Transaction.fromJson(transaction);
      }).toList();

      _transactions.addAll([...transactions]);
      return _transactions;
    } catch (e) {
      debugPrint('An error occurred: $e');

      _transactions.clear();
      return _transactions;
    } finally {
      notifyListeners();
    }
  }
}
