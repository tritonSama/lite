import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comms & Tools')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.build_circle_outlined, size: 72, color: HBColors.primary),
            const SizedBox(height: HBSpacing.md),
            Text('Tools', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: HBSpacing.sm),
            Text('Walkie Talkie & GPS coming soon',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ],
        ),
      ),
    );
  }
}
