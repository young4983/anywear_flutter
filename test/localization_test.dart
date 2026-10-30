import 'package:fitting_room/l10n/app_localizations.dart';
import 'package:fitting_room/l10n/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitting_room/app.dart';
import 'support/fake_gateway.dart';
import 'support/test_providers.dart';

void main() {
  test('device locales resolve to the product locales', () {
    expect(appLocaleFor(const Locale('zh', 'CN')), const Locale('zh'));
    expect(appLocaleFor(const Locale('zh', 'TW')), const Locale('zh', 'TW'));
    expect(
      appLocaleFor(
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      ),
      const Locale('zh', 'TW'),
    );
    expect(appLocaleFor(const Locale('ja', 'JP')), const Locale('en'));
    expect(appLocaleFor(const Locale('fr')), const Locale('en'));
  });

  test(
    'generated catalogs contain distinct English and Taiwan Chinese copy',
    () {
      final english = lookupAppLocalizations(const Locale('en'));
      final taiwan = lookupAppLocalizations(const Locale('zh', 'TW'));
      expect(english.startTryOn, 'Start try-on');
      expect(taiwan.startTryOn, '開始試衣');
      expect(taiwan.promptHint, contains('繁體中文'));
      expect(taiwan.presetWhiteName, '經典白襯衫');
    },
  );

  testWidgets('non-Chinese UI renders English copy', (tester) async {
    final gateway = FakeGateway();
    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(gateway: gateway, locale: const Locale('en')),
        child: const FittingRoomApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Fitting Room'), findsOneWidget);
    expect(find.text('Choose your style'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Start try-on'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Start try-on'), findsOneWidget);
    expect(find.text('海军蓝卫衣'), findsNothing);
  });

  testWidgets('Taiwan Chinese UI renders Traditional Chinese copy', (
    tester,
  ) async {
    final gateway = FakeGateway();
    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(
          gateway: gateway,
          locale: const Locale('zh', 'TW'),
        ),
        child: const FittingRoomApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('試衣間'), findsWidgets);
    expect(find.text('選擇你的風格'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('開始試衣'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('開始試衣'), findsOneWidget);
    expect(find.text('选择你的风格'), findsNothing);
  });
}
