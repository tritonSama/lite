import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/task.dart';
import '../../../core/constants/enums.dart';

part 'task_repository.g.dart';

// ── Repository provider ───────────────────────────────────────────────────────
@riverpod
TaskRepository taskRepository(Ref ref) => TaskRepository();

// ── Firestore withConverter ───────────────────────────────────────────────────
extension _TaskCollectionExt on CollectionReference {
  CollectionReference<Task> withTaskConverter() => withConverter<Task>(
        fromFirestore: (snap, _) =>
            Task.fromJson({...snap.data()! as Map<String, dynamic>, 'id': snap.id}),
        toFirestore: (task, _) {
          final map = task.toJson()..remove('id');
          return map;
        },
      );
}

// ── TaskRepository ────────────────────────────────────────────────────────────
class TaskRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Task> get _tasks =>
      _db.collection('tasks').withTaskConverter();

  /// Stream all tasks visible on the public board.
  Stream<List<Task>> watchPublicTasks({TaskCategory? category}) {
    Query<Task> query = _tasks
        .where('status', whereIn: [
          TaskStatus.published.name,
          TaskStatus.fundingOpen.name,
          TaskStatus.bidding.name,
        ])
        .orderBy('createdAt', descending: true);

    if (category != null) {
      query = query.where('category', isEqualTo: category.name);
    }

    return query.snapshots().map(
          (snap) => snap.docs.map((d) => d.data()).toList(),
        );
  }

  /// Stream a single task by ID.
  Stream<Task?> watchTask(String taskId) =>
      _tasks.doc(taskId).snapshots().map((s) => s.data());

  /// Create a new task document.
  Future<String> createTask(Task task) async {
    final ref = _tasks.doc();
    final now = DateTime.now();
    await ref.set(task.copyWith(id: ref.id, createdAt: now, updatedAt: now));
    return ref.id;
  }

  /// Update task fields.
  Future<void> updateTask(Task task) async {
    await _tasks.doc(task.id).set(
          task.copyWith(updatedAt: DateTime.now()),
          SetOptions(merge: true),
        );
  }
}
