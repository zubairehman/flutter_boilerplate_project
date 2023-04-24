import 'dart:async';

import 'package:dio/dio.dart';

/// An interceptor that will try to send failed request again
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final RetryOptions options;
  final bool shouldLog;

  RetryInterceptor(
      {required this.dio, RetryOptions? options, this.shouldLog = true})
      : this.options = options ?? const RetryOptions();

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    var extra = RetryOptions.fromExtra(err.requestOptions, options);

    var shouldRetry = extra.retries > 0 && await options.retryEvaluator(err);
    if (!shouldRetry) {
      return super.onError(err, handler);
    }

    if (extra.retryInterval.inMilliseconds > 0) {
      await Future.delayed(extra.retryInterval);
    }

    // Update options to decrease retry count before new try
    extra = extra.copyWith(retries: extra.retries - 1);
    err.requestOptions.extra = err.requestOptions.extra
      ..addAll(extra.toExtra());

    if (shouldLog)
      print(
          '[${err.requestOptions.uri}] An error occurred during request, trying a again (remaining tries: ${extra.retries}, error: ${err.error})');
    // We retry with the updated options
    await dio
        .request(
      err.requestOptions.path,
      cancelToken: err.requestOptions.cancelToken,
      data: err.requestOptions.data,
      onReceiveProgress: err.requestOptions.onReceiveProgress,
      onSendProgress: err.requestOptions.onSendProgress,
      queryParameters: err.requestOptions.queryParameters,
      options: err.requestOptions.toOptions(),
    )
        .then((value) => handler.resolve(value),
        onError: (error) => handler.reject(error));
  }
}

typedef FutureOr<bool> RetryEvaluator(DioError error);

extension RequestOptionsExtensions on RequestOptions {
  Options toOptions() {
    return Options(
      method: method,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      extra: extra,
      headers: headers,
      responseType: responseType,
      contentType: contentType,
      validateStatus: validateStatus,
      receiveDataWhenStatusError: receiveDataWhenStatusError,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      requestEncoder: requestEncoder,
      responseDecoder: responseDecoder,
      listFormat: listFormat,
    );
  }
}

class RetryOptions {
  /// The number of retry in case of an error
  final int retries;

  /// The interval before a retry.
  final Duration retryInterval;

  /// Evaluating if a retry is necessary.regarding the error.
  ///
  /// It can be a good candidate for additional operations too, like
  /// updating authentication token in case of a unauthorized error (be careful
  /// with concurrency though).
  ///
  /// Defaults to [defaultRetryEvaluator].
  RetryEvaluator get retryEvaluator =>
      this._retryEvaluator ?? defaultRetryEvaluator;

  final RetryEvaluator? _retryEvaluator;

  const RetryOptions(
      {this.retries = 3,
        RetryEvaluator? retryEvaluator,
        this.retryInterval = const Duration(seconds: 1)})
      : this._retryEvaluator = retryEvaluator;

  factory RetryOptions.noRetry() {
    return RetryOptions(
      retries: 0,
    );
  }

  static const extraKey = "cache_retry_request";

  /// Returns [true] only if the response hasn't been cancelled or got
  /// a bad status code.
  static FutureOr<bool> defaultRetryEvaluator(DioError error) {
    final cancelError = error.type != DioErrorType.cancel;
    // final responseError = error.type != DioErrorType.response;
    final shouldRetry = cancelError;
    return shouldRetry;
  }

  factory RetryOptions.fromExtra(
      RequestOptions request, RetryOptions defaultOptions) {
    return request.extra[extraKey] ?? defaultOptions;
  }

  RetryOptions copyWith({
    int? retries,
    Duration? retryInterval,
  }) =>
      RetryOptions(
        retries: retries ?? this.retries,
        retryInterval: retryInterval ?? this.retryInterval,
      );

  Map<String, dynamic> toExtra() => {extraKey: this};

  Options toOptions() => Options(extra: this.toExtra());

  Options mergeIn(Options options) {
    return options.copyWith(
        extra: <String, dynamic>{}
          ..addAll(options.extra ?? {})
          ..addAll(this.toExtra()));
  }

  @override
  String toString() {
    return 'RetryOptions{retries: $retries, retryInterval: $retryInterval, _retryEvaluator: $_retryEvaluator}';
  }
}
