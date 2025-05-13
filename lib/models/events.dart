import 'dart:convert';

enum Event {
  pong,
  message,
  notification,
  sync,
  bookingComplete,
  bookingConfirmed,
  bookingRescheduled,
  bookingRejected,
  vendorCancelledBooking,
  clientCancelledBooking,
  receivedBooking,
  unknown,
}

class EventResult {
  Event event;
  dynamic data;

  EventResult({required this.event, required this.data});
}

class EventHandler {
  EventResult process(dynamic event) {
    try {
      final decoded = jsonDecode(event);

      final evt = Event.values.firstWhere(
        (e) => e.name == decoded['type'],
        orElse: () => Event.unknown,
      );

      return EventResult(event: evt, data: decoded);
    } catch (error) {
      rethrow;
    }
  }
}
