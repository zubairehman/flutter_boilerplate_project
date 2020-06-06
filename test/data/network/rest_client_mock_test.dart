import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../lib/data/network/exceptions/network_exceptions.dart';
import '../../../lib/data/network/rest_client.dart';

// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.
class MockClient extends Mock implements http.Client {}

main() {
  group('RestClient', () {
    group('get', () {
      test('returns a Map if the http call completes successfully', () async {
        // Arrange
        final mockitoClient = MockClient();
        final url = 'https://example.com';

        // Act
        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(mockitoClient.get(url))
            .thenAnswer((_) async => http.Response('{"name": "Jorge"}', 200));

        final restClient = RestClient(client: mockitoClient);
        final response = await restClient.get(url);

        // Assert
        // response should be a map
        if (!(response is Map)) fail('response should be a map');
      });

      test(
          'throws a network exception if the http call completes with an error',
          () async {
        // Arrange
        final mockitoClient = MockClient();
        final url = 'https://example.com';
        dynamic error;

        // Act
        // Use Mockito to return an unsuccessful response when it calls the
        // provided http.Client.
        when(mockitoClient.get(url))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        final restClient = RestClient(client: mockitoClient);
        try {
          await restClient.get(url);
        } catch (e) {
          error = e;
        }

        // Assert
        if (!(error is NetworkException))
          fail("didn't throw network exception");
      });
    });
  });
}
