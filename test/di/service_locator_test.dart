import 'package:boilerplate/di/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('service locator can be reset', () async {
    getIt.registerSingleton<int>(42);
    expect(getIt.isRegistered<int>(), isTrue);
    await getIt.reset();
    expect(getIt.isRegistered<int>(), isFalse);
  });
}