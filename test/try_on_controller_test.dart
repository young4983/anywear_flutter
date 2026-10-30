import 'dart:async';
import 'dart:io';

import 'package:decart_vton_flutter/decart_vton_flutter.dart';
import 'package:fitting_room/features/try_on_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitting_room/features/try_on_state.dart';

import 'support/fake_gateway.dart';
import 'support/test_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeGateway gateway;
  late TryOnController controller;
  late ProviderContainer container;
  TryOnState currentState() => container.read(tryOnControllerProvider);
  setUp(() {
    gateway = FakeGateway();
    container = ProviderContainer.test(
      overrides: testOverrides(gateway: gateway),
    );
    container.listen(tryOnControllerProvider, (_, _) {});
    controller = container.read(tryOnControllerProvider.notifier);
  });

  test(
    'backgrounding during initialization never starts a billable session',
    () async {
      gateway.initializing = Completer<void>();
      final start = controller.start();
      await Future<void>.delayed(Duration.zero);
      await controller.setForeground(false);
      gateway.initializing!.complete();
      await start;
      expect(gateway.connectCalls, 0);
      expect(currentState().isInSession, isFalse);
      await controller.setForeground(true);
      expect(gateway.connectCalls, 0);
    },
  );

  test('stopping while connecting closes a late-arriving connection', () async {
    gateway.connecting = Completer<void>();
    final start = controller.start();
    await Future<void>.delayed(Duration.zero);
    await controller.stop();
    gateway.connecting!.complete();
    await start;
    expect(currentState().isInSession, isFalse);
    expect(currentState().connection, VtonConnectionState.disconnected);
    expect(gateway.disconnectCalls, greaterThanOrEqualTo(1));
  });

  test('denied camera permission does not open a remote session', () async {
    container.dispose();
    gateway = FakeGateway();
    container = ProviderContainer.test(
      overrides: testOverrides(
        gateway: gateway,
        requestCamera: () async => false,
      ),
    );
    container.listen(tryOnControllerProvider, (_, _) {});
    controller = container.read(tryOnControllerProvider.notifier);
    await controller.start();
    expect(gateway.connectCalls, 0);
    expect(currentState().isInSession, isFalse);
    expect(currentState().message, contains('权限'));
  });

  test(
    'a reference image replaces the preset prompt; edits preserve the image',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'fitting-room-test-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final image = File('${directory.path}/garment.jpg');
      await image.writeAsBytes([0xff, 0xd8, 0xff, 0xd9]);
      await controller.start();
      await controller.selectGarment(image.path, 'red-dress.jpg');
      expect(currentState().presetIndex, isNull);
      expect(gateway.applied.last.prompt, contains('参考图片'));
      await controller.setPrompt('将上衣换成这件红色夹克，保留银色拉链。');
      expect(gateway.applied.last.referenceImagePath, image.path);
      expect(gateway.applied.last.prompt, '将上衣换成这件红色夹克，保留银色拉链。');
      expect(gateway.applied.last.enhance, isTrue);
      await controller.selectPreset(1);
      expect(gateway.applied.last.referenceImagePath, isNull);
    },
  );

  test(
    'preset descriptions and connection prompts use simplified Chinese',
    () async {
      expect(currentState().prompt, contains('海军蓝'));
      expect(currentState().outfit.prompt, currentState().prompt);
      await controller.setPrompt('换成浅灰色宽松卫衣，搭配白色抽绳。');
      await controller.start();
      expect(currentState().outfit.prompt, '换成浅灰色宽松卫衣，搭配白色抽绳。');
      expect(currentState().outfit.enhance, isTrue);
    },
  );

  test('oversized reference images are rejected before upload', () async {
    final directory = await Directory.systemTemp.createTemp(
      'fitting-room-test-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final image = File('${directory.path}/garment.jpg');
    final handle = await image.open(mode: FileMode.write);
    await handle.truncate(5 * 1024 * 1024 + 1);
    await handle.close();
    await controller.start();
    await controller.selectGarment(image.path, 'large.jpg');
    expect(gateway.applied, isEmpty);
    expect(currentState().message, contains('5 MB'));
  });
}
