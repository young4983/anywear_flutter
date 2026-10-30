// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appConfig)
final appConfigProvider = AppConfigProvider._();

final class AppConfigProvider
    extends $FunctionalProvider<AppConfig, AppConfig, AppConfig>
    with $Provider<AppConfig> {
  AppConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigHash();

  @$internal
  @override
  $ProviderElement<AppConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppConfig create(Ref ref) {
    return appConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppConfig>(value),
    );
  }
}

String _$appConfigHash() => r'87f9d20a2d92252672162b2ce97547b7b2479239';

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

final class SecureStorageProvider
    extends
        $FunctionalProvider<
          FlutterSecureStorage,
          FlutterSecureStorage,
          FlutterSecureStorage
        >
    with $Provider<FlutterSecureStorage> {
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'0cd1b80f91784467390034386f925a0be155bfbd';

@ProviderFor(developmentKeyStore)
final developmentKeyStoreProvider = DevelopmentKeyStoreProvider._();

final class DevelopmentKeyStoreProvider
    extends
        $FunctionalProvider<
          DevelopmentKeyStore?,
          DevelopmentKeyStore?,
          DevelopmentKeyStore?
        >
    with $Provider<DevelopmentKeyStore?> {
  DevelopmentKeyStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'developmentKeyStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$developmentKeyStoreHash();

  @$internal
  @override
  $ProviderElement<DevelopmentKeyStore?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DevelopmentKeyStore? create(Ref ref) {
    return developmentKeyStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DevelopmentKeyStore? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DevelopmentKeyStore?>(value),
    );
  }
}

String _$developmentKeyStoreHash() =>
    r'2aa0af7f1f45309f52b620c255349e0d9753dca3';

@ProviderFor(cameraPermissionRequest)
final cameraPermissionRequestProvider = CameraPermissionRequestProvider._();

final class CameraPermissionRequestProvider
    extends
        $FunctionalProvider<
          CameraPermissionRequest,
          CameraPermissionRequest,
          CameraPermissionRequest
        >
    with $Provider<CameraPermissionRequest> {
  CameraPermissionRequestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cameraPermissionRequestProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cameraPermissionRequestHash();

  @$internal
  @override
  $ProviderElement<CameraPermissionRequest> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CameraPermissionRequest create(Ref ref) {
    return cameraPermissionRequest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CameraPermissionRequest value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CameraPermissionRequest>(value),
    );
  }
}

String _$cameraPermissionRequestHash() =>
    r'6b3fe306af780b6669712264161b29f37bde8c8b';

@ProviderFor(accessToken)
final accessTokenProvider = AccessTokenProvider._();

final class AccessTokenProvider
    extends
        $FunctionalProvider<
          AccessTokenFetcher?,
          AccessTokenFetcher?,
          AccessTokenFetcher?
        >
    with $Provider<AccessTokenFetcher?> {
  AccessTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessTokenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessTokenHash();

  @$internal
  @override
  $ProviderElement<AccessTokenFetcher?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccessTokenFetcher? create(Ref ref) {
    return accessToken(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccessTokenFetcher? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccessTokenFetcher?>(value),
    );
  }
}

String _$accessTokenHash() => r'4b4b235ef272b1ccee766891406ad6df95c38610';

@ProviderFor(tryOnGateway)
final tryOnGatewayProvider = TryOnGatewayProvider._();

final class TryOnGatewayProvider
    extends $FunctionalProvider<TryOnGateway, TryOnGateway, TryOnGateway>
    with $Provider<TryOnGateway> {
  TryOnGatewayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tryOnGatewayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tryOnGatewayHash();

  @$internal
  @override
  $ProviderElement<TryOnGateway> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TryOnGateway create(Ref ref) {
    return tryOnGateway(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TryOnGateway value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TryOnGateway>(value),
    );
  }
}

String _$tryOnGatewayHash() => r'27a6eb8697044e56f272dc939db7817357f0d54f';
