import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config.dart';
import '../l10n/locale_utils.dart';
import '../providers/app_providers.dart';
import '../services/development_key_store.dart';

part 'api_key_settings.g.dart';

/// Deliberately excludes the credential from observable UI state.
@immutable
class ApiKeyStatus {
  const ApiKeyStatus({
    required this.enabled,
    this.hasKey = false,
    this.storageMessage,
  });

  final bool enabled;
  final bool hasKey;
  final String? storageMessage;
}

@Riverpod(keepAlive: true)
class ApiKeySettings extends _$ApiKeySettings {
  @override
  Future<ApiKeyStatus> build() async {
    final store = ref.watch(developmentKeyStoreProvider);
    await store?.load();
    return _status(store);
  }

  ApiKeyStatus _status(DevelopmentKeyStore? store) => ApiKeyStatus(
    enabled: store != null,
    hasKey: store?.hasKey ?? false,
    storageMessage: store?.storageMessage,
  );

  /// Session coordination is owned by TryOnController.saveApiKey.
  Future<void> save(String value) async {
    final operationRef = ref;
    await future;
    if (!operationRef.mounted) return;
    final store = operationRef.read(developmentKeyStoreProvider);
    if (store == null) {
      throw ConfigurationException(
        currentAppLocalizations().releaseBackendOnly,
      );
    }
    await store.save(value);
    if (operationRef.mounted) state = AsyncData(_status(store));
  }
}
