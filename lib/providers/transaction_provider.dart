import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/transaction_model.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/review_model.dart';
import 'package:nearby_assist/services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _recents = [];
  List<TransactionModel> _history = [];
  List<TransactionModel> _accepted = [];
  List<TransactionModel> _sentRequests = [];
  List<TransactionModel> _receivedRequests = [];
  List<TransactionModel> _toReviewTransactions = [];

  List<TransactionModel> get recents => _recents;
  List<TransactionModel> get history => _history;
  List<TransactionModel> get accepted => _accepted;
  List<TransactionModel> get sentRequests => _sentRequests;
  List<TransactionModel> get receivedRequests => _receivedRequests;
  List<TransactionModel> get toReviews => _toReviewTransactions;

  Future<void> fetchRecent() async {
    logger.logDebug('called fetchRecent in transaction_provider.dart');

    try {
      final service = TransactionService();
      final response = await service.fetchRecent();

      _recents = response;
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
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

  Future<void> cancelTransactionRequest(String id, String reason) async {
    try {
      await TransactionService().cancelTransaction(id, reason);

      _sentRequests.removeWhere((request) => request.id == id);

      final updated = _recents
          .map((transaction) => transaction.id == id
              ? transaction.copyWithNewStatus(TransactionStatus.cancelled)
              : transaction)
          .toList();
      _recents = updated;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> acceptTransactionRequest(String id, String schedule) async {
    try {
      await TransactionService().acceptRequest(id, schedule);
      _receivedRequests.removeWhere((request) => request.id == id);

      final updated = _recents
          .map((transaction) => transaction.id == id
              ? transaction.copyWithNewStatus(TransactionStatus.confirmed)
              : transaction)
          .toList();
      _recents = updated;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> rejectTransactionRequest(String id) async {
    try {
      await TransactionService().rejectRequest(id);
      _receivedRequests.removeWhere((request) => request.id == id);

      final updated = _recents
          .map((transaction) => transaction.id == id
              ? transaction.copyWithNewStatus(TransactionStatus.rejected)
              : transaction)
          .toList();
      _recents = updated;

      notifyListeners();
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
