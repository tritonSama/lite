import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'dart:typed_data';
import '../../../../core/fluoderpod/fluoderpod_bridge.dart';
import '../../../../core/fluoderpod/fluoderpod_view.dart';
import '../../../../app/theme.dart';
import '../team_providers.dart';

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
          return FluoderpodView(
            onInitialized: () {
              final bridge = ref.read(fluoderpodBridgeProvider);
              final bytes = Uint8List(teams.length * 64);
              bridge.ingestBatch(bytes);
            },
            onEntityTapped: (id) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped entity: $id')),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
