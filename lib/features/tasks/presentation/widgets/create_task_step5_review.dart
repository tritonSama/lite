import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../controllers/task_creation_controller.dart';

class CreateTaskStep5Review extends ConsumerWidget {
  const CreateTaskStep5Review({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskCreationControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Review your Task', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: HBSpacing.md),
        Text('Title: ${taskState.title}'),
        Text('Budget: \$${taskState.budgetAmount.toStringAsFixed(2)}'),
        Text('Location: ${taskState.locationLabel}'),
        const SizedBox(height: HBSpacing.lg),
        ElevatedButton(
          onPressed: () {
            // TODO: Submit to Firestore using repository pattern
            // Transition state to TaskStatus.published
            context.go('/board');
          },
          child: const Text('Publish Task'),
        ),
      ],
    );
  }
}
