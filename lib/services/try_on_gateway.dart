import 'package:decart_vton_flutter/decart_vton_flutter.dart';

import '../config.dart';
import '../l10n/locale_utils.dart';
import 'token_client.dart';
import 'development_key_store.dart';

abstract interface class TryOnGateway {
  Stream<VtonConnectionState> get states;
  Stream<DecartVtonException> get errors;
  Stream<VtonEvent> get events;
  Future<void> initialize();
  Future<void> connect(VtonOutfit outfit);
  Future<void> apply(VtonOutfit outfit);
  Future<void> switchCamera();
  Future<void> disconnect();
  Future<void> close();
}

class DecartGateway implements TryOnGateway {
  DecartGateway(
    this.config, {
    this.accessTokenProvider,
    this.keySettings,
    DecartVton? sdk,
  }) : _sdk = sdk ?? DecartVton();
  final AppConfig config;
  final DevelopmentKeyStore? keySettings;
  final Future<String?> Function()? accessTokenProvider;
  final DecartVton _sdk;
  String? _initializedKey;

  @override
  Stream<VtonConnectionState> get states => _sdk.connectionStates;
  @override
  Stream<DecartVtonException> get errors => _sdk.errors;
  @override
  Stream<VtonEvent> get events => _sdk.events;

  @override
  Future<void> initialize() async {
    final key = keySettings?.value ?? config.developmentApiKey;
    if (keySettings != null && key.isEmpty && config.tokenEndpoint.isEmpty) {
      throw ConfigurationException(currentAppLocalizations().noDevelopmentKey);
    }
    final effectiveConfig = AppConfig(
      tokenEndpoint: keySettings != null && key.isNotEmpty
          ? ''
          : config.tokenEndpoint,
      developmentApiKey: key,
      developmentSessionToken: config.developmentSessionToken,
    );
    effectiveConfig.validate();
    if (_sdk.isInitialized && _initializedKey == key) return;
    if (key.isNotEmpty) {
      await _sdk.initializeForDevelopment(
        apiKey: key,
        force: _sdk.isInitialized,
      );
    } else {
      final tokens = TokenClient(
        endpoint: Uri.parse(config.tokenEndpoint),
        accessTokenProvider:
            accessTokenProvider ??
            (config.developmentSessionToken.isEmpty
                ? null
                : () async => config.developmentSessionToken),
      );
      await _sdk.initialize(
        clientTokenProvider: tokens.fetch,
        force: _sdk.isInitialized,
      );
    }
    _initializedKey = key;
  }

  @override
  Future<void> connect(VtonOutfit outfit) => _sdk.connect(
    model: VtonModel.lucyVtonLatest,
    initialOutfit: outfit,
    resolution: VtonResolution.p720,
    mirror: VtonMirrorMode.auto,
  );
  @override
  Future<void> apply(VtonOutfit outfit) => _sdk.setOutfit(outfit: outfit);
  @override
  Future<void> switchCamera() async {
    await _sdk.switchCamera();
  }

  @override
  Future<void> disconnect() => _sdk.disconnect();
  @override
  Future<void> close() => _sdk.dispose();
}
