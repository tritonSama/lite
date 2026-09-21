// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compute_node_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ComputeNodeStatus {

 String get nodeId; double get healthScore; bool get isActive; int get memoryAvailableMb; int get cpuTemperature; String? get lastTelemetrySync;
/// Create a copy of ComputeNodeStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComputeNodeStatusCopyWith<ComputeNodeStatus> get copyWith => _$ComputeNodeStatusCopyWithImpl<ComputeNodeStatus>(this as ComputeNodeStatus, _$identity);

  /// Serializes this ComputeNodeStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComputeNodeStatus&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.healthScore, healthScore) || other.healthScore == healthScore)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.memoryAvailableMb, memoryAvailableMb) || other.memoryAvailableMb == memoryAvailableMb)&&(identical(other.cpuTemperature, cpuTemperature) || other.cpuTemperature == cpuTemperature)&&(identical(other.lastTelemetrySync, lastTelemetrySync) || other.lastTelemetrySync == lastTelemetrySync));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nodeId,healthScore,isActive,memoryAvailableMb,cpuTemperature,lastTelemetrySync);

@override
String toString() {
  return 'ComputeNodeStatus(nodeId: $nodeId, healthScore: $healthScore, isActive: $isActive, memoryAvailableMb: $memoryAvailableMb, cpuTemperature: $cpuTemperature, lastTelemetrySync: $lastTelemetrySync)';
}


}

