import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/domain/task.dart';
import '../../tasks/data/task_repository.dart';

part 'board_providers.g.dart';

/// Stream of published/bidding tasks for the Board feed.
@riverpod
Stream<List<Task>> publicTasks(Ref ref) {
  return ref.watch(taskRepositoryProvider).watchPublicTasks();
}
