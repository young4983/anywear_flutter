// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ApiKeySettings)
final apiKeySettingsProvider = ApiKeySettingsProvider._();

final class ApiKeySettingsProvider
    extends $AsyncNotifierProvider<ApiKeySettings, ApiKeyStatus> {
  ApiKeySettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiKeySettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiKeySettingsHash();

  @$internal
  @override
  ApiKeySettings create() => ApiKeySettings();
}

String _$apiKeySettingsHash() => r'f7d96b4745fa2545969e9181934a5b13f2341b38';

abstract class _$ApiKeySettings extends $AsyncNotifier<ApiKeyStatus> {
  FutureOr<ApiKeyStatus> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ApiKeyStatus>, ApiKeyStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ApiKeyStatus>, ApiKeyStatus>,
              AsyncValue<ApiKeyStatus>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
