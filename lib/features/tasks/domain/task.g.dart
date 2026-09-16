// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequiredCredential _$RequiredCredentialFromJson(Map<String, dynamic> json) =>
    _RequiredCredential(
      credentialType: $enumDecode(
        _$CredentialTypeEnumMap,
        json['credentialType'],
      ),
      isRequired: json['isRequired'] as bool? ?? false,
    );

Map<String, dynamic> _$RequiredCredentialToJson(_RequiredCredential instance) =>
    <String, dynamic>{
      'credentialType': _$CredentialTypeEnumMap[instance.credentialType]!,
      'isRequired': instance.isRequired,
    };

const _$CredentialTypeEnumMap = {
  CredentialType.driversLicense: 'driversLicense',
  CredentialType.cdl: 'cdl',
  CredentialType.electricalLicense: 'electricalLicense',
  CredentialType.contractorLicense: 'contractorLicense',
  CredentialType.insurance: 'insurance',
  CredentialType.foodHandler: 'foodHandler',
  CredentialType.backgroundCheck: 'backgroundCheck',
  CredentialType.other: 'other',
};

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  creatorId: json['creatorId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  photoUrls:
      (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  location: const GeoPointConverter().fromJson(
    json['location'] as Map<String, dynamic>,
  ),
  locationLabel: json['locationLabel'] as String,
  geohash: json['geohash'] as String,
  desiredCompletionDate: const TimestampConverter().fromJson(
    json['desiredCompletionDate'] as Timestamp,
  ),
  budgetAmount: (json['budgetAmount'] as num).toDouble(),
  currencyCode: json['currencyCode'] as String? ?? 'USD',
  requiredSkills:
      (json['requiredSkills'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  requiredEquipment:
      (json['requiredEquipment'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  requiredCredentials:
      (json['requiredCredentials'] as List<dynamic>?)
          ?.map((e) => RequiredCredential.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  workerCount: (json['workerCount'] as num?)?.toInt() ?? 1,
  specialRequirements: json['specialRequirements'] as String?,
  status:
      $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
      TaskStatus.draft,
  selectedProviderId: json['selectedProviderId'] as String?,
  bidCount: (json['bidCount'] as num?)?.toInt() ?? 0,
  category:
      $enumDecodeNullable(_$TaskCategoryEnumMap, json['category']) ??
      TaskCategory.cleanup,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'creatorId': instance.creatorId,
  'title': instance.title,
  'description': instance.description,
  'photoUrls': instance.photoUrls,
  'location': const GeoPointConverter().toJson(instance.location),
  'locationLabel': instance.locationLabel,
  'geohash': instance.geohash,
  'desiredCompletionDate': const TimestampConverter().toJson(
    instance.desiredCompletionDate,
  ),
  'budgetAmount': instance.budgetAmount,
  'currencyCode': instance.currencyCode,
  'requiredSkills': instance.requiredSkills,
  'requiredEquipment': instance.requiredEquipment,
  'requiredCredentials': instance.requiredCredentials,
  'workerCount': instance.workerCount,
  'specialRequirements': instance.specialRequirements,
  'status': _$TaskStatusEnumMap[instance.status]!,
  'selectedProviderId': instance.selectedProviderId,
  'bidCount': instance.bidCount,
  'category': _$TaskCategoryEnumMap[instance.category]!,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};

const _$TaskStatusEnumMap = {
  TaskStatus.draft: 'draft',
  TaskStatus.published: 'published',
  TaskStatus.fundingOpen: 'fundingOpen',
  TaskStatus.bidding: 'bidding',
  TaskStatus.providerSelected: 'providerSelected',
  TaskStatus.teamForming: 'teamForming',
  TaskStatus.scheduled: 'scheduled',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.submittedForVerification: 'submittedForVerification',
  TaskStatus.approved: 'approved',
  TaskStatus.paymentReleased: 'paymentReleased',
  TaskStatus.completed: 'completed',
  TaskStatus.cancelled: 'cancelled',
  TaskStatus.disputed: 'disputed',
  TaskStatus.expired: 'expired',
};

const _$TaskCategoryEnumMap = {
  TaskCategory.cleanup: 'cleanup',
  TaskCategory.moving: 'moving',
  TaskCategory.delivery: 'delivery',
  TaskCategory.event: 'event',
  TaskCategory.repair: 'repair',
  TaskCategory.landscaping: 'landscaping',
  TaskCategory.other: 'other',
};
