import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../controllers/task_creation_controller.dart';

class CreateTaskStep3Requirements extends ConsumerWidget {
  const CreateTaskStep3Requirements({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskCreationControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: taskState.requiredSkills.join(', '),
          decoration: const InputDecoration(
            labelText: 'Required Skills (comma separated)',
            hintText: 'e.g. Carpentry, Plumbing',
          ),
          onChanged: (val) {
            final skills = val.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
            ref.read(taskCreationControllerProvider.notifier).updateRequirements(requiredSkills: skills);
          },
        ),
        const SizedBox(height: HBSpacing.md),
        TextFormField(
          initialValue: taskState.requiredEquipment.join(', '),
          decoration: const InputDecoration(
            labelText: 'Required Equipment (comma separated)',
            hintText: 'e.g. Ladder, Drill',
          ),
          onChanged: (val) {
            final equip = val.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
            ref.read(taskCreationControllerProvider.notifier).updateRequirements(requiredEquipment: equip);
          },
        ),
      ],
    );
  }
}
