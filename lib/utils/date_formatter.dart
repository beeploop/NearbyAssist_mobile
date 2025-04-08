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
}
