import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/review_model.dart';
import 'package:nearby_assist/services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<BookingModel> _recents = [];
  List<BookingModel> _history = [];
  List<BookingModel> _accepted = [];
  List<BookingModel> _sentRequests = [];
  List<BookingModel> _receivedRequests = [];
  List<BookingModel> _toReviewTransactions = [];

  List<BookingModel> get recents => _recents;
  List<BookingModel> get history => _history;
  List<BookingModel> get accepted => _accepted;
  List<BookingModel> get sentRequests => _sentRequests;
  List<BookingModel> get receivedRequests => _receivedRequests;
  List<BookingModel> get toReviews => _toReviewTransactions;

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

  Future<void> fetchAccepted() async {
    try {
      final service = TransactionService();
      final response = await service.fetchAccepted();

      _accepted = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchSentRequests() async {
    try {
      final service = TransactionService();
      final response = await service.fetchSentRequests();

      _sentRequests = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchReceivedRequests() async {
    try {
      final service = TransactionService();
      final response = await service.fetchReceivedRequests();

      _receivedRequests = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchToReviewTransactions() async {
    try {
      final service = TransactionService();
      final response = await service.fetchToReviewTransactions();

      _toReviewTransactions = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void removeRequestFromAccepted(String transactionId) {
    _accepted.removeWhere((request) => request.id == transactionId);
    notifyListeners();
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

      _sentRequests.removeWhere((request) => request.id == id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> acceptTransactionRequest(String id) async {
    try {
      await TransactionService().acceptRequest(id);
      _receivedRequests.removeWhere((request) => request.id == id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> rejectTransactionRequest(String id) async {
    try {
      await TransactionService().rejectRequest(id);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> postReview(ReviewModel review) async {
    try {
      await TransactionService().postReview(review);

      _toReviewTransactions
          .removeWhere((request) => request.id == review.transactionId);
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
