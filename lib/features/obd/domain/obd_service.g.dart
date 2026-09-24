// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obd_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(obdService)
const obdServiceProvider = ObdServiceProvider._();

final class ObdServiceProvider
    extends $FunctionalProvider<ObdService, ObdService, ObdService>
    with $Provider<ObdService> {
  const ObdServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'obdServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$obdServiceHash();

  @$internal
  @override
  $ProviderElement<ObdService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObdService create(Ref ref) {
    return obdService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObdService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObdService>(value),
    );
  }
}

String _$obdServiceHash() => r'25dd86c7397d0b15192bb4c3b79958bf34639d7e';

@ProviderFor(ObdStateNotifier)
const obdStateProvider = ObdStateNotifierProvider._();

final class ObdStateNotifierProvider
    extends $NotifierProvider<ObdStateNotifier, ObdData> {
  const ObdStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'obdStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$obdStateNotifierHash();

  @$internal
  @override
  ObdStateNotifier create() => ObdStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObdData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObdData>(value),
    );
  }
}

String _$obdStateNotifierHash() => r'13756e6ff76c750e9e13e935ed10a623e156cde4';

abstract class _$ObdStateNotifier extends $Notifier<ObdData> {
  ObdData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ObdData, ObdData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ObdData, ObdData>,
              ObdData,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
