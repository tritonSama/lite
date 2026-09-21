// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bidRepository)
const bidRepositoryProvider = BidRepositoryProvider._();

final class BidRepositoryProvider
    extends $FunctionalProvider<BidRepository, BidRepository, BidRepository>
    with $Provider<BidRepository> {
  const BidRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bidRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bidRepositoryHash();

  @$internal
  @override
  $ProviderElement<BidRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BidRepository create(Ref ref) {
    return bidRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BidRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BidRepository>(value),
    );
  }
}

String _$bidRepositoryHash() => r'55af460f9675734a5390d0b4afce5821091c1102';
