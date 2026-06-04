import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domain layer does not import data serialization packages', () {
    final files = Directory('lib/domain')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      final content = file.readAsStringSync();
      expect(content, isNot(contains('json_annotation')), reason: file.path);
      expect(content, isNot(contains('fromJson')), reason: file.path);
      expect(content, isNot(contains('toJson')), reason: file.path);
      expect(content, isNot(contains('fromMap')), reason: file.path);
      expect(content, isNot(contains('toMap')), reason: file.path);
    }
  });
}
