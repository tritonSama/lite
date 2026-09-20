import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/domain/task.dart';
import '../../tasks/data/task_repository.dart';
import '../../../core/constants/enums.dart';

part 'board_providers.g.dart';

/// Stream of published/bidding tasks for the Board feed.
@riverpod
Stream<List<Task>> publicTasks(Ref ref) {
  return ref.watch(taskRepositoryProvider).watchPublicTasks();
}

/// Stream of tasks filtered by category.
@riverpod
Stream<List<Task>> categoryTasks(Ref ref, TaskCategory category) {
  return ref.watch(taskRepositoryProvider).watchPublicTasks(category: category);
}
