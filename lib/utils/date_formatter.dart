import 'package:intl/intl.dart';

final class DateFormatter {
  static String monthAndDate(String date) {
    try {
      final dt = DateTime.parse(date);
      return DateFormat.MMMMd().format(dt);
    } on FormatException catch (_) {
      return "invalid date";
    }
  }

  static String monthAndDateFromDT(DateTime timestamp) {
    return DateFormat.MMMMd().format(timestamp);
  }

  static String monthDateHourMinutes(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      final monthDate = DateFormat.MMMMd().format(dt);
      final hourMinutes = DateFormat.jm().format(dt);

      return '$monthDate ${hourMinutes.replaceAll('\u202F', ' ')}';
    } on FormatException catch (_) {
      return "invalid date";
    }
  }

  static String monthDateHourMinutesFromDT(DateTime timestamp) {
    try {
      final monthDate = DateFormat.MMMMd().format(timestamp);
      final hourMinutes = DateFormat.jm().format(timestamp);

      return '$monthDate ${hourMinutes.replaceAll('\u202F', ' ')}';
    } on FormatException catch (_) {
      return "invalid date";
    }
  }

  static String monthDateRangeDT(DateTime start, DateTime end) {
    try {
      final s = DateFormat.MMMMd().format(start);
      final e = DateFormat.MMMMd().format(end);

      return '$s - $e';
    } catch (error) {
      return "invalid date range";
    }
  }
}
