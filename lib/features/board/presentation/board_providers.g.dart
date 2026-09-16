// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of published/bidding tasks for the Board feed.

@ProviderFor(publicTasks)
const publicTasksProvider = PublicTasksProvider._();

/// Stream of published/bidding tasks for the Board feed.

final class PublicTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  /// Stream of published/bidding tasks for the Board feed.
  const PublicTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publicTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publicTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return publicTasks(ref);
  }
}

String _$publicTasksHash() => r'9413adff0619033f88e927edaad3468bb4a0552a';
