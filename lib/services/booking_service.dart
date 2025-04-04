import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/review_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class BookingService {
  Future<List<BookingModel>> fetchRecent() async {
    logger.logDebug('called fetchRecent in booking_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.recent);

      return (response.data['bookings'] as List)
          .map((booking) => BookingModel.fromJson(booking))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchHistory() async {
    logger.logDebug('called fetchHistory in booking_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.history);

      return (response.data['history'] as List)
          .map((booking) => BookingModel.fromJson(booking))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchAccepted() async {
    logger.logDebug('called fetchAccepted in booking_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.confirmed);

      return (response.data['bookings'] as List)
          .map((booking) => BookingModel.fromJson(booking))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchReceivedRequests() async {
    logger.logDebug('called fetchReceivedRequests in booking_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.clientRequests,
        queryParameters: {'filter': 'received'},
      );

      return (response.data['bookings'] as List)
          .map((booking) => BookingModel.fromJson(booking))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchSentRequests() async {
    logger.logDebug('called fetchSentRequests in booking_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.myRequests,
        queryParameters: {'filter': 'sent'},
      );

      return (response.data['bookings'] as List)
          .map((booking) => BookingModel.fromJson(booking))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchToReviewBookings() async {
    logger.logDebug('called tchToReviewBookings in booking_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.toReviews);

      return (response.data['reviewables'] as List)
          .map((booking) => BookingModel.fromJson(booking))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> createBooking(BookingRequestModel booking) async {
    logger.logDebug('called createBooking in booking_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.post(
        endpoint.createBooking,
        data: booking.toJson(),
      );

      final bookingId = response.data['booking'] as String;
      logger.logInfo('Booking ID: $bookingId');
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

  Future<void> fetchBooking(String id) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.get('${endpoint.getBooking}/$id');
    } catch (error) {
      logger.logError('Error fetching booking: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> cancelBooking(String id, String reason) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.cancelBooking,
        data: {'bookingId': id, 'reason': reason},
      );
    } catch (error) {
      logger.logError('Error cancelling booking request: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> acceptRequest(String id, String schedule) async {
    logger.logDebug('called acceptRequest in booking_service.dart');
    logger.logDebug('parameters: {id: $id, schedule: $schedule}');

    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.acceptRequest,
        data: {'bookingId': id, 'schedule': schedule},
      );
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> rejectRequest(String id, String reason) async {
    logger.logDebug('called rejectRequest in booking_service.dart');

    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.rejectRequest,
        data: {'bookingId': id, 'reason': reason},
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
