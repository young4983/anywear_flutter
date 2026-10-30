import 'package:fitting_room/app.dart';
import 'package:fitting_room/services/development_key_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_gateway.dart';
import 'support/test_providers.dart';

void main() {
  testWidgets(
    'narrow phone layout stays usable and does not open the camera on launch',
    (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final gateway = FakeGateway();
      await tester.pumpWidget(
        ProviderScope(
          overrides: testOverrides(gateway: gateway),
          child: const FittingRoomApp(),
        ),
      );
      expect(find.text('试衣间'), findsOneWidget);
      expect(gateway.connectCalls, 0);
      await tester.drag(find.byType(ListView).first, const Offset(0, -480));
      await tester.pumpAndSettle();
      await tester.tap(find.text('开始试衣'));
      await tester.pumpAndSettle();
      expect(find.text('同意并开始'), findsOneWidget);
      await tester.tap(find.text('暂不开启'));
      await tester.pumpAndSettle();
      expect(gateway.connectCalls, 0);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('live video exposes a fullscreen toggle', (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final gateway = FakeGateway();
    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(gateway: gateway),
        child: const FittingRoomApp(),
      ),
    );
    await tester.drag(find.byType(ListView).first, const Offset(0, -520));
    await tester.pumpAndSettle();
    await tester.tap(find.text('开始试衣'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('同意并开始'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('全屏查看'), findsOneWidget);
    await tester.tap(find.byTooltip('全屏查看'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('退出全屏'), findsOneWidget);
    await tester.tap(find.byTooltip('退出全屏'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('全屏查看'), findsOneWidget);
    await tester.tap(find.byTooltip('全屏查看'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    expect(gateway.closeCalls, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('key settings hide the existing key and save a replacement', (
    tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    final keys = DevelopmentKeyStore(fallbackKey: 'dct_previous_secret');
    final gateway = FakeGateway();
    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(gateway: gateway, keys: keys),
        child: const FittingRoomApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('AI Key 设置'));
    await tester.pumpAndSettle();
    expect(find.text('当前已配置 Key'), findsOneWidget);
    expect(find.text('dct_previous_secret'), findsNothing);
    final field = find.byKey(const ValueKey('api-key-input'));
    expect(tester.widget<TextField>(field).obscureText, isTrue);
    await tester.enterText(field, 'invalid');
    await tester.tap(find.text('保存 Key'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(field).decoration!.errorText,
      contains('以 dct_ 开头'),
    );
    expect(keys.value, 'dct_previous_secret');
    await tester.enterText(field, 'dct_new_secret');
    await tester.tap(find.text('保存 Key'));
    await tester.pumpAndSettle();
    expect(keys.value, 'dct_new_secret');
    expect(gateway.connectCalls, 0);
    expect(find.byKey(const ValueKey('api-key-input')), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
