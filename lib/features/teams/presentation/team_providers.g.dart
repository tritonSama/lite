// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedTeam)
const selectedTeamProvider = SelectedTeamProvider._();

final class SelectedTeamProvider
    extends $NotifierProvider<SelectedTeam, String?> {
  const SelectedTeamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTeamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTeamHash();

  @$internal
  @override
  SelectedTeam create() => SelectedTeam();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedTeamHash() => r'd25f47120c128d7ca958003646e85b487bccd727';

abstract class _$SelectedTeam extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(teams)
const teamsProvider = TeamsProvider._();

final class TeamsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Team>>,
          List<Team>,
          FutureOr<List<Team>>
        >
    with $FutureModifier<List<Team>>, $FutureProvider<List<Team>> {
  const TeamsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamsHash();

  @$internal
  @override
  $FutureProviderElement<List<Team>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Team>> create(Ref ref) {
    return teams(ref);
  }
}

String _$teamsHash() => r'b3bc43f0057ce5d986a8f92bec81fb0be5476e0c';

/// Helper provider to get permissions for a user in a team.
/// Resolves dynamically: if user is member of a child, they have permissions
/// in the parent organizations as well.

@ProviderFor(hasTeamPermission)
const hasTeamPermissionProvider = HasTeamPermissionFamily._();

/// Helper provider to get permissions for a user in a team.
/// Resolves dynamically: if user is member of a child, they have permissions
/// in the parent organizations as well.

final class HasTeamPermissionProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Helper provider to get permissions for a user in a team.
  /// Resolves dynamically: if user is member of a child, they have permissions
  /// in the parent organizations as well.
  const HasTeamPermissionProvider._({
    required HasTeamPermissionFamily super.from,
    required ({String userId, String targetTeamId}) super.argument,
  }) : super(
         retry: null,
         name: r'hasTeamPermissionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hasTeamPermissionHash();

  @override
  String toString() {
    return r'hasTeamPermissionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as ({String userId, String targetTeamId});
    return hasTeamPermission(
      ref,
      userId: argument.userId,
      targetTeamId: argument.targetTeamId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HasTeamPermissionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hasTeamPermissionHash() => r'feef61e5be16078b3a77a3d4739aebed32625288';

/// Helper provider to get permissions for a user in a team.
/// Resolves dynamically: if user is member of a child, they have permissions
/// in the parent organizations as well.

final class HasTeamPermissionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({String userId, String targetTeamId})
        > {
  const HasTeamPermissionFamily._()
    : super(
        retry: null,
        name: r'hasTeamPermissionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Helper provider to get permissions for a user in a team.
  /// Resolves dynamically: if user is member of a child, they have permissions
  /// in the parent organizations as well.

  HasTeamPermissionProvider call({
    required String userId,
    required String targetTeamId,
  }) => HasTeamPermissionProvider._(
    argument: (userId: userId, targetTeamId: targetTeamId),
    from: this,
  );

  @override
  String toString() => r'hasTeamPermissionProvider';
}
