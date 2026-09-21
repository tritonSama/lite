import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Maps IRL')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sports_esports, size: 72, color: HBColors.primary),
            const SizedBox(height: HBSpacing.md),
            Text('Game', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: HBSpacing.sm),
            Text('Coming Soon',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ],
        ),
      ),
    );
  }
}
