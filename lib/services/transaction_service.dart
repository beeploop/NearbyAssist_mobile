import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/model/transaction.dart';
import 'package:nearby_assist/request/dio_request.dart';

class TransactionService extends ChangeNotifier {
  final List<Transaction> _transactionsCache = [];

  Future<List<Transaction>> getTransactions({bool forceRefresh = false}) async {
    try {
      if (forceRefresh) {
        _transactionsCache.clear();
        final transactions = await _fetchTransactions();
        _transactionsCache.addAll(transactions);
        return transactions;
      }

      return _transactionsCache;
    } catch (err) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<List<Transaction>> _fetchTransactions() async {
    try {
      const url = "/api/v1/transactions/mine";
      final request = DioRequest();
      final response = await request.get(url);

      final transactions = response.data["transactions"];
      if (transactions == null) {
        throw Exception("Transactions is null");
      }

      final transactionList = transactions as List;
      return transactionList.map((transaction) {
        return Transaction.fromJson(transaction);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction> fetchTransactionDetail(int id) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      throw Exception('Unimplemented method');
    } catch (e) {
      rethrow;
    }
  }
}
