import 'dart:async';

import 'package:fitting_room/features/api_key_settings.dart';
import 'package:fitting_room/features/try_on_controller.dart';
import 'package:fitting_room/services/development_key_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_gateway.dart';
import 'support/test_providers.dart';

class DelayedKeyStore extends DevelopmentKeyStore {
  DelayedKeyStore() : super(fallbackKey: 'dct_compiled_key');
  final ready = Completer<void>();

  @override
  Future<void> load() async {
    await ready.future;
    await super.load();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test(
    'starting waits for persisted credentials before initializing the SDK',
    () async {
      FlutterSecureStorage.setMockInitialValues({
        DevelopmentKeyStore.storageKey: 'dct_saved_key',
      });
      final keys = DelayedKeyStore();
      final gateway = FakeGateway();
      final container = ProviderContainer.test(
        overrides: testOverrides(gateway: gateway, keys: keys),
      );
      container.listen(tryOnControllerProvider, (_, _) {});
      final start = container.read(tryOnControllerProvider.notifier).start();
      await Future<void>.delayed(Duration.zero);
      expect(container.read(apiKeySettingsProvider).isLoading, isTrue);
      expect(gateway.initializeCalls, 0);
      expect(gateway.connectCalls, 0);
      keys.ready.complete();
      await start;
      expect(keys.value, 'dct_saved_key');
      expect(gateway.connectCalls, 1);
    },
  );

  test('backgrounding while credentials load never opens a session', () async {
    final keys = DelayedKeyStore();
    final gateway = FakeGateway();
    final container = ProviderContainer.test(
      overrides: testOverrides(gateway: gateway, keys: keys),
    );
    container.listen(tryOnControllerProvider, (_, _) {});
    final controller = container.read(tryOnControllerProvider.notifier);
    final start = controller.start();
    await Future<void>.delayed(Duration.zero);
    await controller.setForeground(false);
    keys.ready.complete();
    await start;
    expect(gateway.initializeCalls, 0);
    expect(gateway.connectCalls, 0);
    expect(container.read(tryOnControllerProvider).isInSession, isFalse);
  });

  test(
    'key status updates after clear and reload without restoring the build key',
    () async {
      final keys = DevelopmentKeyStore(fallbackKey: 'dct_compiled_key');
      final gateway = FakeGateway();
      final container = ProviderContainer.test(
        overrides: testOverrides(gateway: gateway, keys: keys),
      );
      container.listen(tryOnControllerProvider, (_, _) {});
      final controller = container.read(tryOnControllerProvider.notifier);
      expect(
        (await container.read(apiKeySettingsProvider.future)).hasKey,
        isTrue,
      );
      expect(await controller.saveApiKey(''), isTrue);
      expect(
        container.read(apiKeySettingsProvider).requireValue.hasKey,
        isFalse,
      );
      container.invalidate(apiKeySettingsProvider);
      expect(
        (await container.read(apiKeySettingsProvider.future)).hasKey,
        isFalse,
      );
      expect(
        container.read(tryOnControllerProvider.notifier),
        same(controller),
      );
      expect(gateway.closeCalls, 0);
      expect(gateway.connectCalls, 0);
      final reopened = DevelopmentKeyStore(fallbackKey: 'dct_compiled_key');
      await reopened.load();
      expect(reopened.hasKey, isFalse);
    },
  );

  test(
    'failed disconnect keeps the existing key and reports the failure',
    () async {
      final keys = DevelopmentKeyStore(fallbackKey: 'dct_previous');
      final gateway = FakeGateway();
      final container = ProviderContainer.test(
        overrides: testOverrides(gateway: gateway, keys: keys),
      );
      container.listen(tryOnControllerProvider, (_, _) {});
      final controller = container.read(tryOnControllerProvider.notifier);
      await controller.start();
      gateway.disconnectError = StateError('disconnect failed');
      expect(await controller.saveApiKey('dct_replacement'), isFalse);
      expect(keys.value, 'dct_previous');
      expect(container.read(tryOnControllerProvider).message, contains('尚未断开'));
      expect(gateway.connectCalls, 1);
    },
  );

  test(
    'backend-only configuration exposes no development-key settings',
    () async {
      final gateway = FakeGateway();
      final container = ProviderContainer.test(
        overrides: testOverrides(gateway: gateway),
      );
      container.listen(tryOnControllerProvider, (_, _) {});
      expect(
        (await container.read(apiKeySettingsProvider.future)).enabled,
        isFalse,
      );
      expect(
        await container
            .read(tryOnControllerProvider.notifier)
            .saveApiKey('dct_test'),
        isFalse,
      );
      expect(gateway.disconnectCalls, 0);
    },
  );
}
