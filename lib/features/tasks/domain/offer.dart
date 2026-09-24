import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/constants/enums.dart';

part 'offer.freezed.dart';
part 'offer.g.dart';

@freezed
abstract class Offer with _$Offer {
  const factory Offer({
    required String id,
    required String taskId,
    required String providerId,
    required double amount,
    String? message,
    @Default(OfferStatus.pending) OfferStatus status,
    required DateTime createdAt,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}
