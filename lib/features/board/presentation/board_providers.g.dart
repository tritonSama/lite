// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of published/bidding tasks for the Board feed.

@ProviderFor(publicTasks)
final publicTasksProvider = PublicTasksProvider._();

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
  PublicTasksProvider._()
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

/// Stream of tasks filtered by category.

@ProviderFor(categoryTasks)
final categoryTasksProvider = CategoryTasksFamily._();

/// Stream of tasks filtered by category.

final class CategoryTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  /// Stream of tasks filtered by category.
  CategoryTasksProvider._({
    required CategoryTasksFamily super.from,
    required TaskCategory super.argument,
  }) : super(
         retry: null,
         name: r'categoryTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryTasksHash();

  @override
  String toString() {
    return r'categoryTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as TaskCategory;
    return categoryTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryTasksHash() => r'edd50f633a508e9a59a6b1cf71de66d31086359b';

/// Stream of tasks filtered by category.

final class CategoryTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, TaskCategory> {
  CategoryTasksFamily._()
    : super(
        retry: null,
        name: r'categoryTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Stream of tasks filtered by category.

  CategoryTasksProvider call(TaskCategory category) =>
      CategoryTasksProvider._(argument: category, from: this);

  @override
  String toString() => r'categoryTasksProvider';
}
