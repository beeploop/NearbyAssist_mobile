import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class BookingService {
  Future<void> book(BookingModel booking) async {
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
