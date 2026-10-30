import 'dart:async';

import 'package:fitting_room/providers/app_providers.dart';
import 'package:fitting_room/providers/locale_providers.dart';
import 'package:fitting_room/services/development_key_store.dart';
import 'package:flutter_riverpod/misc.dart';
import 'dart:ui';

import 'fake_gateway.dart';

List<Override> testOverrides({
  required FakeGateway gateway,
  DevelopmentKeyStore? keys,
  CameraPermissionRequest? requestCamera,
  Locale locale = const Locale('zh'),
}) => [
  appLocaleProvider.overrideWithValue(locale),
  tryOnGatewayProvider.overrideWith((ref) {
    ref.onDispose(() => unawaited(gateway.close()));
    return gateway;
  }),
  developmentKeyStoreProvider.overrideWithValue(keys),
  cameraPermissionRequestProvider.overrideWithValue(
    requestCamera ?? () async => true,
  ),
];
