import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/review_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class TransactionService {
  Future<List<BookingModel>> fetchRecent() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.recent);

      return (response.data['transactions'] as List)
          .map((transaction) => BookingModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.log('Error fetching recent transaction: ${error.toString()}');
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchHistory() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.history);

      return (response.data['history'] as List)
          .map((transaction) => BookingModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.log('Error fetching transaction history: ${error.toString()}');
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchAccepted() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.confirmed);

      return (response.data['transactions'] as List)
          .map((transaction) => BookingModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.log('Error fetching confirmed transactions: ${error.toString()}');
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchReceivedRequests() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.clientRequests,
        queryParameters: {'filter': 'received'},
      );

      return (response.data['transactions'] as List)
          .map((transaction) => BookingModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.log('Error fetching client transactions: ${error.toString()}');
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchSentRequests() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.myRequests,
        queryParameters: {'filter': 'sent'},
      );

      return (response.data['transactions'] as List)
          .map((transaction) => BookingModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.log('Error fetching my request transactions: ${error.toString()}');
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchToReviewTransactions() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.toReviews);

      return (response.data['reviewables'] as List)
          .map((transaction) => BookingModel.fromJson(transaction))
          .toList();
    } catch (error) {
      logger.log('Error fetching reviewable transactions: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> createTransaction(BookingRequestModel booking) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.post(
        endpoint.createBooking,
        data: booking.toJson(),
      );

      final transactionId = response.data['transaction'] as String;
      logger.log('Transaction ID: $transactionId');
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw error.response?.data['message'];
      }

      rethrow;
    } catch (error) {
      logger.log('Error booking service: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> fetchTransaction(String id) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.get('${endpoint.getTransaction}/$id');
    } catch (error) {
      logger.log('Error fetching transaction: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> cancelTransaction(String id) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put('${endpoint.cancelBooking}/$id');
    } catch (error) {
      logger.log('Error cancelling transaction request: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> acceptRequest(String id) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put('${endpoint.acceptRequest}/$id');
    } catch (error) {
      logger.log('Error accepting client request: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> rejectRequest(String id) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put('${endpoint.rejectRequest}/$id');
    } catch (error) {
      logger.log('Error reject client request: ${error.toString()}');
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
