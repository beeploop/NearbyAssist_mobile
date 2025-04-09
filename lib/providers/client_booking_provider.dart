import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/post_review_model.dart';
import 'package:nearby_assist/services/client_booking_service.dart';

class ClientBookingProvider extends ChangeNotifier {
  final List<BookingModel> _pending = [];
  final List<BookingModel> _confirmed = [];
  final List<BookingModel> _toRate = [];
  final List<BookingModel> _history = [];

  List<BookingModel> get pending => _pending;
  List<BookingModel> get confirmed => _confirmed;
  List<BookingModel> get toRate => _toRate;
  List<BookingModel> get history => _history;

  Future<void> fetchPending() async {
    try {
      final response = await ClientBookingService().fetchSentRequests();

      _pending.clear();
      _pending.addAll(
        response.where((booking) => booking.status == BookingStatus.pending),
      );
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchConfirmed() async {
    try {
      final response = await ClientBookingService().fetchAccepted();
      _confirmed.clear();
      _confirmed.addAll(response);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchToRate() async {
    try {
      final response = await ClientBookingService().fetchToReviewBookings();
      _toRate.clear();
      _toRate.addAll(response);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchHistory() async {
    try {
      final response = await ClientBookingService().fetchHistory();
      _history.clear();
      _history.addAll(response);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchAll() async {
    try {
      await Future.wait([
        fetchPending(),
        fetchConfirmed(),
        fetchHistory(),
        fetchToRate(),
      ]);
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> book(BookingRequestModel booking) async {
    try {
      final response = await ClientBookingService().createBooking(booking);
      _pending.add(response);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> cancel(String id, String reason) async {
    try {
      await ClientBookingService().cancelBooking(id, reason);

      final targetIdx = _pending.indexWhere((request) => request.id == id);
      final cancelledBooking = _pending.removeAt(targetIdx);
      _history.add(cancelledBooking.copyWith(
        status: BookingStatus.cancelled,
        updatedAt: DateTime.now().toString(),
        cancelReason: reason,
      ));
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> review(PostReviewModel review) async {
    try {
      await ClientBookingService().postReview(review);

      _toRate.removeWhere((request) => request.id == review.bookingId);
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
