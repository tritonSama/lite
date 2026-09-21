import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Placeholder — full Create Task wizard is Sprint 2.
class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_task, size: 72, color: HBColors.primary),
            const SizedBox(height: HBSpacing.md),
            Text('Task Wizard',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: HBSpacing.sm),
            Text('Coming in Sprint 2',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ],
        ),
      ),
    );
  }
}
