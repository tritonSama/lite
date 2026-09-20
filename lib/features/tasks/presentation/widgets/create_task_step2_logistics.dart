import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../controllers/task_creation_controller.dart';

class CreateTaskStep2Logistics extends ConsumerWidget {
  const CreateTaskStep2Logistics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskCreationControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Placeholder for map picker integration
        TextFormField(
          initialValue: taskState.locationLabel,
          decoration: const InputDecoration(labelText: 'Location Label (e.g. 123 Main St)'),
          onChanged: (val) => ref
              .read(taskCreationControllerProvider.notifier)
              .updateLogistics(locationLabel: val),
        ),
        const SizedBox(height: HBSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: taskState.workerCount.toString(),
                decoration: const InputDecoration(labelText: 'Number of Workers'),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  final count = int.tryParse(val);
                  if (count != null) {
                    ref
                        .read(taskCreationControllerProvider.notifier)
                        .updateLogistics(workerCount: count);
                  }
                },
              ),
            ),
          ],
        ),
        // Add date picker placeholder here if desired
      ],
    );
  }
}
