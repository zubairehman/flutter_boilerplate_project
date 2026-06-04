import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('baseUrl uses HTTPS', () {
    expect(Uri.parse(Endpoints.baseUrl).scheme, 'https');
  });
}