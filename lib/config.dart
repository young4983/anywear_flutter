import 'package:flutter/foundation.dart';

import 'l10n/locale_utils.dart';

class AppConfig {
  const AppConfig({
    this.tokenEndpoint = '',
    this.developmentApiKey = '',
    this.developmentSessionToken = '',
  });

  factory AppConfig.fromEnvironment() => const AppConfig(
    tokenEndpoint: String.fromEnvironment('DECART_TOKEN_ENDPOINT'),
    developmentApiKey: String.fromEnvironment('DECART_DEV_API_KEY'),
    developmentSessionToken: String.fromEnvironment('APP_SESSION_TOKEN'),
  );

  final String tokenEndpoint;
  final String developmentApiKey;
  final String developmentSessionToken;

  void validate() {
    if (developmentApiKey.isNotEmpty && tokenEndpoint.isNotEmpty) {
      throw ConfigurationException(
        currentAppLocalizations().backendConfigConflict,
      );
    }
    if (!kDebugMode &&
        (developmentApiKey.isNotEmpty || developmentSessionToken.isNotEmpty)) {
      throw ConfigurationException(
        currentAppLocalizations().releaseConfigError,
      );
    }
    if (developmentApiKey.isNotEmpty) {
      if (!developmentApiKey.startsWith('dct_')) {
        throw ConfigurationException(
          currentAppLocalizations().invalidDevelopmentCredential,
        );
      }
      return;
    }
    final uri = Uri.tryParse(tokenEndpoint);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasFragment ||
        uri.hasQuery) {
      throw ConfigurationException(
        currentAppLocalizations().serviceNotConfigured,
      );
    }
  }
}

class ConfigurationException implements Exception {
  const ConfigurationException(this.message);
  final String message;
  @override
  String toString() => message;
}
