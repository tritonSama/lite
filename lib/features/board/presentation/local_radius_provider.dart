import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tasks/data/task_repository.dart';
import '../../tasks/domain/task.dart';

class SearchRadiusNotifier extends Notifier<double> {
  @override
  double build() => 10.0;

  void set(double miles) => state = miles;
}

final searchRadiusProvider =
    NotifierProvider<SearchRadiusNotifier, double>(SearchRadiusNotifier.new);

final localTasksWithinRadiusProvider = FutureProvider<List<Task>>((ref) async {
  // Use publicTasks as base since we want active tasks
  final tasksStream = ref.watch(taskRepositoryProvider).watchPublicTasks();
  final tasks = await tasksStream.first;

  // Radius is watched so the provider re-runs when it changes; real geo
  // filtering lands with the geolocator integration.
  ref.watch(searchRadiusProvider);

  // Mocking location querying to avoid geolocator dependency conflicts
  // We simply return all tasks as a placeholder for the local filter
  return tasks;
});
