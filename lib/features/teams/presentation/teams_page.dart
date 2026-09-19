import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Teams')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.group, size: 72, color: HBColors.primary),
              const SizedBox(height: HBSpacing.md),
              Text('Teams', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: HBSpacing.sm),
              Text('Coming in Sprint 8',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: HBColors.onSurfaceVariant)),
            ],
          ),
        ),
      );
}
