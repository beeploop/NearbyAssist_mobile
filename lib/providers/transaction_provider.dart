import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  List _history = [];
  List _ongoing = [];
  List _myRequests = [];
  List _clientRequest = [];

  List get history => _history;
  List get ongoing => _ongoing;
  List get myRequests => _myRequests;
  List get clientRequest => _clientRequest;

  Future<void> fetchHistory() async {
    try {
      final service = TransactionService();
      final response = await service.fetchHistory();

      _history = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchOngoing() async {
    try {
      final service = TransactionService();
      final response = await service.fetchOngoing();

      _ongoing = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchMyRequests() async {
    try {
      final service = TransactionService();
      final response = await service.fetchMyRequests();

      _myRequests = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchClientRequests() async {
    try {
      final service = TransactionService();
      final response = await service.fetchClientRequests();

      _clientRequest = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createTransaction(BookingModel booking) async {
    try {
      final service = TransactionService();
      await service.createTransaction(booking);
    } catch (error) {
      rethrow;
    }
  }
}
