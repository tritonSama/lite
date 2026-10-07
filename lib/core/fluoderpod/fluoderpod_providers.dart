import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/board/presentation/board_providers.dart';
import '../../features/tasks/domain/task.dart';
import 'entity_packet_encoder.dart';
import 'fluoderpod_bridge.dart';

/// Maps a [Task] to a GPU entity packet.
EntityPacket taskToPacket(Task t) {
  return EntityPacket(
    id: t.id,
    x: t.location.longitude,
    y: t.location.latitude,
    type: FluoderpodEntityType.task,
    status: t.status.index,
    bountyMicro: (t.budgetAmount * 1000000).round(),
  );
}

/// Streams all public tasks into the Fluoderpod bridge as packed binary
/// batches. Watching this provider is enough to keep the GPU scene in sync;
/// no widget rebuild is required for entity updates.
///
/// Declared as a plain [Provider] (no codegen) so a generator failure in a
/// model file can never block this cross-cutting path.
final fluoderpodEntityStreamProvider = Provider<int>((ref) {
  final bridge = ref.watch(fluoderpodBridgeProvider);
  final tasks = ref.watch(publicTasksProvider).value ?? const <Task>[];

  final packets = tasks.map(taskToPacket).toList(growable: false);
  bridge.ingestBatch(EntityPacketEncoder.encodeBatch(packets));
  return packets.length;
});
