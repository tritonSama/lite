import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class CredentialsPage extends StatelessWidget {
  const CredentialsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Credentials')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 72,
            color: HBColors.primary,
          ),
          const SizedBox(height: HBSpacing.md),
          Text(
            'Credentials & Licenses',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: HBSpacing.sm),
          Text(
            'Coming in Sprint 6',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}
