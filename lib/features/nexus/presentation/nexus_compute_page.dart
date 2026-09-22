import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'nexus_providers.dart';
import '../data/nexus_waitlist_repository.dart';
import '../../../app/theme.dart';

class NexusComputePage extends ConsumerStatefulWidget {
  const NexusComputePage({super.key});

  @override
  ConsumerState<NexusComputePage> createState() => _NexusComputePageState();
}

class _NexusComputePageState extends ConsumerState<NexusComputePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitWaitlist() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(nexusWaitlistControllerProvider.notifier)
          .joinWaitlist(
            _nameController.text.trim(),
            _emailController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWaitlistedAsync = ref.watch(isUserOnWaitlistProvider);
    final waitlistState = ref.watch(nexusWaitlistControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nexus Protocol'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image/Icon
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HBColors.warning.withValues(alpha: 0.1),
                  border: Border.all(color: HBColors.warning, width: 2),
                ),
                child: const Icon(
                  Icons.hub_outlined,
                  size: 50,
                  color: HBColors.warning,
                ),
              ),
            ),
            const Gap(32),

            // Vision
            Text(
              'The Future of Edge Compute',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: HBColors.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(16),
            Text(
              'HeavenlyBond is evolving into the Nexus Ecosystem. The Nexus Protocol is an edge-native compute substrate and decentralized marketplace for idle hardware, powered by a Proof of Health consensus engine.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Gap(32),

            // Features
            _buildFeatureRow(
              context,
              icon: Icons.memory,
              title: 'Distributed AI Workloads',
              description:
                  'Monetize idle hardware by executing LLM inference and distributed matrix math.',
            ),
            const Gap(24),
            _buildFeatureRow(
              context,
              icon: Icons.shield_outlined,
              title: 'Mobile Sovereign Vaults',
              description:
                  'Leverage hardware Secure Enclaves to hold sensitive user context and Decentralized Identifiers locally.',
            ),
            const Gap(24),
            _buildFeatureRow(
              context,
              icon: Icons.health_and_safety_outlined,
              title: 'Proof of Health (PoH)',
              description:
                  'Lightweight background telemetry gathers signed hardware state for dynamic cluster orchestration.',
            ),
            const Gap(48),

            // Waitlist Section
            isWaitlistedAsync.when(
              data: (isOnWaitlist) {
                if (isOnWaitlist) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: HBColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: HBColors.warning),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: HBColors.warning,
                          size: 32,
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You are on the waitlist!',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: HBColors.warning),
                              ),
                              const Gap(8),
                              Text(
                                'We will notify you when Phase 1 (Genesis) edge node telemetry and Sovereign Vaults become available.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Join Early Access',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const Gap(16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          if (!value.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),
                      const Gap(24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          onPressed: waitlistState.isLoading
                              ? null
                              : _submitWaitlist,
                          child: waitlistState.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Join the Nexus Waitlist'),
                        ),
                      ),
                      if (waitlistState.hasError) ...[
                        const Gap(16),
                        Text(
                          waitlistState.error.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading waitlist status: $err'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: HBColors.primary, size: 28),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(4),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
