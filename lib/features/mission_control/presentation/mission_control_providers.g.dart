// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_control_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userLocation)
final userLocationProvider = UserLocationProvider._();

final class UserLocationProvider
    extends
        $FunctionalProvider<AsyncValue<Position>, Position, Stream<Position>>
    with $FutureModifier<Position>, $StreamProvider<Position> {
  UserLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userLocationHash();

  @$internal
  @override
  $StreamProviderElement<Position> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Position> create(Ref ref) {
    return userLocation(ref);
  }
}

String _$userLocationHash() => r'17614ca5b5eb6183461fdd502ea1cc536eb76dbe';

@ProviderFor(friendLocations)
final friendLocationsProvider = FriendLocationsProvider._();

final class FriendLocationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FriendLocation>>,
          List<FriendLocation>,
          FutureOr<List<FriendLocation>>
        >
    with
        $FutureModifier<List<FriendLocation>>,
        $FutureProvider<List<FriendLocation>> {
  FriendLocationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendLocationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendLocationsHash();

  @$internal
  @override
  $FutureProviderElement<List<FriendLocation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FriendLocation>> create(Ref ref) {
    return friendLocations(ref);
  }
}

String _$friendLocationsHash() => r'df9cd922c26e6447279e3dd1921f537de6305243';
