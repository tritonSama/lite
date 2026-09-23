import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../team_providers.dart';
import 'constellation_game.dart';

class ConstellationMapPage extends ConsumerWidget {
  const ConstellationMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guild Constellation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: HBColors.neutral,
      body: teamsAsync.when(
        data: (teams) {
          return GameWidget(
            game: ConstellationGame(
              teams: teams,
              onTeamTapped: (team) {
                // Navigate to team details
                context.push('/teams/${team.id}');
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
