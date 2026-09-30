import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/services/local_database_service.dart';
import '../domain/comms_message.dart';

part 'comms_providers.g.dart';

@riverpod
class CommsMessages extends _$CommsMessages {
  @override
  Future<List<CommsMessage>> build() async {
    return _fetchMessages();
  }

  Future<List<CommsMessage>> _fetchMessages() async {
    final dbService = LocalDatabaseService.instance;
    final db = await dbService.database;
    final results = await db.query('comms_messages', orderBy: 'timestamp ASC');

    if (results.isEmpty) {
      final now = DateTime.now();
      final initial = [
        CommsMessage(
          id: '1',
          senderId: 'system_dispatch',
          senderName: 'SYSTEM DISPATCH',
          content: 'Secure comms channel online. All frequencies encrypted.',
          timestamp: now,
          channel: CommsChannel.global,
        ),
      ];

      for (var m in initial) {
        await db.insert('comms_messages', {
          'id': m.id,
          'senderId': m.senderId,
          'senderName': m.senderName,
          'content': m.content,
          'channel': m.channel.name,
          'targetId': m.targetId,
          'timestamp': m.timestamp.millisecondsSinceEpoch,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      final seeded = await db.query('comms_messages', orderBy: 'timestamp ASC');
      return seeded.map(_mapRowToMessage).toList();
    }

    return results.map(_mapRowToMessage).toList();
  }

  CommsMessage _mapRowToMessage(Map<String, Object?> e) {
    return CommsMessage(
      id: e['id'] as String,
      senderId: e['senderId'] as String,
      senderName: e['senderName'] as String,
      content: e['content'] as String,
      channel: CommsChannel.values.firstWhere(
        (c) => c.name == e['channel'],
        orElse: () => CommsChannel.direct,
      ),
      targetId: e['targetId'] as String?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(e['timestamp'] as int),
    );
  }

  Future<void> sendMessage(String content, CommsChannel channel, {String? targetId}) async {
    final newMessage = CommsMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'Agent 47',
      content: content,
      timestamp: DateTime.now(),
      channel: channel,
      targetId: targetId,
    );

    final dbService = LocalDatabaseService.instance;
    final db = await dbService.database;

    await db.insert('comms_messages', {
      'id': newMessage.id,
      'senderId': newMessage.senderId,
      'senderName': newMessage.senderName,
      'content': newMessage.content,
      'channel': newMessage.channel.name,
      'targetId': newMessage.targetId,
      'timestamp': newMessage.timestamp.millisecondsSinceEpoch,
    });

    state = AsyncValue.data(await _fetchMessages());
  }
}

@riverpod
class SelectedCommsTarget extends _$SelectedCommsTarget {
  @override
  String? build() => null;

  void setTarget(String? targetId) {
    state = targetId;
  }
}

@riverpod
List<CommsMessage> filteredMessages(Ref ref, CommsChannel channel) {
  final allMessagesAsync = ref.watch(commsMessagesProvider);
  final allMessages = allMessagesAsync.whenOrNull(data: (d) => d) ?? [];
  final selectedTarget = ref.watch(selectedCommsTargetProvider);

  return allMessages.where((m) {
    if (m.channel != channel) return false;
    if (channel == CommsChannel.direct) {
      if (selectedTarget != null && m.targetId != selectedTarget && m.senderId != selectedTarget) {
        return false;
      }
    }
    return true;
  }).toList()
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
}
