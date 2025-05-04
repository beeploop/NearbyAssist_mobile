import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/post_review_model.dart';
import 'package:nearby_assist/models/service_review_model.dart';
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

  void clear() {
    _pending.clear();
    _confirmed.clear();
    _toRate.clear();
    _history.clear();
    notifyListeners();
  }

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
      final booking = _pending.removeAt(targetIdx);

      final cancelledBooking = booking.copyWith(
        status: BookingStatus.cancelled,
        updatedAt: DateTime.now(),
        cancelReason: reason,
      );
      _history.insert(0, cancelledBooking);

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

  // handle websocket event for completing booking in client side, only call this in websocket event process
  void bookingCompleted(String bookingId) {
    final index = _confirmed.indexWhere((booking) => booking.id == bookingId);
    if (index == -1) return;

    final booking = _confirmed.removeAt(index);
    final completedBooking = booking.copyWith(
      status: BookingStatus.done,
      updatedAt: DateTime.now(),
    );

    _history.insert(0, completedBooking);
    _toRate.insert(0, completedBooking);

    notifyListeners();
  }

  void bookingConfirmed(String bookingId, String schedule) {
    final index = _pending.indexWhere((booking) => booking.id == bookingId);
    if (index == -1) return;

    final booking = _pending.removeAt(index);
    final confirmedBooking = booking.copyWith(
      status: BookingStatus.confirmed,
      updatedAt: DateTime.now(),
      scheduledAt: DateTime.parse(schedule),
    );

    _confirmed.insert(0, confirmedBooking);

    notifyListeners();
  }

  void bookingRejected(String bookingId, String reason) {
    final index = _pending.indexWhere((booking) => booking.id == bookingId);
    if (index == -1) return;

    final booking = _pending.removeAt(index);
    final rejectedBooking = booking.copyWith(
      status: BookingStatus.rejected,
      updatedAt: DateTime.now(),
      cancelReason: reason,
    );

    _history.insert(0, rejectedBooking);

    notifyListeners();
  }

  Future<ServiceReviewModel> getReviewOnBooking(String bookingId) async {
    try {
      return await ClientBookingService().getReviewOnBooking(bookingId);
    } catch (error) {
      rethrow;
    }
  }
}
