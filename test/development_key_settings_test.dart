import 'package:decart_vton_flutter/decart_vton_flutter.dart';
import 'package:fitting_room/config.dart';
import 'package:fitting_room/features/try_on_controller.dart';
import 'package:fitting_room/services/development_key_store.dart';
import 'package:fitting_room/services/try_on_gateway.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitting_room/features/api_key_settings.dart';

import 'sdk_token_test.dart' show RecordingPlatform;
import 'support/fake_gateway.dart';
import 'support/test_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test(
    'saved key survives restart; clearing disables the compiled fallback',
    () async {
      final settings = DevelopmentKeyStore(fallbackKey: 'dct_build_key');
      await settings.load();
      expect(settings.value, 'dct_build_key');
      await settings.save(' dct_replacement_key ');
      final reopened = DevelopmentKeyStore(fallbackKey: 'dct_build_key');
      await reopened.load();
      expect(reopened.value, 'dct_replacement_key');
      await reopened.save('');
      final cleared = DevelopmentKeyStore(fallbackKey: 'dct_build_key');
      await cleared.load();
      expect(cleared.hasKey, isFalse);
      expect(cleared.value, '');
    },
  );

  test(
    'replacement stops the session; invalid input keeps the previous key',
    () async {
      final settings = DevelopmentKeyStore(fallbackKey: 'dct_previous');
      final gateway = FakeGateway();
      final container = ProviderContainer.test(
        overrides: testOverrides(gateway: gateway, keys: settings),
      );
      container.listen(tryOnControllerProvider, (_, _) {});
      final controller = container.read(tryOnControllerProvider.notifier);
      await controller.start();
      expect(container.read(tryOnControllerProvider).isLive, isTrue);
      expect(await controller.saveApiKey('invalid'), isFalse);
      expect(settings.value, 'dct_previous');
      expect(container.read(tryOnControllerProvider).isLive, isTrue);
      expect(await controller.saveApiKey('dct_new_key'), isTrue);
      expect(container.read(tryOnControllerProvider).isInSession, isFalse);
      expect(gateway.disconnectCalls, 1);
      expect(settings.value, 'dct_new_key');
      expect(
        container.read(apiKeySettingsProvider).requireValue.hasKey,
        isTrue,
      );
      expect(
        container.read(tryOnControllerProvider.notifier),
        same(controller),
      );
      expect(
        gateway.connectCalls,
        1,
      ); // Saving never reconnects or opens a camera.
    },
  );

  test('next initialization replaces the native SDK credential', () async {
    final settings = DevelopmentKeyStore(fallbackKey: 'dct_first_key');
    final platform = RecordingPlatform();
    final sdk = DecartVton.forTesting(platform);
    final gateway = DecartGateway(
      const AppConfig(),
      keySettings: settings,
      sdk: sdk,
    );
    addTearDown(gateway.close);
    await gateway.initialize();
    expect(platform.credential, 'dct_first_key');
    await settings.save('dct_second_key');
    await gateway.initialize();
    expect(platform.credential, 'dct_second_key');
    await settings.save('');
    await expectLater(
      gateway.initialize(),
      throwsA(isA<ConfigurationException>()),
    );
  });
}
