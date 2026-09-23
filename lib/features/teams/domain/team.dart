import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/enums.dart';
import '../../../core/utils/firestore_converters.dart';

part 'team.freezed.dart';
part 'team.g.dart';

// ── Team ──────────────────────────────────────────────────────────────────────
@freezed
abstract class Team with _$Team {
  const factory Team({
    required String id,
    required String name,
    String? description,
    required String ownerId,
    @Default(0) int memberCount,
    @Default([]) List<String> credentialIds,
    @Default([]) List<String> parentIds, // Organizations this team branched from (Guilds)
    @Default([]) List<String> sisterClubIds, // Sister clubs (Guilds)
    @Default([]) List<String> treatyIds, // Treaties with other teams
    @Default(0.0) double rating,
    @Default(0) int completedJobCount,
    @TimestampConverter() required DateTime createdAt,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}

// ── Membership — root /memberships/{id} junction collection ──────────────────
@freezed
abstract class Membership with _$Membership {
  const factory Membership({
    required String id,
    required String teamId,
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
