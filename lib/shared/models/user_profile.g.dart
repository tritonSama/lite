// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  uid: json['uid'] as String,
  displayName: json['displayName'] as String,
  photoUrl: json['photoUrl'] as String?,
  bio: json['bio'] as String?,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  completedJobCount: (json['completedJobCount'] as num?)?.toInt() ?? 0,
  activeJobCount: (json['activeJobCount'] as num?)?.toInt() ?? 0,
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  fcmToken: json['fcmToken'] as String?,
  stripeAccountId: json['stripeAccountId'] as String?,
  lastKnownLocation: _$JsonConverterFromJson<Map<String, dynamic>, GeoPoint>(
    json['lastKnownLocation'],
    const GeoPointConverter().fromJson,
  ),
  geohash: json['geohash'] as String?,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$UserProfileToJson(
  _UserProfile instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'displayName': instance.displayName,
  'photoUrl': instance.photoUrl,
  'bio': instance.bio,
  'rating': instance.rating,
  'completedJobCount': instance.completedJobCount,
  'activeJobCount': instance.activeJobCount,
  'skills': instance.skills,
  'fcmToken': instance.fcmToken,
  'stripeAccountId': instance.stripeAccountId,
  'lastKnownLocation': _$JsonConverterToJson<Map<String, dynamic>, GeoPoint>(
    instance.lastKnownLocation,
    const GeoPointConverter().toJson,
  ),
  'geohash': instance.geohash,
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
