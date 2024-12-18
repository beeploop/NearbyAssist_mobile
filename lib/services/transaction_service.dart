import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/utils/pretty_json.dart';

class TransactionService {
  Future<List> fetchHistory() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.history);

      logger.log(prettyJSON(response.data));

      return response.data['history'] as List;
    } catch (error) {
      logger.log('Error fetching transaction history: ${error.toString()}');
      rethrow;
    }
  }

  Future<List> fetchOngoing() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.ongoing);

      logger.log(prettyJSON(response.data));

      return response.data['transactions'] as List;
    } catch (error) {
      logger.log('Error fetching ongoing transactions: ${error.toString()}');
      rethrow;
    }
  }

  Future<List> fetchClientRequests() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.clientRequests,
        queryParameters: {'filter': 'received'},
      );

      logger.log(prettyJSON(response.data));

      return response.data['transactions'] as List;
    } catch (error) {
      logger.log('Error fetching ongoing transactions: ${error.toString()}');
      rethrow;
    }
  }

  Future<List> fetchMyRequests() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.myRequests,
        queryParameters: {'filter': 'sent'},
      );

      logger.log(prettyJSON(response.data));

      return response.data['transactions'] as List;
    } catch (error) {
      logger.log('Error fetching ongoing transactions: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> createTransaction(BookingModel booking) async {
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
}
