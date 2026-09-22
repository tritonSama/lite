import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/theme.dart';
import '../../tasks/data/task_repository.dart';
import '../domain/task.dart';

part 'task_detail_page.g.dart';

@riverpod
Stream<Task?> taskDetail(Ref ref, String taskId) =>
    ref.watch(taskRepositoryProvider).watchTask(taskId);

class TaskDetailPage extends ConsumerWidget {
  final String taskId;
  const TaskDetailPage({required this.taskId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (task) {
          if (task == null) {
            return const Center(child: Text('Task not found.'));
          }
          return _TaskDetailBody(task: task);
        },
      ),
    );
  }
}

class _TaskDetailBody extends StatelessWidget {
  final Task task;
  const _TaskDetailBody({required this.task});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(HBSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bounty hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(HBSpacing.lg),
            decoration: BoxDecoration(
              color: HBColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(HBRadius.lg),
              border: Border.all(color: HBColors.warning.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text('Bounty', style: tt.bodySmall),
                Text(
                  '\$${task.budgetAmount.toStringAsFixed(0)}',
                  style: tt.displayMedium?.copyWith(color: HBColors.warning),
                ),
              ],
            ),
          ),
          const SizedBox(height: HBSpacing.lg),

          Text(task.title, style: tt.headlineLarge),
          const SizedBox(height: HBSpacing.sm),
          Text(task.description, style: tt.bodyLarge),
          const SizedBox(height: HBSpacing.lg),

          // Meta info
          _MetaRow(icon: Icons.location_on_outlined, text: task.locationLabel),
          _MetaRow(icon: Icons.calendar_today_outlined,
              text: 'Due ${task.desiredCompletionDate.toLocal().toString().split(' ').first}'),
          _MetaRow(icon: Icons.group_outlined,
              text: '${task.workerCount} worker${task.workerCount != 1 ? "s" : ""} needed'),
          if (task.requiredSkills.isNotEmpty) ...[
            const SizedBox(height: HBSpacing.md),
            Text('Required Skills', style: tt.titleMedium),
            const SizedBox(height: HBSpacing.sm),
            Wrap(
              spacing: HBSpacing.sm,
              children: task.requiredSkills
                  .map((s) => Chip(label: Text(s)))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: HBSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: HBSpacing.sm),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
