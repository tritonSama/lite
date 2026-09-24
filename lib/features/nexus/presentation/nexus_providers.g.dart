// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nexus_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NexusWaitlistController)
const nexusWaitlistControllerProvider = NexusWaitlistControllerProvider._();

final class NexusWaitlistControllerProvider
    extends $AsyncNotifierProvider<NexusWaitlistController, void> {
  const NexusWaitlistControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nexusWaitlistControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nexusWaitlistControllerHash();

  @$internal
  @override
  NexusWaitlistController create() => NexusWaitlistController();
}

String _$nexusWaitlistControllerHash() =>
    r'6549db8733493faf8587985b8485204a08f0c18b';

abstract class _$NexusWaitlistController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
