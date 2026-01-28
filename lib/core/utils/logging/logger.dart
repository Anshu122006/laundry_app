import 'package:flutter/material.dart';

class AppLogger {
  static void logInfo(String message) {
    debugPrint('\x1B[38;5;208m[INFO] $message\x1B[0m');
  }
}
