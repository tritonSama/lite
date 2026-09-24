// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Offer _$OfferFromJson(Map<String, dynamic> json) => _Offer(
  id: json['id'] as String,
  taskId: json['taskId'] as String,
  providerId: json['providerId'] as String,
  amount: (json['amount'] as num).toDouble(),
  message: json['message'] as String?,
  status:
      $enumDecodeNullable(_$OfferStatusEnumMap, json['status']) ??
      OfferStatus.pending,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$OfferToJson(_Offer instance) => <String, dynamic>{
  'id': instance.id,
  'taskId': instance.taskId,
  'providerId': instance.providerId,
  'amount': instance.amount,
  'message': instance.message,
  'status': _$OfferStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$OfferStatusEnumMap = {
  OfferStatus.pending: 'pending',
  OfferStatus.accepted: 'accepted',
  OfferStatus.rejected: 'rejected',
  OfferStatus.countered: 'countered',
  OfferStatus.withdrawn: 'withdrawn',
  OfferStatus.expired: 'expired',
};
