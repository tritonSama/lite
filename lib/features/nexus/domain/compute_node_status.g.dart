// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compute_node_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ComputeNodeStatus _$ComputeNodeStatusFromJson(Map<String, dynamic> json) =>
    _ComputeNodeStatus(
      nodeId: json['nodeId'] as String,
      healthScore: (json['healthScore'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? false,
      memoryAvailableMb: (json['memoryAvailableMb'] as num?)?.toInt() ?? 0,
      cpuTemperature: (json['cpuTemperature'] as num?)?.toInt() ?? 0,
      lastTelemetrySync: json['lastTelemetrySync'] as String?,
    );

Map<String, dynamic> _$ComputeNodeStatusToJson(_ComputeNodeStatus instance) =>
    <String, dynamic>{
      'nodeId': instance.nodeId,
      'healthScore': instance.healthScore,
      'isActive': instance.isActive,
      'memoryAvailableMb': instance.memoryAvailableMb,
      'cpuTemperature': instance.cpuTemperature,
      'lastTelemetrySync': instance.lastTelemetrySync,
    };
