import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/enums.dart';
import '../../../core/utils/firestore_converters.dart';

part 'offer.freezed.dart';
part 'offer.g.dart';

@freezed
abstract class Offer with _$Offer {
  const factory Offer({
    required String id,
    required String taskId,
    required String bidderId,
    String? bidderDisplayName,
    String? bidderPhotoUrl,
    String? parentOfferId,
    @Default('bid') String offerType,
    required double amount,
    @TimestampConverter() DateTime? proposedCompletionDate,
    String? message,
    @Default(OfferStatus.pending) OfferStatus status,
    @Default([]) List<String> attachedCredentialIds,
    @TimestampConverter() required DateTime createdAt,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}
