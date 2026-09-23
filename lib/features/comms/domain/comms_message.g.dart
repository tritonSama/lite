// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comms_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommsMessage _$CommsMessageFromJson(Map<String, dynamic> json) =>
    _CommsMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      channel: $enumDecode(_$CommsChannelEnumMap, json['channel']),
      targetId: json['targetId'] as String?,
    );

Map<String, dynamic> _$CommsMessageToJson(_CommsMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'channel': _$CommsChannelEnumMap[instance.channel]!,
      'targetId': instance.targetId,
    };

const _$CommsChannelEnumMap = {
  CommsChannel.direct: 'direct',
  CommsChannel.team: 'team',
  CommsChannel.global: 'global',
};
