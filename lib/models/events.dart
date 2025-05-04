import 'dart:convert';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/utils/pretty_json.dart';

enum Event {
  pong,
  message,
  notification,
  sync,
  bookingComplete,
  bookingConfirmed,
  bookingRejected,
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
      logger.logDebug(prettyJSON(decoded));

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
