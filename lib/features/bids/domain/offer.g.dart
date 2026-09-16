// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Offer _$OfferFromJson(Map<String, dynamic> json) => _Offer(
  id: json['id'] as String,
  taskId: json['taskId'] as String,
  bidderId: json['bidderId'] as String,
  bidderDisplayName: json['bidderDisplayName'] as String?,
  bidderPhotoUrl: json['bidderPhotoUrl'] as String?,
  parentOfferId: json['parentOfferId'] as String?,
  offerType: json['offerType'] as String? ?? 'bid',
  amount: (json['amount'] as num).toDouble(),
  proposedCompletionDate: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['proposedCompletionDate'],
    const TimestampConverter().fromJson,
  ),
  message: json['message'] as String?,
  status:
      $enumDecodeNullable(_$OfferStatusEnumMap, json['status']) ??
      OfferStatus.pending,
  attachedCredentialIds:
      (json['attachedCredentialIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$OfferToJson(_Offer instance) => <String, dynamic>{
  'id': instance.id,
  'taskId': instance.taskId,
  'bidderId': instance.bidderId,
  'bidderDisplayName': instance.bidderDisplayName,
  'bidderPhotoUrl': instance.bidderPhotoUrl,
  'parentOfferId': instance.parentOfferId,
  'offerType': instance.offerType,
  'amount': instance.amount,
  'proposedCompletionDate': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.proposedCompletionDate,
    const TimestampConverter().toJson,
  ),
  'message': instance.message,
  'status': _$OfferStatusEnumMap[instance.status]!,
  'attachedCredentialIds': instance.attachedCredentialIds,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$OfferStatusEnumMap = {
  OfferStatus.pending: 'pending',
  OfferStatus.accepted: 'accepted',
  OfferStatus.rejected: 'rejected',
  OfferStatus.countered: 'countered',
  OfferStatus.withdrawn: 'withdrawn',
  OfferStatus.expired: 'expired',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
