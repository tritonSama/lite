// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      route: json['route'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'route': instance.route,
      'isRead': instance.isRead,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
