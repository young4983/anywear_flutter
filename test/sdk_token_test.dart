import 'package:decart_vton_flutter/decart_vton_flutter.dart';
import 'package:decart_vton_flutter/src/decart_vton_platform.dart';
import 'package:flutter_test/flutter_test.dart';

class RecordingPlatform extends DecartVtonPlatform {
  String? credential;

  @override
  Stream<VtonEvent> get events => const Stream.empty();

  @override
  Future<void> initialize({
    required String clientToken,
    required String signalingBaseUrl,
    required String httpBaseUrl,
    required String logLevel,
  }) async {
    credential = clientToken;
  }

  @override
  Future<void> release() async {}
}

void main() {
  test(
    'official JWT reaches native SDK; permanent keys are rejected',
    () async {
      final platform = RecordingPlatform();
      final sdk = DecartVton.forTesting(platform);
      const jwt =
          'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjQwNzA5MDg4MDB9.test_signature';
      await sdk.initialize(clientTokenProvider: () async => jwt);
      expect(platform.credential, jwt);
      await expectLater(
        sdk.initialize(
          clientTokenProvider: () async => 'dct_test',
          force: true,
        ),
        throwsA(isA<DecartVtonException>()),
      );
      expect(platform.credential, jwt);
      await sdk.dispose();
    },
  );
}
