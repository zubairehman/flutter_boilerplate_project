import 'package:boilerplate/core/data/network/dio/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('redacts sensitive headers and request fields', () async {
    final logs = <Object>[];
    final interceptor = LoggingInterceptor(logPrint: logs.add);

    final options = RequestOptions(
      path: '/login',
      headers: {'Authorization': 'Bearer secret', 'Cookie': 'sid=secret'},
      data: {'username': 'a@example.com', 'password': 'secret'},
    );

    interceptor.onRequest(options, RequestInterceptorHandler());

    final output = logs.join('\n');
    expect(output, isNot(contains('Bearer secret')));
    expect(output, isNot(contains('sid=secret')));
    expect(output, isNot(contains('password: secret')));
    expect(output, contains('<redacted>'));
  });
}