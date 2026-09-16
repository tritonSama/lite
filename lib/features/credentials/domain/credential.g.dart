// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Credential _$CredentialFromJson(Map<String, dynamic> json) => _Credential(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  credentialType: $enumDecode(_$CredentialTypeEnumMap, json['credentialType']),
  label: json['label'] as String,
  storagePath: json['storagePath'] as String,
  downloadUrl: json['downloadUrl'] as String?,
  status:
      $enumDecodeNullable(_$CredentialStatusEnumMap, json['status']) ??
      CredentialStatus.uploaded,
  expiresAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['expiresAt'],
    const TimestampConverter().fromJson,
  ),
  uploadedAt: const TimestampConverter().fromJson(
    json['uploadedAt'] as Timestamp,
  ),
  verifiedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['verifiedAt'],
    const TimestampConverter().fromJson,
  ),
  verifiedBy: json['verifiedBy'] as String?,
  mimeType: json['mimeType'] as String,
  fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CredentialToJson(_Credential instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'credentialType': _$CredentialTypeEnumMap[instance.credentialType]!,
      'label': instance.label,
      'storagePath': instance.storagePath,
      'downloadUrl': instance.downloadUrl,
      'status': _$CredentialStatusEnumMap[instance.status]!,
      'expiresAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.expiresAt,
        const TimestampConverter().toJson,
      ),
      'uploadedAt': const TimestampConverter().toJson(instance.uploadedAt),
      'verifiedAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.verifiedAt,
        const TimestampConverter().toJson,
      ),
      'verifiedBy': instance.verifiedBy,
      'mimeType': instance.mimeType,
      'fileSizeBytes': instance.fileSizeBytes,
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

const _$CredentialStatusEnumMap = {
  CredentialStatus.uploaded: 'uploaded',
  CredentialStatus.underReview: 'underReview',
  CredentialStatus.verified: 'verified',
  CredentialStatus.rejected: 'rejected',
  CredentialStatus.expired: 'expired',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
