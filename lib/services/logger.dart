import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

abstract class MyLogger {
  void logInfo(dynamic message);
  void logDebug(dynamic message);
  void logWarning(dynamic message);
  void logError(dynamic message);
}

class ConsoleLogger implements MyLogger {
  @override
  void logInfo(dynamic message) {
    if (kDebugMode) {
      print('---> LOG INFO: $message');
    }
  }

  @override
  void logDebug(message) {
    if (kDebugMode) {
      print('---> LOG DEBUG: $message');
    }
  }

  @override
  void logError(message) {
    if (kDebugMode) {
      print('---> LOG ERROR: $message');
    }
  }

  @override
  void logWarning(message) {
    if (kDebugMode) {
      print('---> LOG WARNING: $message');
    }
  }
}

class CustomLogger implements MyLogger {
  final logger = Logger();

  @override
  void logInfo(dynamic message) {
    logger.i(message);
  }

  @override
  void logDebug(message) {
    logger.d(message);
  }

  @override
  void logError(message) {
    logger.e(message);
  }

  @override
  void logWarning(message) {
    logger.w(message);
  }
}
