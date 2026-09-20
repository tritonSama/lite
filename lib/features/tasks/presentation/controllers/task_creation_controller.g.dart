// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_creation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskCreationController)
const taskCreationControllerProvider = TaskCreationControllerProvider._();

final class TaskCreationControllerProvider
    extends $NotifierProvider<TaskCreationController, Task> {
  const TaskCreationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskCreationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskCreationControllerHash();

  @$internal
  @override
  TaskCreationController create() => TaskCreationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Task value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Task>(value),
    );
  }
}

String _$taskCreationControllerHash() =>
    r'1d2e2edb3c98e6a059473beba71d233e556c8fff';

abstract class _$TaskCreationController extends $Notifier<Task> {
  Task build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Task, Task>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Task, Task>,
              Task,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
