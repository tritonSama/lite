import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/firestore_converters.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required String title,
    required String body,
    String? route,
    @Default(false) bool isRead,
    @TimestampConverter() required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
