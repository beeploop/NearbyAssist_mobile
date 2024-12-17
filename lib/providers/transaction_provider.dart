import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<BookingModel> _recents = [];
  List<BookingModel> _history = [];
  List<BookingModel> _ongoing = [];
  List<BookingModel> _myRequests = [];
  List<BookingModel> _clientRequest = [];

  List<BookingModel> get recents => _recents;
  List<BookingModel> get history => _history;
  List<BookingModel> get ongoing => _ongoing;
  List<BookingModel> get myRequests => _myRequests;
  List<BookingModel> get clientRequest => _clientRequest;

  Future<void> fetchRecent() async {
    try {
      final service = TransactionService();
      final response = await service.fetchRecent();

      _recents = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

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

  Future<void> createTransaction(BookingRequestModel booking) async {
    try {
      final service = TransactionService();
      await service.createTransaction(booking);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> cancelTransactionRequest(String id) async {
    try {
      await TransactionService().cancelTransaction(id);

      _myRequests.removeWhere((request) => request.id == id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getTransaction(String id) async {
    try {
      final service = TransactionService();
      await service.fetchTransaction(id);
    } catch (error) {
      rethrow;
    }
  }
}
