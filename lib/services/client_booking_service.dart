import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_qr_code_data.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/post_review_model.dart';
import 'package:nearby_assist/models/service_review_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class ClientBookingService {
  Future<void> fetchBooking(String id) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.get('${endpoint.getBooking}/$id');
    } catch (error) {
      logger.logError('Error fetching booking: ${error.toString()}');
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchSentRequests() async {
    logger.logDebug('called fetchSentRequests');

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

  Future<List<BookingModel>> fetchAccepted() async {
    logger.logDebug('called fetchAccepted');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.confirmed,
        queryParameters: {'filter': 'client'},
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
    logger.logDebug('called fetchToReviewBookings');

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

  Future<List<BookingModel>> fetchHistory() async {
    logger.logDebug('called fetchHistory');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.history,
        queryParameters: {'filter': 'client'},
      );

      return (response.data['history'] as List)
          .map((booking) => BookingModel.fromJson(booking))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<String> getBookingSignature(BookingModel booking) async {
    if (booking.status != BookingStatus.confirmed) {
      return '';
    }

    try {
      final data = BookingQrCodeData(
        clientId: booking.client.id,
        vendorId: booking.vendor.id,
        bookingId: booking.id,
        signature: '',
      );

      final api = ApiService.authenticated();
      final response = await api.dio.post(
        endpoint.qrSignature,
        data: data.toJsonNoSignature(),
      );

      return response.data['signature'];
    } catch (error) {
      rethrow;
    }
  }

  Future<BookingModel> createBooking(BookingRequestModel booking) async {
    logger.logDebug('called createBooking');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.post(
        endpoint.createBooking,
        data: booking.toJson(),
      );

      return BookingModel.fromJson(response.data['booking']);
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> cancelBooking(String id, String reason) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.put(
        endpoint.cancelBooking,
        data: {'bookingId': id, 'reason': reason},
        queryParameters: {'actor': 'client'},
      );
    } catch (error) {
      logger.logError('Error cancelling booking request: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> postReview(PostReviewModel review) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.post(endpoint.postReview, data: review.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<ServiceReviewModel> getReviewOnBooking(String bookingId) async {
    try {
      final user = await SecureStorage().getUser();

      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.reviewOnBooking,
        queryParameters: {'userId': user.id, 'bookingId': bookingId},
      );

      return ServiceReviewModel.fromJson(response.data['review']);
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
