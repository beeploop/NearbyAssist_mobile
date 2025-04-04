import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/review_model.dart';
import 'package:nearby_assist/services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  List<BookingModel> _recents = [];
  List<BookingModel> _history = [];
  List<BookingModel> _accepted = [];
  List<BookingModel> _sentRequests = [];
  List<BookingModel> _receivedRequests = [];
  List<BookingModel> _toReviewBookings = [];

  List<BookingModel> get recents => _recents;
  List<BookingModel> get history => _history;
  List<BookingModel> get accepted => _accepted;
  List<BookingModel> get sentRequests => _sentRequests;
  List<BookingModel> get receivedRequests => _receivedRequests;
  List<BookingModel> get toReviews => _toReviewBookings;

  Future<void> fetchRecent() async {
    logger.logDebug('called fetchRecent in booking_provider.dart');

    try {
      final service = BookingService();
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
      final service = BookingService();
      final response = await service.fetchHistory();

      _history = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAccepted() async {
    try {
      final service = BookingService();
      final response = await service.fetchAccepted();

      _accepted = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchSentRequests() async {
    try {
      final service = BookingService();
      final response = await service.fetchSentRequests();

      _sentRequests = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchReceivedRequests() async {
    try {
      final service = BookingService();
      final response = await service.fetchReceivedRequests();

      _receivedRequests = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchToReviewBookings() async {
    try {
      final service = BookingService();
      final response = await service.fetchToReviewBookings();

      _toReviewBookings = response;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void removeRequestFromAccepted(String bookingId) {
    _accepted.removeWhere((request) => request.id == bookingId);
    notifyListeners();
  }

  Future<void> createBooking(BookingRequestModel booking) async {
    try {
      final service = BookingService();
      await service.createBooking(booking);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> cancelBookingRequest(String id, String reason) async {
    try {
      await BookingService().cancelBooking(id, reason);

      _sentRequests.removeWhere((request) => request.id == id);

      final updated = _recents
          .map((booking) => booking.id == id
              ? booking.copyWithNewStatus(BookingStatus.cancelled)
              : booking)
          .toList();
      _recents = updated;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> acceptBookingRequest(String id, String schedule) async {
    try {
      await BookingService().acceptRequest(id, schedule);
      _receivedRequests.removeWhere((request) => request.id == id);

      final updated = _recents
          .map((booking) => booking.id == id
              ? booking.copyWithNewStatus(BookingStatus.confirmed)
              : booking)
          .toList();
      _recents = updated;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> rejectBookingRequest(String id, String reason) async {
    try {
      await BookingService().rejectRequest(id, reason);
      _receivedRequests.removeWhere((request) => request.id == id);

      final updated = _recents
          .map((booking) => booking.id == id
              ? booking.copyWithNewStatus(BookingStatus.rejected)
              : booking)
          .toList();
      _recents = updated;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> postReview(ReviewModel review) async {
    try {
      await BookingService().postReview(review);

      _toReviewBookings
          .removeWhere((request) => request.id == review.bookingId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getBooking(String id) async {
    try {
      final service = BookingService();
      await service.fetchBooking(id);
    } catch (error) {
      rethrow;
    }
  }
}
