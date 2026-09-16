import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/firestore_converters.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String displayName,
    String? photoUrl,
    String? bio,
    @Default(0.0) double rating,
    @Default(0) int completedJobCount,
    @Default(0) int activeJobCount,
    @Default([]) List<String> skills,
    String? fcmToken,
    String? stripeAccountId,
    @TimestampConverter() required DateTime createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
