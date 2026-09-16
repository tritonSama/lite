import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../auth/presentation/auth_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(HBSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: HBSpacing.lg),
            CircleAvatar(
              radius: 48,
              backgroundColor: HBColors.primaryLight,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Text(
                      (user?.displayName?.isNotEmpty == true)
                          ? user!.displayName![0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(height: HBSpacing.md),
            Text(
              user?.displayName ?? 'Anonymous',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              user?.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: HBColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: HBSpacing.xl),

            // Menu items
            _ProfileTile(
              icon: Icons.verified_user_outlined,
              label: 'Credentials',
              onTap: () => Navigator.of(context).pushNamed('/profile/credentials'),
            ),
            _ProfileTile(
              icon: Icons.star_outline,
              label: 'Skills',
              onTap: () {},
            ),
            _ProfileTile(
              icon: Icons.history,
              label: 'Work History',
              onTap: () {},
            ),
            _ProfileTile(
              icon: Icons.attach_money,
              label: 'Earnings',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: HBSpacing.sm),
      child: ListTile(
        leading: Icon(icon, color: HBColors.primary),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
