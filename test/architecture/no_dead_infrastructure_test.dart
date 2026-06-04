import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('removed sample infrastructure is not registered in DI', () {
    final networkModule =
        File('lib/data/di/module/network_module.dart').readAsStringSync();
    expect(networkModule, isNot(contains('RestClient')));
    expect(networkModule, isNot(contains('EventBus')));
  });
}
