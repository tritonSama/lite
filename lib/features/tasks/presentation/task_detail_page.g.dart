// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_detail_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskDetail)
final taskDetailProvider = TaskDetailFamily._();

final class TaskDetailProvider
    extends $FunctionalProvider<AsyncValue<Task?>, Task?, Stream<Task?>>
    with $FutureModifier<Task?>, $StreamProvider<Task?> {
  TaskDetailProvider._({
    required TaskDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskDetailHash();

  @override
  String toString() {
    return r'taskDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Task?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Task?> create(Ref ref) {
    final argument = this.argument as String;
    return taskDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskDetailHash() => r'11d545a1bc13e1feb5a41d925be16821f2720d53';

final class TaskDetailFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Task?>, String> {
  TaskDetailFamily._()
    : super(
        retry: null,
        name: r'taskDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskDetailProvider call(String taskId) =>
      TaskDetailProvider._(argument: taskId, from: this);

  @override
  String toString() => r'taskDetailProvider';
}
