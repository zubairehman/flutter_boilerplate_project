import 'package:boilerplate/utils/jwt/jwt_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JwtHelper', () {
    const secret = 'test-secret-key';

    test('signs and verifies claims with matching secret', () {
      final token = JwtHelper.sign(
        {'userId': 42, 'role': 'tester'},
        secret: secret,
        issuer: 'boilerplate',
        audience: 'boilerplate-example',
        expiresIn: const Duration(minutes: 5),
      );

      final claims = JwtHelper.tryVerify(
        token,
        secret: secret,
        issuer: 'boilerplate',
        audience: 'boilerplate-example',
      );

      expect(claims, isNotNull);
      expect(claims!['userId'], 42);
      expect(claims['role'], 'tester');
    });

    test('returns null when verification fails', () {
      final token = JwtHelper.sign(
        {'userId': 42},
        secret: secret,
      );

      final claims = JwtHelper.tryVerify(
        token,
        secret: 'wrong-secret',
      );

      expect(claims, isNull);
    });

    test('returns null for expired tokens', () {
      final token = JwtHelper.sign(
        {'userId': 42},
        secret: secret,
        expiresIn: const Duration(seconds: -1),
      );

      final claims = JwtHelper.tryVerify(token, secret: secret);

      expect(claims, isNull);
    });

    test('decodes claims without verifying the signature', () {
      final token = JwtHelper.sign(
        {'userId': 42},
        secret: secret,
      );

      final claims = JwtHelper.tryDecode(token);

      expect(claims, isNotNull);
      expect(claims!['userId'], 42);
    });
  });
}
