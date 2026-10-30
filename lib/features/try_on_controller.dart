import 'dart:async';
import 'dart:io';

import 'package:decart_vton_flutter/decart_vton_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config.dart';
import '../providers/app_providers.dart';
import '../providers/locale_providers.dart';
import '../services/development_key_store.dart';
import '../services/token_client.dart';
import '../services/try_on_gateway.dart';
import 'api_key_settings.dart';
import 'try_on_state.dart';

part 'try_on_controller.g.dart';

@riverpod
class TryOnController extends _$TryOnController {
  late TryOnGateway _gateway;
  late CameraPermissionRequest _requestCamera;
  bool _foreground = true;
  Future<void>? _stopping;

  @override
  TryOnState build() {
    _gateway = ref.watch(tryOnGatewayProvider);
    _requestCamera = ref.watch(cameraPermissionRequestProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    _stopping = null;
    final sessionRef = ref;
    final subscriptions = <StreamSubscription<dynamic>>[
      _gateway.states.listen((value) {
        if (!sessionRef.mounted) return;
        state = state.copyWith(
          connection: value,
          sessionRequested:
              !state.busy &&
                  (value == VtonConnectionState.disconnected ||
                      value == VtonConnectionState.error)
              ? false
              : state.sessionRequested,
        );
      }),
      _gateway.errors.listen((value) {
        if (sessionRef.mounted) {
          state = state.copyWith(message: _describe(value));
        }
      }),
      _gateway.events.listen((event) {
        if (!sessionRef.mounted) return;
        if (event is VtonGenerationTick) {
          state = state.copyWith(elapsed: event.elapsed);
        } else if (event is VtonConnectionQualityChanged) {
          state = state.copyWith(quality: event.quality);
        }
      }),
    ];
    ref.onDispose(() {
      for (final subscription in subscriptions) {
        unawaited(subscription.cancel());
      }
    });
    return TryOnState(prompt: localizedOutfitPresets(l10n).first.prompt);
  }

  Future<void> start() async {
    if (!ref.mounted || state.busy || !_foreground || state.isInSession) return;
    final operationRef = ref;
    await _run((operationRef) async {
      state = state.copyWith(sessionRequested: true);
      // Startup waits for the saved key before initializing the native SDK.
      await ref.read(apiKeySettingsProvider.future);
      if (!_canStart(operationRef)) return;
      if (_stopping != null) await _stopping;
      if (!_canStart(operationRef)) return;
      await _gateway.initialize();
      if (!_canStart(operationRef)) return;
      final granted = await _requestCamera();
      if (!_canStart(operationRef)) return;
      if (!granted) {
        state = state.copyWith(
          sessionRequested: false,
          message: ref.read(appLocalizationsProvider).permissionRequired,
        );
        return;
      }
      state = state.copyWith(elapsed: Duration.zero);
      await _gateway.connect(state.outfit);
      // The gateway provider releases the SDK if this provider was disposed.
      if (operationRef.mounted && !_canStart(operationRef)) {
        await _gateway.disconnect();
      }
    });
    if (operationRef.mounted && !state.connection.isInSession) {
      state = state.copyWith(sessionRequested: false);
    }
  }

  bool _canStart(Ref operationRef) =>
      operationRef.mounted && _foreground && state.sessionRequested;

  Future<void> stop({bool background = false}) async {
    if (!ref.mounted) return;
    state = state.copyWith(sessionRequested: false);
    if (_stopping != null) return _stopping;
    final operationRef = ref;
    _stopping = _disconnect(operationRef, background: background);
    try {
      await _stopping;
    } finally {
      if (operationRef.mounted) _stopping = null;
    }
  }

  Future<void> _disconnect(Ref operationRef, {required bool background}) async {
    try {
      await _gateway.disconnect();
      if (!operationRef.mounted) return;
      state = state.copyWith(
        connection: VtonConnectionState.disconnected,
        message: background
            ? ref.read(appLocalizationsProvider).pausedMessage
            : null,
      );
    } catch (error) {
      if (operationRef.mounted) {
        state = state.copyWith(message: _describe(error));
      }
    }
  }

  Future<void> setForeground(bool value) async {
    if (!ref.mounted) return;
    _foreground = value;
    if (!value && state.isInSession) await stop(background: true);
  }

  Future<void> selectPreset(int index) async {
    if (!ref.mounted || state.busy) return;
    state = state.copyWith(
      presetIndex: index,
      prompt: localizedOutfitPresets(
        ref.read(appLocalizationsProvider),
      )[index].prompt,
      garmentPath: null,
      garmentName: null,
    );
    await apply();
  }

  Future<void> selectGarment(String path, String name) => _run((
    operationRef,
  ) async {
    final length = await File(path).length();
    if (!operationRef.mounted) return;
    if (length == 0 || length > 5 * 1024 * 1024) {
      throw FormatException(ref.read(appLocalizationsProvider).imageTooLarge);
    }
    // A reference image replaces the old preset's text as well as its selection.
    state = state.copyWith(
      presetIndex: null,
      prompt: ref.read(appLocalizationsProvider).referencePrompt,
      garmentPath: path,
      garmentName: name,
    );
    if (state.isLive && state.sessionRequested) {
      await _gateway.apply(state.outfit);
    }
  });

  Future<void> setPrompt(String value) async {
    if (!ref.mounted || state.busy) return;
    state = state.copyWith(prompt: value, presetIndex: null);
    await apply();
  }

  Future<void> apply() async {
    if (!ref.mounted || !state.isLive || !state.sessionRequested) return;
    await _run((_) => _gateway.apply(state.outfit));
  }

  Future<void> switchCamera() => _run((_) => _gateway.switchCamera());

  Future<bool> saveApiKey(String value) async {
    var saved = false;
    await _run((operationRef) async {
      final key = DevelopmentKeyStore.normalizeKey(
        value,
        l10n: operationRef.read(appLocalizationsProvider),
      );
      final keys = await operationRef.read(apiKeySettingsProvider.future);
      if (!operationRef.mounted) return;
      if (!keys.enabled) {
        throw ConfigurationException(
          ref.read(appLocalizationsProvider).releaseBackendOnly,
        );
      }
      await stop();
      if (!operationRef.mounted) return;
      if (state.connection != VtonConnectionState.disconnected) {
        throw ConfigurationException(
          ref.read(appLocalizationsProvider).disconnectBeforeKey,
        );
      }
      await operationRef.read(apiKeySettingsProvider.notifier).save(key);
      if (!operationRef.mounted) return;
      state = state.copyWith(
        elapsed: Duration.zero,
        message: key.isEmpty
            ? ref.read(appLocalizationsProvider).keyCleared
            : ref.read(appLocalizationsProvider).keySaved,
      );
      saved = true;
    });
    return saved;
  }

  Future<void> _run(Future<void> Function(Ref operationRef) operation) async {
    if (!ref.mounted || state.busy) return;
    final operationRef = ref;
    state = state.copyWith(busy: true, message: null);
    try {
      await operation(operationRef);
    } catch (error) {
      if (operationRef.mounted) {
        state = state.copyWith(
          message: _describe(error),
          sessionRequested:
              state.connection.isInSession && state.sessionRequested,
        );
      }
    } finally {
      if (operationRef.mounted) state = state.copyWith(busy: false);
    }
  }

  String _describe(Object error) => switch (error) {
    ConfigurationException(:final message) => message,
    TokenException(:final message) => message,
    FormatException(:final message) => message,
    TimeoutException() => ref.read(appLocalizationsProvider).connectionTimeout,
    SocketException() => ref.read(appLocalizationsProvider).networkFailure,
    DecartVtonException(:final code) => switch (code) {
      VtonErrorCode.permissionDenied =>
        ref.read(appLocalizationsProvider).permissionRequired,
      VtonErrorCode.cameraUnavailable =>
        ref.read(appLocalizationsProvider).cameraUnavailable,
      VtonErrorCode.invalidApiKey =>
        ref.read(appLocalizationsProvider).invalidApiKey,
      VtonErrorCode.connectionTimeout =>
        ref.read(appLocalizationsProvider).connectionTimeout,
      _ => ref.read(appLocalizationsProvider).tryOnConnectionError,
    },
    _ => ref.read(appLocalizationsProvider).operationFailed,
  };
}
