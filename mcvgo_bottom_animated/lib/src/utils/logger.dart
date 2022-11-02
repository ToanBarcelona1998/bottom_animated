import 'dart:developer' as dev;

class Logger {
  static void errorLog(String message, [StackTrace? stackTrace]) {
    dev.log(
      'error message $message',
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
  }

  static void logMessage(String message) {
    dev.log(
      'message $message',
      time: DateTime.now(),
    );
  }
}
