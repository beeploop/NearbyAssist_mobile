import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_assist/utils/date_formatter.dart';

void main() {
  test('get month name and date from date string', () {
    final tests = List<Map<String, String>>.from([
      {
        "input": "2025-04-08",
        "expected": "April 8",
      },
      {
        "input": "2025-01-02",
        "expected": "January 2",
      },
      {
        "input": "",
        "expected": "invalid date",
      },
    ]);

    for (var test in tests) {
      final res = DateFormatter.monthAndDate(test["input"]!);
      expect(res, test["expected"]!);
    }
  });

  test('get month name, date, hour, and minutes from date string', () {
    final tests = List<Map<String, String>>.from([
      {
        "input": "2025-04-07 22:12:16",
        "expected": "April 7 10:12 PM",
      },
      {
        "input": "2025-04-07 01:05:02",
        "expected": "April 7 1:05 AM",
      },
    ]);

    for (var test in tests) {
      final res = DateFormatter.monthDateHourMinutes(test['input']!);
      expect(res, test['expected']!);
    }
  });
}
