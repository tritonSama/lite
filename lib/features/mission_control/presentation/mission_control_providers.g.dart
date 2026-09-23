// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_control_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$friendLocationsHash() => r'6728b7f299044fa57ec9d05c5215618781dfd56d';
