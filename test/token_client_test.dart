import 'package:fitting_room/config.dart';
import 'package:fitting_room/services/token_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only ephemeral credentials are accepted from the backend', () {
    expect(parseTokenResponse('{"apiKey":"ek_example"}'), 'ek_example');
    const jwt = 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjQwNzA5MDg4MDB9.test_signature';
    expect(parseTokenResponse('{"apiKey":"$jwt"}'), jwt);
    for (final invalid in [
      '{"apiKey":"dct_permanent_key"}',
      '{"apiKey":""}',
      '{"apiKey":"not-a-token"}',
      '{"apiKey":"header.payload"}',
      '[]',
      'invalid JSON',
      '{"apiKey":"ek_example","expiresAt":"2000-01-01T00:00:00Z"}',
    ]) {
      expect(() => parseTokenResponse(invalid), throwsA(isA<TokenException>()));
    }
  });

  test(
    'token endpoints cannot include credentials or query-string secrets',
    () {
      for (final endpoint in [
        'http://example.com/token',
        'https://user:password@example.com/token',
        'https://example.com/token?key=secret',
      ]) {
        expect(
          () => AppConfig(tokenEndpoint: endpoint).validate(),
          throwsA(isA<ConfigurationException>()),
        );
      }
      const AppConfig(tokenEndpoint: 'https://example.com/token').validate();
    },
  );
}
