// Optional local visual inspection: flutter test tool/preview_test.dart
// The system font stays on this Mac and is not bundled with the application.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:fitting_room/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test/support/fake_gateway.dart';
import '../test/support/test_providers.dart';

void main() {
  testWidgets('capture the real Flutter widget tree without opening a camera', (
    tester,
  ) async {
    final font = File('/System/Library/Fonts/Supplemental/Arial Unicode.ttf');
    if (!font.existsSync()) return;
    await tester.runAsync(() async {
      final loader = FontLoader('Roboto')
        ..addFont(Future.value(ByteData.sublistView(font.readAsBytesSync())));
      await loader.load();
      final icons = FontLoader('MaterialIcons')
        ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
      await icons.load();
    });
    tester.view.physicalSize = const Size(390, 1040);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: ProviderScope(
          overrides: testOverrides(
            gateway: FakeGateway(),
            requestCamera: () async => false,
          ),
          child: const FittingRoomApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      File(
        '../anywear-preview.png',
      ).writeAsBytesSync(bytes!.buffer.asUint8List());
      image.dispose();
    });
    expect(tester.takeException(), isNull);
  });
}
