import 'package:flutter/material.dart';

class DatePickerController extends ChangeNotifier {
  DateTimeRange _selectedRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  final TextEditingController _controller = TextEditingController();

  DatePickerController() {
    _controller.text = dateRange;
  }

  TextEditingController get controller => _controller;

  String get dateRange => '$formattedStart - $formattedEnd';

  int get days {
    final days = _selectedRange.duration.inDays;
    if (days <= 0) {
      return 1;
    }
    return days;
  }

  DateTime get start => _selectedRange.start;
  DateTime get end => _selectedRange.end;

  String get formattedStart {
    final year = _selectedRange.start.year.toString();
    final month = _selectedRange.start.month.toString();
    final day = _selectedRange.start.day.toString();

    return '$month/$day/$year';
  }

  String get formattedEnd {
    final year = _selectedRange.end.year.toString();
    final month = _selectedRange.end.month.toString();
    final day = _selectedRange.end.day.toString();

    return '$month/$day/$year';
  }

  void setRange(DateTimeRange range) {
    _selectedRange = range;
    _controller.text = dateRange;
    notifyListeners();
  }
}
