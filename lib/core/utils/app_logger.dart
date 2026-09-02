import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static const String _defaultTag = "APP";

  static void info(String message, {String tag = _defaultTag}) {
    if (kDebugMode) {
      debugPrint("[$tag] $message");
    }
  }

  static void success(String message, {String tag = _defaultTag}) {
    if (kDebugMode) {
      debugPrint("[$tag] ✅ $message");
    }
  }

  static void warning(String message, {String tag = _defaultTag}) {
    if (kDebugMode) {
      debugPrint("[$tag] ⚠️ $message");
    }
  }

  static void error(
    String message, {
    String tag = _defaultTag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      debugPrint("[$tag] ❌ $message");

      if (error != null) {
        debugPrint("[$tag] Error: $error");
      }

      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }
}
// import 'package:flutter/foundation.dart';

// class ApiLogger {
//   static const String tag = "[API]";

//   static void request({
//     required String method,
//     required Uri url,
//     Map<String, dynamic>? headers,
//     dynamic body,
//   }) {
//     debugPrint("$tag ┌────────────────────────────────────────────");

//     debugPrint("$tag │ REQUEST: $method $url");

//     if (headers != null) {
//       debugPrint("$tag │ Headers: $headers");
//     }

//     if (body != null) {
//       debugPrint("$tag │ Body: $body");
//     }

//     debugPrint("$tag └────────────────────────────────────────────");
//   }

//   static void response({
//     required int? statusCode,
//     required Uri url,
//     dynamic data,
//   }) {
//     debugPrint("$tag ┌────────────────────────────────────────────");

//     debugPrint("$tag │ RESPONSE: $statusCode $url");

//     debugPrint("$tag │ Data: $data");

//     debugPrint("$tag └────────────────────────────────────────────");
//   }

//   static void error({
//     required Uri url,
//     required dynamic error,
//     int? statusCode,
//     dynamic data,
//   }) {
//     debugPrint("$tag ┌────────────────────────────────────────────");

//     debugPrint("$tag │ ERROR: $url");

//     debugPrint("$tag │ Status: $statusCode");

//     debugPrint("$tag │ Error: $error");

//     if (data != null) {
//       debugPrint("$tag │ Data: $data");
//     }

//     debugPrint("$tag └────────────────────────────────────────────");
//   }
// }
