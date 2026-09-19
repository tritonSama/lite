import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/enums.dart';
import '../../../core/utils/firestore_converters.dart';

part 'club.freezed.dart';
part 'club.g.dart';

// ── Club ──────────────────────────────────────────────────────────────────────
@freezed
abstract class Club with _$Club {
  const factory Club({
    required String id,
    required String name,
    String? description,
    required String ownerId,
    @Default(0) int memberCount,
    @Default([]) List<String> credentialIds,
    @Default(0.0) double rating,
    @Default(0) int completedJobCount,
    @TimestampConverter() required DateTime createdAt,
  }) = _Club;

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);
}

// ── Membership — root /memberships/{id} junction collection ──────────────────
@freezed
abstract class Membership with _$Membership {
  const factory Membership({
    required String id,
    required String clubId,
    required String userId,
    String? userDisplayName,
    String? userPhotoUrl,
    @Default(MemberRole.member) MemberRole role,
    @Default(MemberStatus.invited) MemberStatus status,
    @TimestampConverter() required DateTime joinedAt,
  }) = _Membership;

  factory Membership.fromJson(Map<String, dynamic> json) =>
      _$MembershipFromJson(json);
}
