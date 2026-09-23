import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/comms_message.dart';

part 'comms_providers.g.dart';

// Mock data generator for initial state
List<CommsMessage> _generateMockMessages() {
  final now = DateTime.now();
  return [
    CommsMessage(
      id: '1',
      senderId: 'user_1',
      senderName: 'Alice',
      content: 'System sync complete. Awaiting orders.',
      timestamp: now.subtract(const Duration(minutes: 5)),
      channel: CommsChannel.direct,
      targetId: 'me',
    ),
    CommsMessage(
      id: '2',
      senderId: 'user_2',
      senderName: 'Bob',
      content: 'Alpha team, converge on sector 7G.',
      timestamp: now.subtract(const Duration(minutes: 10)),
      channel: CommsChannel.team,
      targetId: 'team_alpha',
    ),
    CommsMessage(
      id: '3',
      senderId: 'system',
      senderName: 'NEXUS OVERSEER',
      content: 'GLOBAL ALERT: Node offline in sector 4.',
      timestamp: now.subtract(const Duration(hours: 1)),
      channel: CommsChannel.global,
    ),
  ];
}

@riverpod
class CommsMessages extends _$CommsMessages {
  @override
  List<CommsMessage> build() {
    return _generateMockMessages();
  }

  void sendMessage(String content, CommsChannel channel, {String? targetId}) {
    final newMessage = CommsMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me', // Current user mock
      senderName: 'Agent 47',
      content: content,
      timestamp: DateTime.now(),
      channel: channel,
      targetId: targetId,
    );
    state = [...state, newMessage];
  }
}

@riverpod
List<CommsMessage> filteredMessages(Ref ref, CommsChannel channel) {
  final allMessages = ref.watch(commsMessagesProvider);
  return allMessages.where((m) => m.channel == channel).toList()
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
}
