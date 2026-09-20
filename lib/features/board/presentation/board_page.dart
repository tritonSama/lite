import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/constants/enums.dart';
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
        title: Row(
          children: [
            const Icon(Icons.handshake_rounded, color: HBColors.primary),
            const SizedBox(width: HBSpacing.sm),
            const Text('HeavenlyBond'),
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
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              /* TODO: notifications */
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Tasks'),
            Tab(text: 'Projects'),
            Tab(text: 'Nearby'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          _TasksTab(),
          _PlaceholderTab(
            label: 'Projects coming soon',
            icon: Icons.folder_outlined,
          ),
          _PlaceholderTab(
            label: 'Nearby map coming soon',
            icon: Icons.map_outlined,
          ),
          _CategoriesTab(),
        ],
      ),
    );
  }
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
          padding: const EdgeInsets.all(HBSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: HBColors.error),
              const SizedBox(height: HBSpacing.md),
              Text(
                'Failed to load tasks',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: HBSpacing.sm),
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
                const Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: HBColors.onSurfaceVariant,
                ),
                const SizedBox(height: HBSpacing.md),
                Text(
                  'No tasks yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: HBSpacing.sm),
                Text(
                  'Be the first to post a task!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: HBColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(publicTasksProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(HBSpacing.md),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: HBSpacing.md),
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
    final categories = TaskCategory.values;
    return GridView.builder(
      padding: const EdgeInsets.all(HBSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: HBSpacing.md,
        mainAxisSpacing: HBSpacing.md,
        childAspectRatio: 1.4,
      ),
      itemCount: categories.length,
      itemBuilder: (ctx, i) {
        final cat = categories[i];
        return Card(
          child: InkWell(
            onTap: () => ctx.go('/board/category/${cat.name}'),
            onTap: () {
              /* TODO: filter by category */
            },
            borderRadius: BorderRadius.circular(HBRadius.md),
            child: Padding(
              padding: const EdgeInsets.all(HBSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: HBSpacing.sm),
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
          Icon(icon, size: 64, color: HBColors.onSurfaceVariant),
          const SizedBox(height: HBSpacing.md),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: HBColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
