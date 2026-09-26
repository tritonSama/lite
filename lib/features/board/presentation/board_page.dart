import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Since we are mocking the Neural Network view before the Rust code compiles correctly,
// we will construct a beautiful Fluorescent Engine 3D fallback view using standard Flutter CustomPaint.
// When `fluorite_core` is compiled, it uses a Flutter Texture widget.

import '../../../app/theme.dart';
import '../../notifications/presentation/notifications_button.dart';
import 'board_search_delegate.dart';
import 'local_offerings_provider.dart';
import '../../teams/presentation/team_providers.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'edit_offering_dialog.dart';

class BoardPage extends ConsumerStatefulWidget {
  const BoardPage({super.key});

  @override
  ConsumerState<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends ConsumerState<BoardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.handshake_rounded, color: HBColors.primary),
            SizedBox(width: 8.0),
            Text('Game Maps IRL'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BoardSearchDelegate(ref: ref),
              );
            },
          ),
          const NotificationsButton(),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Main'),
            Tab(text: 'My Club'),
            Tab(text: 'Local'),
            Tab(text: 'Interacting'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create'),
        icon: const Icon(Icons.add_task),
        label: const Text('Post Task'),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          _MainOfferingsTab(),
          _MyClubOfferingsTab(),
          _LocalTab(), // Local radius selector mockup
          _InteractingTab(), // Negotiations & Bids view
        ],
      ),
    );
  }
}

class _MainOfferingsTab extends ConsumerWidget {
  const _MainOfferingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offeringsAsync = ref.watch(localOfferingsProvider);

    return offeringsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (offerings) {
        if (offerings.isEmpty) {
          return const Center(child: Text('No offerings found.'));
        }
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(localOfferingsProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: offerings.length,
            itemBuilder: (context, index) {
              return OfferingCard(offering: offerings[index]);
            },
          ),
        );
      },
    );
  }
}

class _MyClubOfferingsTab extends ConsumerWidget {
  const _MyClubOfferingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offeringsAsync = ref.watch(localOfferingsProvider);
    final selectedTeamId = ref.watch(selectedTeamProvider);

    return offeringsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (offerings) {
        final clubOfferings = offerings.where((o) => o['creatorId'] == selectedTeamId).toList();

        if (clubOfferings.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.group_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  selectedTeamId == null
                    ? 'Join a team in Teams page'
                    : 'No offerings for your club yet.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(localOfferingsProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: clubOfferings.length,
            itemBuilder: (context, index) {
              return OfferingCard(offering: clubOfferings[index]);
            },
          ),
        );
      },
    );
  }
}

class OfferingCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> offering;
  const OfferingCard({super.key, required this.offering});

  @override
  ConsumerState<OfferingCard> createState() => _OfferingCardState();
}

class _OfferingCardState extends ConsumerState<OfferingCard> {
  bool _expanded = false;

  void _editOffering() {
    showDialog(
      context: context,
      builder: (context) => EditOfferingDialog(offering: widget.offering),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTeamId = ref.watch(selectedTeamProvider);
    final dataStr = widget.offering['data'] as String;
    String title = "Unknown";
    String description = "No description";
    String category = "Unknown";
    String bounty = "0";

    try {
      final decoded = jsonDecode(dataStr) as Map<String, dynamic>;
      title = decoded['title']?.toString() ?? "Unknown";
      description = decoded['description']?.toString() ?? "No description";
      category = decoded['category']?.toString() ?? "Unknown";
      bounty = decoded['bounty']?.toString() ?? "0";
    } catch (e) {
      debugPrint('Parse error: $e');
    }

    final isCreator = widget.offering['creatorId'] == selectedTeamId;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Category: $category • Bounty: $bounty'),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(description),
                  const SizedBox(height: 16),
                  if (isCreator)
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        onPressed: _editOffering,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Interacting Tab (Bids & Negotiations) ────────────────────────────────────
class _InteractingTab extends StatelessWidget {
  const _InteractingTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.gavel, size: 72, color: HBColors.primary),
          const SizedBox(height: HBSpacing.md),
          Text('Offers & Contracts',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: HBSpacing.sm),
          Text('Negotiate and manage bids here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
        ],
      ),
    );
  }
}

// ── Local Tab (Radius Selection Mockup) ───────────────────────────────────────
class _LocalTab extends StatefulWidget {
  const _LocalTab();

  @override
  State<_LocalTab> createState() => _LocalTabState();
}

class _LocalTabState extends State<_LocalTab> {
  double _radius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Search Radius: ${_radius.toInt()} miles',
                   style: Theme.of(context).textTheme.titleMedium),
              Slider(
                value: _radius,
                min: 1.0,
                max: 100.0,
                divisions: 99,
                label: '${_radius.toInt()} mi',
                onChanged: (val) {
                  setState(() => _radius = val);
                },
              ),
            ],
          ),
        ),
        const Expanded(
          child: _PlaceholderTab(
            label: 'Local offerings will appear here',
            icon: Icons.location_on_outlined,
          ),
        ),
      ],
    );
  }
}

// ── Fluorescent Engine Nexus Network View ─────────────────────────────────────
class _NexusNetworkView extends StatefulWidget {
  const _NexusNetworkView();

  @override
  State<_NexusNetworkView> createState() => _NexusNetworkViewState();
}

class _NexusNetworkViewState extends State<_NexusNetworkView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Simulate engine loop for visual placeholder until FFI connects
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HBColors.neutral,
      child: Stack(
        children: [
          // Simulated 3D Neural Network Rendering
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _NeuralNetworkPainter(_controller.value),
                size: Size.infinite,
              );
            },
          ),

          // HUD UI Overlay
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: HBColors.primaryLight),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fluorescent Engine',
                    style: TextStyle(
                      color: HBColors.primaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Render: Vulkan Fallback',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    'Nodes Connected: 1,432',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    'TPS: 4,021',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: HBColors.tertiary,
              icon: const Icon(Icons.hub),
              label: const Text('Scan Local Nodes'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeuralNetworkPainter extends CustomPainter {
  final double animationValue;

  _NeuralNetworkPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = HBColors.primaryLight.withValues(alpha: 0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = HBColors.tertiary
      ..style = PaintingStyle.fill;

    // A static set of nodes for placeholder visual
    final nodes = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.4),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.7, size.height * 0.7),
      Offset(size.width * 0.5, size.height * 0.8),
    ];

    // Draw connecting lines (edges)
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        // Simple pulsing opacity based on animation
        paint.color = HBColors.primaryLight.withValues(
          alpha: (0.2 + (animationValue * 0.3)) % 0.8,
        );
        canvas.drawLine(nodes[i], nodes[j], paint);
      }
    }

    // Draw nodes
    for (final node in nodes) {
      canvas.drawCircle(node, 6.0, nodePaint);
      canvas.drawCircle(
        node,
        12.0,
        paint..color = HBColors.primaryLight.withValues(alpha: 0.3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ── Generic placeholder ───────────────────────────────────────────────────────
class _PlaceholderTab extends StatelessWidget {
  final String label;
  final IconData icon;
  const _PlaceholderTab({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16.0),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
