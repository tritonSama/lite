// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nexus_waitlist_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NexusWaitlistEntry _$NexusWaitlistEntryFromJson(Map<String, dynamic> json) =>
    _NexusWaitlistEntry(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      joinedAt: const TimestampConverter().fromJson(
        json['joinedAt'] as Timestamp?,
      ),
    );

Map<String, dynamic> _$NexusWaitlistEntryToJson(_NexusWaitlistEntry instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
    };
