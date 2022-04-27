library dio_logging_interceptor;

import 'dart:convert';

import 'package:dio/dio.dart';

/// Log Level
enum Level {
  /// No logs.
  none,

  /// Logs request and response lines.
  ///
  /// Example:
  ///  ```
  ///  --> POST /greeting
  ///
  ///  <-- 200 OK
  ///  ```
  basic,

  /// Logs request and response lines and their respective headers.
  ///
  ///  Example:
  /// ```
  /// --> POST /greeting
  /// Host: example.com
  /// Content-Type: plain/text
  /// Content-Length: 3
  /// --> END POST
  ///
  /// <-- 200 OK
  /// Content-Type: plain/text
  /// Content-Length: 6
  /// <-- END HTTP
  /// ```
  headers,

  /// Logs request and response lines and their respective headers and bodies (if present).
  ///
  /// Example:
  /// ```
  /// --> POST /greeting
  /// Host: example.com
  /// Content-Type: plain/text
  /// Content-Length: 3
  ///
  /// Hi?
  /// --> END POST
  ///
  /// <-- 200 OK
  /// Content-Type: plain/text
  /// Content-Length: 6
  ///
  /// Hello!
  /// <-- END HTTP
  /// ```
  body,
}

/// DioLoggingInterceptor
/// Simple logging interceptor for dio.
///
/// Inspired the okhttp-logging-interceptor and referred to pretty_dio_logger.
class LoggingInterceptor extends Interceptor {
  /// Log Level
  final Level level;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  void Function(Object object) logPrint;

  /// Print compact json response
  final bool compact;

  final JsonDecoder decoder = const JsonDecoder();
  final JsonEncoder encoder = const JsonEncoder.withIndent('  ');

  LoggingInterceptor({
    this.level = Level.body,
    this.compact = false,
    this.logPrint = print,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (level == Level.none) {
      return handler.next(options);
    }

    logPrint('--> ${options.method} ${options.uri}');

    if (level == Level.basic) {
      return handler.next(options);
    }

    logPrint('[DIO][HEADERS]');
    options.headers.forEach((key, value) {
      logPrint('$key:$value');
    });

    if (level == Level.headers) {
      logPrint('[DIO][HEADERS]--> END ${options.method}');
      return handler.next(options);
    }

    final data = options.data;
    if (data != null) {
      // logPrint('[DIO]dataType:${data.runtimeType}');
      if (data is Map) {
        if (compact) {
          logPrint('$data');
        } else {
          _prettyPrintJson(data);
        }
      } else if (data is FormData) {
        // NOT IMPLEMENT
      } else {
        logPrint(data.toString());
      }
    }

    logPrint('[DIO]--> END ${options.method}');

    return handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (level == Level.none) {
      return handler.next(response);
    }

    logPrint(
        '<-- ${response.statusCode} ${(response.statusMessage?.isNotEmpty ?? false) ? response.statusMessage : '' '${response.requestOptions.uri}'}');

    if (level == Level.basic) {
      return handler.next(response);
    }

    logPrint('[DIO][HEADER]');
    response.headers.forEach((key, value) {
      logPrint('$key:$value');
    });
    logPrint('[DIO][HEADERS]<-- END ${response.requestOptions.method}');
    if (level == Level.headers) {
      return handler.next(response);
    }
    final data = response.data;
    if (data != null) {
      // logPrint('[DIO]dataType:${data.runtimeType}');
      if (data is Map) {
        if (compact) {
          logPrint('$data');
        } else {
          _prettyPrintJson(data);
        }
      } else if (data is List) {
        // NOT IMPLEMENT
      } else {
        logPrint(data.toString());
      }
    }

    logPrint('[DIO]<-- END HTTP');
    return handler.next(response);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    if (level == Level.none) {
      return handler.next(err);
    }

    logPrint('[DIO]<-- HTTP FAILED: $err');

    return handler.next(err);
  }

  void _prettyPrintJson(Object input) {
    final prettyString = encoder.convert(input);
    logPrint('<-- Response payload');
    prettyString.split('\n').forEach((element) => logPrint(element));
  }
}
