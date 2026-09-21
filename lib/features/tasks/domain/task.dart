import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/enums.dart';
import '../../../core/utils/firestore_converters.dart';

part 'task.freezed.dart';
part 'task.g.dart';

// ── RequiredCredential ────────────────────────────────────────────────────────
@freezed
abstract class RequiredCredential with _$RequiredCredential {
  const factory RequiredCredential({
    required CredentialType credentialType,
    @Default(false) bool isRequired,
  }) = _RequiredCredential;

  factory RequiredCredential.fromJson(Map<String, dynamic> json) =>
      _$RequiredCredentialFromJson(json);
}

// ── Task ──────────────────────────────────────────────────────────────────────
@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String creatorId,
    required String title,
    required String description,
    @Default([]) List<String> photoUrls,
    @GeoPointConverter() required GeoPoint location,
    required String locationLabel,
    required String geohash,
    @TimestampConverter() required DateTime desiredCompletionDate,
    required double budgetAmount,
    @Default('USD') String currencyCode,
    @Default([]) List<String> requiredSkills,
    @Default([]) List<String> requiredEquipment,
    @Default([]) List<RequiredCredential> requiredCredentials,
    @Default(1) int workerCount,
    String? specialRequirements,
    double? platformFee,
    @Default(TaskStatus.draft) TaskStatus status,
    String? selectedProviderId,
    @Default(0) int bidCount,
    @Default(TaskCategory.cleanup) TaskCategory category,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
