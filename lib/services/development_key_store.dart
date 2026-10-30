import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';
import '../l10n/locale_utils.dart';

/// Device-local debug credentials. Release builds use backend client tokens.
class DevelopmentKeyStore {
  DevelopmentKeyStore({
    required this.fallbackKey,
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  static const storageKey = 'decart_development_api_key';
  final String fallbackKey;
  final FlutterSecureStorage _storage;
  String? _savedKey;
  String? storageMessage;
  Future<void>? _loading;

  String get value => _savedKey ?? fallbackKey;
  bool get hasKey => value.isNotEmpty;

  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    if (!kDebugMode) return;
    try {
      _savedKey = await _storage.read(key: storageKey);
    } catch (_) {
      storageMessage = currentAppLocalizations().keyStorageReadFailed;
    }
  }

  Future<void> save(String input) async {
    if (!kDebugMode) {
      throw ConfigurationException(
        currentAppLocalizations().releaseBackendOnly,
      );
    }
    final key = normalizeKey(input);
    // Finish the initial read before writing so it cannot restore an old key.
    await load();
    try {
      // An empty override deliberately disables a key compiled into debug builds.
      await _storage.write(key: storageKey, value: key);
    } catch (_) {
      throw ConfigurationException(currentAppLocalizations().saveKeyFailed);
    }
    _savedKey = key;
    storageMessage = null;
  }

  static String normalizeKey(String input, {AppLocalizations? l10n}) {
    final key = input.trim();
    if (key.isNotEmpty &&
        (!RegExp(r'^dct_[A-Za-z0-9_-]+$').hasMatch(key) || key.length <= 4)) {
      throw ConfigurationException(
        (l10n ?? currentAppLocalizations()).keyFormatError,
      );
    }
    return key;
  }
}
