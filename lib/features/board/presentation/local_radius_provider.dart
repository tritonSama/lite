import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tasks/data/task_repository.dart';
import '../../tasks/domain/task.dart';

final searchRadiusProvider = StateProvider<double>((ref) => 10.0);

final localTasksWithinRadiusProvider = FutureProvider<List<Task>>((ref) async {
  // Use publicTasks as base since we want active tasks
  final tasksStream = ref.watch(taskRepositoryProvider).watchPublicTasks();
  final tasks = await tasksStream.first;

  final radiusMiles = ref.watch(searchRadiusProvider);

  // Mocking location querying to avoid geolocator dependency conflicts
  // We simply return all tasks as a placeholder for the local filter
  return tasks;
});
