import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config.dart';
import '../services/development_key_store.dart';
import '../services/try_on_gateway.dart';

part 'app_providers.g.dart';

@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) => AppConfig.fromEnvironment();

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) => const FlutterSecureStorage();

// The store holds credentials. UI providers expose configuration status only.
@Riverpod(keepAlive: true)
DevelopmentKeyStore? developmentKeyStore(Ref ref) {
  if (!kDebugMode) return null;
  return DevelopmentKeyStore(
    fallbackKey: ref.watch(appConfigProvider).developmentApiKey,
    storage: ref.watch(secureStorageProvider),
  );
}

typedef CameraPermissionRequest = Future<bool> Function();
typedef AccessTokenFetcher = Future<String?> Function();

@Riverpod(keepAlive: true)
CameraPermissionRequest cameraPermissionRequest(Ref ref) =>
    () async => (await Permission.camera.request()).isGranted;

// Override this with the application's authenticated backend session.
@Riverpod(keepAlive: true)
AccessTokenFetcher? accessToken(Ref ref) => null;

@riverpod
TryOnGateway tryOnGateway(Ref ref) {
  final gateway = DecartGateway(
    ref.watch(appConfigProvider),
    keySettings: ref.watch(developmentKeyStoreProvider),
    accessTokenProvider: ref.watch(accessTokenProvider),
  );
  ref.onDispose(() => unawaited(gateway.close()));
  return gateway;
}