/// @nodoc
abstract mixin class $ComputeNodeStatusCopyWith<$Res>  {
  factory $ComputeNodeStatusCopyWith(ComputeNodeStatus value, $Res Function(ComputeNodeStatus) _then) = _$ComputeNodeStatusCopyWithImpl;
@useResult
$Res call({
 String nodeId, double healthScore, bool isActive, int memoryAvailableMb, int cpuTemperature, String? lastTelemetrySync
});




}
/// @nodoc
class _$ComputeNodeStatusCopyWithImpl<$Res>
    implements $ComputeNodeStatusCopyWith<$Res> {
  _$ComputeNodeStatusCopyWithImpl(this._self, this._then);

  final ComputeNodeStatus _self;
  final $Res Function(ComputeNodeStatus) _then;

/// Create a copy of ComputeNodeStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nodeId = null,Object? healthScore = null,Object? isActive = null,Object? memoryAvailableMb = null,Object? cpuTemperature = null,Object? lastTelemetrySync = freezed,}) {
  return _then(_self.copyWith(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,healthScore: null == healthScore ? _self.healthScore : healthScore // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,memoryAvailableMb: null == memoryAvailableMb ? _self.memoryAvailableMb : memoryAvailableMb // ignore: cast_nullable_to_non_nullable
as int,cpuTemperature: null == cpuTemperature ? _self.cpuTemperature : cpuTemperature // ignore: cast_nullable_to_non_nullable
as int,lastTelemetrySync: freezed == lastTelemetrySync ? _self.lastTelemetrySync : lastTelemetrySync // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ComputeNodeStatus].
extension ComputeNodeStatusPatterns on ComputeNodeStatus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComputeNodeStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComputeNodeStatus() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComputeNodeStatus value)  $default,){
final _that = this;
switch (_that) {
case _ComputeNodeStatus():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComputeNodeStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ComputeNodeStatus() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nodeId,  double healthScore,  bool isActive,  int memoryAvailableMb,  int cpuTemperature,  String? lastTelemetrySync)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComputeNodeStatus() when $default != null:
return $default(_that.nodeId,_that.healthScore,_that.isActive,_that.memoryAvailableMb,_that.cpuTemperature,_that.lastTelemetrySync);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nodeId,  double healthScore,  bool isActive,  int memoryAvailableMb,  int cpuTemperature,  String? lastTelemetrySync)  $default,) {final _that = this;
switch (_that) {
case _ComputeNodeStatus():
return $default(_that.nodeId,_that.healthScore,_that.isActive,_that.memoryAvailableMb,_that.cpuTemperature,_that.lastTelemetrySync);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nodeId,  double healthScore,  bool isActive,  int memoryAvailableMb,  int cpuTemperature,  String? lastTelemetrySync)?  $default,) {final _that = this;
switch (_that) {
case _ComputeNodeStatus() when $default != null:
return $default(_that.nodeId,_that.healthScore,_that.isActive,_that.memoryAvailableMb,_that.cpuTemperature,_that.lastTelemetrySync);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComputeNodeStatus implements ComputeNodeStatus {
  const _ComputeNodeStatus({required this.nodeId, this.healthScore = 0.0, this.isActive = false, this.memoryAvailableMb = 0, this.cpuTemperature = 0, this.lastTelemetrySync});
  factory _ComputeNodeStatus.fromJson(Map<String, dynamic> json) => _$ComputeNodeStatusFromJson(json);

@override final  String nodeId;
@override@JsonKey() final  double healthScore;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  int memoryAvailableMb;
@override@JsonKey() final  int cpuTemperature;
@override final  String? lastTelemetrySync;

/// Create a copy of ComputeNodeStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComputeNodeStatusCopyWith<_ComputeNodeStatus> get copyWith => __$ComputeNodeStatusCopyWithImpl<_ComputeNodeStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComputeNodeStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComputeNodeStatus&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.healthScore, healthScore) || other.healthScore == healthScore)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.memoryAvailableMb, memoryAvailableMb) || other.memoryAvailableMb == memoryAvailableMb)&&(identical(other.cpuTemperature, cpuTemperature) || other.cpuTemperature == cpuTemperature)&&(identical(other.lastTelemetrySync, lastTelemetrySync) || other.lastTelemetrySync == lastTelemetrySync));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nodeId,healthScore,isActive,memoryAvailableMb,cpuTemperature,lastTelemetrySync);

@override
String toString() {
  return 'ComputeNodeStatus(nodeId: $nodeId, healthScore: $healthScore, isActive: $isActive, memoryAvailableMb: $memoryAvailableMb, cpuTemperature: $cpuTemperature, lastTelemetrySync: $lastTelemetrySync)';
}


}

/// @nodoc
abstract mixin class _$ComputeNodeStatusCopyWith<$Res> implements $ComputeNodeStatusCopyWith<$Res> {
  factory _$ComputeNodeStatusCopyWith(_ComputeNodeStatus value, $Res Function(_ComputeNodeStatus) _then) = __$ComputeNodeStatusCopyWithImpl;
@override @useResult
$Res call({
 String nodeId, double healthScore, bool isActive, int memoryAvailableMb, int cpuTemperature, String? lastTelemetrySync
});




}
/// @nodoc
class __$ComputeNodeStatusCopyWithImpl<$Res>
    implements _$ComputeNodeStatusCopyWith<$Res> {
  __$ComputeNodeStatusCopyWithImpl(this._self, this._then);

  final _ComputeNodeStatus _self;
  final $Res Function(_ComputeNodeStatus) _then;

/// Create a copy of ComputeNodeStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nodeId = null,Object? healthScore = null,Object? isActive = null,Object? memoryAvailableMb = null,Object? cpuTemperature = null,Object? lastTelemetrySync = freezed,}) {
  return _then(_ComputeNodeStatus(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,healthScore: null == healthScore ? _self.healthScore : healthScore // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,memoryAvailableMb: null == memoryAvailableMb ? _self.memoryAvailableMb : memoryAvailableMb // ignore: cast_nullable_to_non_nullable
as int,cpuTemperature: null == cpuTemperature ? _self.cpuTemperature : cpuTemperature // ignore: cast_nullable_to_non_nullable
as int,lastTelemetrySync: freezed == lastTelemetrySync ? _self.lastTelemetrySync : lastTelemetrySync // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
