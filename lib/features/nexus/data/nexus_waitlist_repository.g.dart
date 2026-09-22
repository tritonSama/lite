// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nexus_waitlist_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nexusWaitlistRepository)
final nexusWaitlistRepositoryProvider = NexusWaitlistRepositoryProvider._();

final class NexusWaitlistRepositoryProvider
    extends
        $FunctionalProvider<
          NexusWaitlistRepository,
          NexusWaitlistRepository,
          NexusWaitlistRepository
        >
    with $Provider<NexusWaitlistRepository> {
  NexusWaitlistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nexusWaitlistRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nexusWaitlistRepositoryHash();

  @$internal
  @override
  $ProviderElement<NexusWaitlistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NexusWaitlistRepository create(Ref ref) {
    return nexusWaitlistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NexusWaitlistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NexusWaitlistRepository>(value),
    );
  }
}

String _$nexusWaitlistRepositoryHash() =>
    r'292b54d2c6a87a91471ecd45e7f63ac61c963805';

@ProviderFor(isUserOnWaitlist)
final isUserOnWaitlistProvider = IsUserOnWaitlistProvider._();

final class IsUserOnWaitlistProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsUserOnWaitlistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isUserOnWaitlistProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isUserOnWaitlistHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isUserOnWaitlist(ref);
  }
}

String _$isUserOnWaitlistHash() => r'1c5eaa1d8884691d4b7546846fd4138c26f2ca5c';
