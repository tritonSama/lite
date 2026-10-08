// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Team _$TeamFromJson(Map<String, dynamic> json) => _Team(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  ownerId: json['ownerId'] as String,
  memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
  credentialIds:
      (json['credentialIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  parentIds:
      (json['parentIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  sisterClubIds:
      (json['sisterClubIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  treatyIds:
      (json['treatyIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  completedJobCount: (json['completedJobCount'] as num?)?.toInt() ?? 0,
  hubLocation: _$JsonConverterFromJson<Map<String, dynamic>, GeoPoint>(
    json['hubLocation'],
    const GeoPointConverter().fromJson,
  ),
  hubGeohash: json['hubGeohash'] as String?,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$TeamToJson(_Team instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'ownerId': instance.ownerId,
  'memberCount': instance.memberCount,
  'credentialIds': instance.credentialIds,
  'parentIds': instance.parentIds,
  'sisterClubIds': instance.sisterClubIds,
  'treatyIds': instance.treatyIds,
  'rating': instance.rating,
  'completedJobCount': instance.completedJobCount,
  'hubLocation': _$JsonConverterToJson<Map<String, dynamic>, GeoPoint>(
    instance.hubLocation,
    const GeoPointConverter().toJson,
  ),
  'hubGeohash': instance.hubGeohash,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_Membership _$MembershipFromJson(Map<String, dynamic> json) => _Membership(
  id: json['id'] as String,
  teamId: json['teamId'] as String,
  userId: json['userId'] as String,
  userDisplayName: json['userDisplayName'] as String?,
  userPhotoUrl: json['userPhotoUrl'] as String?,
  role:
      $enumDecodeNullable(_$MemberRoleEnumMap, json['role']) ??
      MemberRole.member,
  status:
      $enumDecodeNullable(_$MemberStatusEnumMap, json['status']) ??
      MemberStatus.invited,
  joinedAt: const TimestampConverter().fromJson(json['joinedAt'] as Timestamp),
);

Map<String, dynamic> _$MembershipToJson(_Membership instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'userId': instance.userId,
      'userDisplayName': instance.userDisplayName,
      'userPhotoUrl': instance.userPhotoUrl,
      'role': _$MemberRoleEnumMap[instance.role]!,
      'status': _$MemberStatusEnumMap[instance.status]!,
      'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
    };

const _$MemberRoleEnumMap = {
  MemberRole.owner: 'owner',
  MemberRole.admin: 'admin',
  MemberRole.member: 'member',
  MemberRole.viewer: 'viewer',
};

const _$MemberStatusEnumMap = {
  MemberStatus.active: 'active',
  MemberStatus.invited: 'invited',
  MemberStatus.suspended: 'suspended',
};
