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
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
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
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
