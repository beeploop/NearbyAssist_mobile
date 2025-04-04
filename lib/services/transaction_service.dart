import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/transaction_model.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/review_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class TransactionService {
  Future<List<TransactionModel>> fetchRecent() async {
    logger.logDebug('called fetchRecent in transaction_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.recent);

      return (response.data['transactions'] as List)
          .map((transaction) => TransactionModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<TransactionModel>> fetchHistory() async {
    logger.logDebug('called fetchHistory in transaction_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.history);

      return (response.data['history'] as List)
          .map((transaction) => TransactionModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<TransactionModel>> fetchAccepted() async {
    logger.logDebug('called fetchAccepted in transaction_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.confirmed);

      return (response.data['transactions'] as List)
          .map((transaction) => TransactionModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<TransactionModel>> fetchReceivedRequests() async {
    logger.logDebug('called fetchReceivedRequests in transaction_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.clientRequests,
        queryParameters: {'filter': 'received'},
      );

      return (response.data['transactions'] as List)
          .map((transaction) => TransactionModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<TransactionModel>> fetchSentRequests() async {
    logger.logDebug('called fetchSentRequests in transaction_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.myRequests,
        queryParameters: {'filter': 'sent'},
      );

      return (response.data['transactions'] as List)
          .map((transaction) => TransactionModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<TransactionModel>> fetchToReviewTransactions() async {
    logger
        .logDebug('called tchToReviewTransactions in transaction_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.toReviews);

      return (response.data['reviewables'] as List)
          .map((transaction) => TransactionModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> createTransaction(BookingRequestModel booking) async {
    logger.logDebug('called createTransaction in transaction_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.post(
        endpoint.createBooking,
        data: booking.toJson(),
      );

      final transactionId = response.data['transaction'] as String;
      logger.logInfo('Transaction ID: $transactionId');
    } on DioException catch (error) {
      logger.logError(error.toString());
      if (error.response?.statusCode == 400) {
        throw error.response?.data['message'];
      }

      rethrow;
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchTransaction(String id) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.get('${endpoint.getTransaction}/$id');
    } catch (error) {
      logger.logError('Error fetching transaction: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> cancelTransaction(String id, String reason) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.cancelBooking,
        data: {'transactionId': id, 'reason': reason},
      );
    } catch (error) {
      logger.logError(
          'Error cancelling transaction request: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> acceptRequest(String id, String schedule) async {
    logger.logDebug('called acceptRequest in transaction_service.dart');
    logger.logDebug('parameters: {id: $id, schedule: $schedule}');

    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.acceptRequest,
        data: {'transactionId': id, 'schedule': schedule},
      );
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> rejectRequest(String id, String reason) async {
    logger.logDebug('called rejectRequest in transaction_service.dart');

    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.rejectRequest,
        data: {'transactionId': id, 'reason': reason},
      );
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> postReview(ReviewModel review) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.post(endpoint.postReview, data: review.toJson());
    } catch (error) {
      rethrow;
    }
  }
}
