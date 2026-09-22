import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Since we are mocking the Neural Network view before the Rust code compiles correctly,
// we will construct a beautiful Fluorescent Engine 3D fallback view using standard Flutter CustomPaint.
// When `fluorite_core` is compiled, it uses a Flutter Texture widget.

import '../../../app/theme.dart';
import '../../../core/constants/enums.dart';
import '../../notifications/presentation/notifications_button.dart';
import '../../tasks/presentation/task_card.dart';
import 'board_providers.dart';
import 'board_search_delegate.dart';

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
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          _TasksTab(), // Main view with all tasks
          _PlaceholderTab(
            label: 'Club/Team specific items coming soon',
            icon: Icons.group_work_outlined,
          ),
          _LocalTab(), // Local radius selector mockup
          _InteractingTab(), // Negotiations & Bids view
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

// ── Tasks tab ─────────────────────────────────────────────────────────────────
class _TasksTab extends ConsumerWidget {
  const _TasksTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(publicTasksProvider);

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16.0),
              Text(
                'Failed to load tasks',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8.0),
              Text(e.toString(), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
      data: (tasks) {
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16.0),
                Text(
                  'No tasks yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Be the first to post a task!',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(publicTasksProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16.0),
            itemBuilder: (ctx, i) => TaskCard(
              task: tasks[i],
              onTap: () => ctx.push('/board/task/${tasks[i].id}'),
            ),
          ),
        );
      },
    );
  }
}

// ── Categories tab ────────────────────────────────────────────────────────────
class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab();

  @override
  Widget build(BuildContext context) {
    const categories = TaskCategory.values;
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.4,
      ),
      itemCount: categories.length,
      itemBuilder: (ctx, i) {
        final cat = categories[i];
        return Card(
          child: InkWell(
            onTap: () => ctx.go('/board/category/${cat.name}'),
            borderRadius: BorderRadius.circular(HBRadius.md),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 8.0),
                  Text(
                    cat.label,
                    style: Theme.of(ctx).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
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
