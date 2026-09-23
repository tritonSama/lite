import 'package:freezed_annotation/freezed_annotation.dart';

part 'comms_message.freezed.dart';
part 'comms_message.g.dart';

enum CommsChannel { direct, team, global }

@freezed
abstract class CommsMessage with _$CommsMessage {
  const factory CommsMessage({
    required String id,
    required String senderId,
    required String senderName,
    required String content,
    required DateTime timestamp,
    required CommsChannel channel,
    String? targetId, // User ID for direct, Team ID for team
  }) = _CommsMessage;

  factory CommsMessage.fromJson(Map<String, dynamic> json) => _$CommsMessageFromJson(json);
}
