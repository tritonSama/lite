import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class BidsPage extends StatelessWidget {
  const BidsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Bids')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.gavel, size: 72, color: HBColors.primary),
              const SizedBox(height: HBSpacing.md),
              Text('Offers & Contracts',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: HBSpacing.sm),
              Text('Coming in Sprint 4',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      );
}
