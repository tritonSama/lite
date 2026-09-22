import 'package:freezed_annotation/freezed_annotation.dart';

part 'compute_node_status.freezed.dart';
part 'compute_node_status.g.dart';

@freezed
abstract class ComputeNodeStatus with _$ComputeNodeStatus {
  const factory ComputeNodeStatus({
    required String nodeId,
    @Default(0.0) double healthScore,
    @Default(false) bool isActive,
    @Default(0) int memoryAvailableMb,
    @Default(0) int cpuTemperature,
    String? lastTelemetrySync,
  }) = _ComputeNodeStatus;

  factory ComputeNodeStatus.fromJson(Map<String, dynamic> json) =>
      _$ComputeNodeStatusFromJson(json);
}
