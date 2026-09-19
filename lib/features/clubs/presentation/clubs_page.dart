import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';

class ClubsPage extends ConsumerWidget {
  const ClubsPage({super.key});

  void _showCreateClubModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: HBSpacing.md,
          right: HBSpacing.md,
          top: HBSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create a Car Club', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: HBSpacing.md),
            const TextField(
              decoration: InputDecoration(labelText: 'Club Name'),
            ),
            const SizedBox(height: HBSpacing.md),
            const TextField(
              decoration: InputDecoration(labelText: 'Description (Optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: HBSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Car Club created!')),
                  );
                },
                child: const Text('Create'),
              ),
            ),
            const SizedBox(height: HBSpacing.lg),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Clubs')),
      body: ListView(
        padding: const EdgeInsets.all(HBSpacing.md),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.group)),
              title: const Text('Midnight Runners'),
              subtitle: const Text('12 Members • Owner'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to club detail
              },
            ),
          ),
          const SizedBox(height: HBSpacing.md),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.group)),
              title: const Text('Weekend Classics'),
              subtitle: const Text('45 Members • Member'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to club detail
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateClubModal(context),
        icon: const Icon(Icons.add),
        label: const Text('Create Club'),
      ),
    );
  }
}
