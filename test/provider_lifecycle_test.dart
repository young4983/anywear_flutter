import 'dart:async';

import 'package:decart_vton_flutter/decart_vton_flutter.dart';
import 'package:fitting_room/features/try_on_controller.dart';
import 'package:fitting_room/features/try_on_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_gateway.dart';
import 'support/test_providers.dart';

void main() {
  test('SDK events emit new immutable state snapshots', () async {
    final gateway = FakeGateway();
    final container = ProviderContainer.test(
      overrides: testOverrides(gateway: gateway),
    );
    final updates = <TryOnState>[];
    container.listen(tryOnControllerProvider, (_, next) => updates.add(next));
    final initial = container.read(tryOnControllerProvider);
    final controller = container.read(tryOnControllerProvider.notifier);
    await controller.start();
    gateway.eventChanges.add(const VtonGenerationTick(Duration(seconds: 7)));
    gateway.eventChanges.add(
      const VtonConnectionQualityChanged(quality: VtonConnectionQuality.poor),
    );
    await Future<void>.delayed(Duration.zero);
    final current = container.read(tryOnControllerProvider);
    expect(current.isLive, isTrue);
    expect(current.elapsed, const Duration(seconds: 7));
    expect(current.quality, VtonConnectionQuality.poor);
    expect(initial.connection, VtonConnectionState.idle);
    expect(initial.elapsed, Duration.zero);
    expect(updates.last, same(current));
  });

  test(
    'last listener leaving cancels subscriptions and releases the gateway',
    () async {
      final gateway = FakeGateway();
      final container = ProviderContainer.test(
        overrides: testOverrides(gateway: gateway),
      );
      final subscription = container.listen(tryOnControllerProvider, (_, _) {});
      await container.read(tryOnControllerProvider.notifier).start();
      expect(gateway.stateChanges.hasListener, isTrue);
      subscription.close();
      await container.pump();
      await container.pump();
      expect(gateway.closeCalls, 1);
      expect(gateway.stateChanges.hasListener, isFalse);
      expect(gateway.errorChanges.hasListener, isFalse);
      expect(gateway.eventChanges.hasListener, isFalse);
      expect(container.exists(tryOnControllerProvider), isFalse);
    },
  );

  test(
    'disposing during initialization prevents a late camera request',
    () async {
      final gateway = FakeGateway()..initializing = Completer<void>();
      var cameraRequests = 0;
      final container = ProviderContainer.test(
        overrides: testOverrides(
          gateway: gateway,
          requestCamera: () async {
            cameraRequests++;
            return true;
          },
        ),
      );
      container.listen(tryOnControllerProvider, (_, _) {});
      final start = container.read(tryOnControllerProvider.notifier).start();
      await Future<void>.delayed(Duration.zero);
      expect(gateway.initializeCalls, 1);
      container.dispose();
      gateway.initializing!.complete();
      await start;
      expect(cameraRequests, 0);
      expect(gateway.connectCalls, 0);
      expect(gateway.closeCalls, 1);
    },
  );

  test(
    'disposing during connection ignores late results without state writes',
    () async {
      final gateway = FakeGateway()..connecting = Completer<void>();
      final container = ProviderContainer.test(
        overrides: testOverrides(gateway: gateway),
      );
      container.listen(tryOnControllerProvider, (_, _) {});
      final start = container.read(tryOnControllerProvider.notifier).start();
      await Future<void>.delayed(Duration.zero);
      expect(gateway.connectCalls, 1);
      container.dispose();
      gateway.connecting!.complete();
      await start;
      expect(gateway.closeCalls, 1);
      expect(gateway.stateChanges.hasListener, isFalse);
    },
  );

  test(
    'backgrounding a live session stops it and foregrounding never reconnects',
    () async {
      final gateway = FakeGateway();
      final container = ProviderContainer.test(
        overrides: testOverrides(gateway: gateway),
      );
      container.listen(tryOnControllerProvider, (_, _) {});
      final controller = container.read(tryOnControllerProvider.notifier);
      await controller.start();
      await controller.setForeground(false);
      expect(container.read(tryOnControllerProvider).isInSession, isFalse);
      expect(container.read(tryOnControllerProvider).message, contains('暂停'));
      await controller.setForeground(true);
      expect(gateway.connectCalls, 1);
      expect(gateway.disconnectCalls, 1);
    },
  );
}
