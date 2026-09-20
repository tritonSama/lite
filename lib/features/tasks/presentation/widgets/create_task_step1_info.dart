import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../controllers/task_creation_controller.dart';
import '../../../../core/constants/enums.dart';

class CreateTaskStep1Info extends ConsumerWidget {
  const CreateTaskStep1Info({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskCreationControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: taskState.title,
          decoration: const InputDecoration(labelText: 'Task Title'),
          onChanged: (val) => ref
              .read(taskCreationControllerProvider.notifier)
              .updateInfo(title: val),
        ),
        const SizedBox(height: HBSpacing.md),
        TextFormField(
          initialValue: taskState.description,
          decoration: const InputDecoration(labelText: 'Description'),
          maxLines: 3,
          onChanged: (val) => ref
              .read(taskCreationControllerProvider.notifier)
              .updateInfo(description: val),
        ),
        const SizedBox(height: HBSpacing.md),
        DropdownButtonFormField<TaskCategory>(
          value: taskState.category, // using value as DropdownButtonFormField doesn't use initialValue well
          decoration: const InputDecoration(labelText: 'Category'),
          items: TaskCategory.values
              .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text('${cat.emoji} ${cat.label}'),
                  ))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(taskCreationControllerProvider.notifier)
                  .updateInfo(category: val);
            }
          },
        ),
      ],
    );
  }
}
