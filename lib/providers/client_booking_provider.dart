import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_request_model.dart';
import 'package:nearby_assist/models/post_review_model.dart';
import 'package:nearby_assist/models/service_review_model.dart';
import 'package:nearby_assist/services/client_booking_service.dart';

class ClientBookingProvider extends ChangeNotifier {
  List<BookingModel> _pending = [];
  List<BookingModel> _confirmed = [];
  List<BookingModel> _toRate = [];
  List<BookingModel> _history = [];

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
      _pending = response;
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchConfirmed() async {
    try {
      final response = await ClientBookingService().fetchAccepted();
      _confirmed = response;
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchToRate() async {
    try {
      final response = await ClientBookingService().fetchToReviewBookings();
      _toRate = response;
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> fetchHistory() async {
    try {
      final response = await ClientBookingService().fetchHistory();
      _history = response;
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
      _pending = [response, ..._pending];
      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> cancel(String id, String reason) async {
    try {
      await ClientBookingService().cancelBooking(id, reason);

      final index = _pending.indexWhere((request) => request.id == id);
      if (index == -1) return;

      final cancelledBooking = _pending[index].copyWith(
        status: BookingStatus.cancelled,
        updatedAt: DateTime.now(),
        cancelReason: reason,
      );

      _pending = List.of(_pending)..removeAt(index);
      _history = [cancelledBooking, ..._history];

      notifyListeners();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }

  Future<void> review(PostReviewModel review) async {
    try {
      await ClientBookingService().postReview(review);

      _toRate =
          _toRate.where((request) => request.id != review.bookingId).toList();
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

    final completedBooking = _confirmed[index].copyWith(
      status: BookingStatus.done,
      updatedAt: DateTime.now(),
    );

    _confirmed = List.of(_confirmed)..removeAt(index);
    _history = [completedBooking, ..._history];
    _toRate = [completedBooking, ..._toRate];

    notifyListeners();
  }

  void bookingConfirmed(
    String bookingId,
    String scheduleStart,
    String scheduleEnd,
  ) {
    final index = _pending.indexWhere((booking) => booking.id == bookingId);
    if (index == -1) return;

    final confirmedBooking = _pending[index].copyWith(
      status: BookingStatus.confirmed,
      updatedAt: DateTime.now(),
      scheduleStart: DateTime.parse(scheduleStart),
      scheduleEnd: DateTime.parse(scheduleEnd),
    );

    _pending = List.of(_pending)..removeAt(index);
    _confirmed = [confirmedBooking, ..._confirmed];

    notifyListeners();
  }

  void bookingRescheduled(
    String bookingId,
    String scheduleStart,
    String scheduleEnd,
  ) {
    final index = _confirmed.indexWhere((booking) => booking.id == bookingId);
    if (index == -1) return;

    _confirmed = _confirmed.map((booking) {
      if (booking.id == bookingId) {
        return booking.copyWith(
          scheduleStart: DateTime.parse(scheduleStart),
          scheduleEnd: DateTime.parse(scheduleEnd),
        );
      }
      return booking;
    }).toList();

    notifyListeners();
  }

  void bookingRejected(String bookingId, String reason) {
    final index = _pending.indexWhere((booking) => booking.id == bookingId);
    if (index == -1) return;

    final rejectedBooking = _pending[index].copyWith(
      status: BookingStatus.rejected,
      updatedAt: DateTime.now(),
      cancelReason: reason,
    );

    _pending = List.of(_pending)..removeAt(index);
    _history = [rejectedBooking, ..._history];

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
