import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../controllers/task_creation_controller.dart';

class CreateTaskStep4Funding extends ConsumerWidget {
  const CreateTaskStep4Funding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskCreationControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: taskState.budgetAmount > 0 ? taskState.budgetAmount.toString() : '',
          decoration: const InputDecoration(
            labelText: 'Bounty / Budget Amount',
            prefixText: '\$ ',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (val) {
            final budget = double.tryParse(val);
            if (budget != null) {
              ref.read(taskCreationControllerProvider.notifier).updateFunding(budgetAmount: budget);
            }
          },
        ),
      ],
    );
  }
}
