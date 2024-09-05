import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/model/transaction.dart';
import 'package:nearby_assist/request/dio_request.dart';

class TransactionService extends ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> getTransactions() => _transactions.reversed.toList();

  Future<void> fetchTransactions() async {
    try {
      const url = "/v1/public/transactions";
      final request = DioRequest();
      final response = await request.get(url);

      List data = response.data["transactions"];

      _transactions.clear();

      _transactions.addAll(data.map((transaction) {
        return Transaction.fromJson(transaction);
      }).toList());
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future fetchTransactionDetail(int id) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      throw Exception('Unimplemented method');
    } catch (e) {
      rethrow;
    }
  }
}
