import 'package:flutter/foundation.dart';

abstract class Logger {
  void log(dynamic message);
}

class ConsoleLogger implements Logger {
  @override
  void log(dynamic message) {
    if (kDebugMode) {
      print(message);
    }
  }
}
