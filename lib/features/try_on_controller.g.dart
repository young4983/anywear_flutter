// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'try_on_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TryOnController)
final tryOnControllerProvider = TryOnControllerProvider._();

final class TryOnControllerProvider
    extends $NotifierProvider<TryOnController, TryOnState> {
  TryOnControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tryOnControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tryOnControllerHash();

  @$internal
  @override
  TryOnController create() => TryOnController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TryOnState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TryOnState>(value),
    );
  }
}

String _$tryOnControllerHash() => r'fd52d184148553c914d1cab38b3600b17ea3345a';

abstract class _$TryOnController extends $Notifier<TryOnState> {
  TryOnState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TryOnState, TryOnState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TryOnState, TryOnState>,
              TryOnState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
