import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../tasks/domain/task.dart';
import '../../tasks/presentation/task_card.dart';
import 'board_providers.dart';

class TaskSearchDelegate extends SearchDelegate<Task?> {
  TaskSearchDelegate() : super(searchFieldLabel: 'Search tasks...');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final tasksAsync = ref.watch(publicTasksProvider);

        return tasksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(HBSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: HBColors.error,
                  ),
                  const SizedBox(height: HBSpacing.md),
                  Text(
                    'Failed to load tasks',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: HBSpacing.sm),
                  Text(
                    e.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          data: (tasks) {
            final lowerQuery = query.toLowerCase();
            final filteredTasks = tasks.where((task) {
              final titleMatch = task.title.toLowerCase().contains(lowerQuery);
              final descMatch = task.description.toLowerCase().contains(
                lowerQuery,
              );
              return titleMatch || descMatch;
            }).toList();

            if (filteredTasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 64,
                      color: HBColors.onSurfaceVariant,
                    ),
                    const SizedBox(height: HBSpacing.md),
                    Text(
                      'No results found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (query.isNotEmpty) ...[
                      const SizedBox(height: HBSpacing.sm),
                      Text(
                        'Try a different search term',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: HBColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(HBSpacing.md),
              itemCount: filteredTasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: HBSpacing.md),
              itemBuilder: (ctx, i) => TaskCard(
                task: filteredTasks[i],
                onTap: () {
                  close(context, filteredTasks[i]);
                },
              ),
            );
          },
        );
      },
    );
  }
}
