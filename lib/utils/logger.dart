import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warn, error }

class Log {
  static LogLevel minLevel = LogLevel.debug;

  static void _log(LogLevel level, String message,
      [Object? error, StackTrace? st]) {
    // In release, do nothing (prevent leaking logs)
    if (!kDebugMode) return;
    if (level.index < minLevel.index) return;

    final prefix = switch (level) {
      LogLevel.debug => '[DEBUG] ',
      LogLevel.info => '[INFO ] ',
      LogLevel.warn => '[WARN ] ',
      LogLevel.error => '[ERROR] ',
    };
    // ignore: avoid_print
    print(prefix + message);
    if (error != null) {
      // ignore: avoid_print
      print('  error: $error');
    }
    if (st != null) {
      // ignore: avoid_print
      print('  stack: $st');
    }
  }

  static void d(String message) => _log(LogLevel.debug, message);
  static void i(String message) => _log(LogLevel.info, message);
  static void w(String message) => _log(LogLevel.warn, message);
  static void e(String message, [Object? error, StackTrace? st]) =>
      _log(LogLevel.error, message, error, st);
}
