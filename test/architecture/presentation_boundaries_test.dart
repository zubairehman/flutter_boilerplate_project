import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('presentation does not import SharedPreferences or preference keys', () {
    final files = Directory('lib/presentation')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      final content = file.readAsStringSync();
      expect(content,
          isNot(contains('package:shared_preferences/shared_preferences.dart')),
          reason: file.path);
      expect(content,
          isNot(contains('data/sharedpref/constants/preferences.dart')),
          reason: file.path);
    }
  });
}
