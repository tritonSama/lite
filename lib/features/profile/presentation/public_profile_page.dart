import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../app/theme.dart';
import '../../../shared/models/user_profile.dart';

final publicProfileProvider = FutureProvider.family<UserProfile?, String>((
  ref,
  userId,
) async {
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();
  if (!doc.exists || doc.data() == null) return null;
  return UserProfile.fromJson(doc.data()!);
});

class PublicProfilePage extends ConsumerWidget {
  final String userId;

  const PublicProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicProfileProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Error loading profile: $e',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: HBColors.error),
          ),
        ),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(HBSpacing.md),
            child: Column(
              children: [
                const SizedBox(height: HBSpacing.lg),
                CircleAvatar(
                  radius: 48,
                  backgroundColor: HBColors.primaryLight,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Text(
                          (user.displayName.isNotEmpty)
                              ? user.displayName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: HBSpacing.md),
                Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: HBSpacing.sm),
                  Text(
                    user.bio!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: HBSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatColumn(
                      label: 'Rating',
                      value: user.rating.toStringAsFixed(1),
                    ),
                    _StatColumn(
                      label: 'Completed',
                      value: user.completedJobCount.toString(),
                    ),
                    _StatColumn(
                      label: 'Active',
                      value: user.activeJobCount.toString(),
                    ),
                  ],
                ),
                if (user.skills.isNotEmpty) ...[
                  const SizedBox(height: HBSpacing.xl),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Skills',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: HBSpacing.sm),
                  Wrap(
                    spacing: HBSpacing.sm,
                    runSpacing: HBSpacing.sm,
                    children: user.skills
                        .map((skill) => Chip(label: Text(skill)))
                        .toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
