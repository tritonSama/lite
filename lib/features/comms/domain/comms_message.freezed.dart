// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comms_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommsMessage {

 String get id; String get senderId; String get senderName; String get content; DateTime get timestamp; CommsChannel get channel; String? get targetId;
/// Create a copy of CommsMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommsMessageCopyWith<CommsMessage> get copyWith => _$CommsMessageCopyWithImpl<CommsMessage>(this as CommsMessage, _$identity);

  /// Serializes this CommsMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommsMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,senderId,senderName,content,timestamp,channel,targetId);

@override
String toString() {
  return 'CommsMessage(id: $id, senderId: $senderId, senderName: $senderName, content: $content, timestamp: $timestamp, channel: $channel, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class $CommsMessageCopyWith<$Res>  {
  factory $CommsMessageCopyWith(CommsMessage value, $Res Function(CommsMessage) _then) = _$CommsMessageCopyWithImpl;
@useResult
$Res call({
 String id, String senderId, String senderName, String content, DateTime timestamp, CommsChannel channel, String? targetId
});




}
/// @nodoc
class _$CommsMessageCopyWithImpl<$Res>
    implements $CommsMessageCopyWith<$Res> {
  _$CommsMessageCopyWithImpl(this._self, this._then);

  final CommsMessage _self;
  final $Res Function(CommsMessage) _then;

/// Create a copy of CommsMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? senderId = null,Object? senderName = null,Object? content = null,Object? timestamp = null,Object? channel = null,Object? targetId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as CommsChannel,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommsMessage].
extension CommsMessagePatterns on CommsMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommsMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommsMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommsMessage value)  $default,){
final _that = this;
switch (_that) {
case _CommsMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommsMessage value)?  $default,){
final _that = this;
switch (_that) {
case _CommsMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String senderId,  String senderName,  String content,  DateTime timestamp,  CommsChannel channel,  String? targetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommsMessage() when $default != null:
return $default(_that.id,_that.senderId,_that.senderName,_that.content,_that.timestamp,_that.channel,_that.targetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String senderId,  String senderName,  String content,  DateTime timestamp,  CommsChannel channel,  String? targetId)  $default,) {final _that = this;
switch (_that) {
case _CommsMessage():
return $default(_that.id,_that.senderId,_that.senderName,_that.content,_that.timestamp,_that.channel,_that.targetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String senderId,  String senderName,  String content,  DateTime timestamp,  CommsChannel channel,  String? targetId)?  $default,) {final _that = this;
switch (_that) {
case _CommsMessage() when $default != null:
return $default(_that.id,_that.senderId,_that.senderName,_that.content,_that.timestamp,_that.channel,_that.targetId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommsMessage implements CommsMessage {
  const _CommsMessage({required this.id, required this.senderId, required this.senderName, required this.content, required this.timestamp, required this.channel, this.targetId});
  factory _CommsMessage.fromJson(Map<String, dynamic> json) => _$CommsMessageFromJson(json);

@override final  String id;
@override final  String senderId;
@override final  String senderName;
@override final  String content;
@override final  DateTime timestamp;
@override final  CommsChannel channel;
@override final  String? targetId;

/// Create a copy of CommsMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommsMessageCopyWith<_CommsMessage> get copyWith => __$CommsMessageCopyWithImpl<_CommsMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommsMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommsMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,senderId,senderName,content,timestamp,channel,targetId);

@override
String toString() {
  return 'CommsMessage(id: $id, senderId: $senderId, senderName: $senderName, content: $content, timestamp: $timestamp, channel: $channel, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class _$CommsMessageCopyWith<$Res> implements $CommsMessageCopyWith<$Res> {
  factory _$CommsMessageCopyWith(_CommsMessage value, $Res Function(_CommsMessage) _then) = __$CommsMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String senderId, String senderName, String content, DateTime timestamp, CommsChannel channel, String? targetId
});




}
/// @nodoc
class __$CommsMessageCopyWithImpl<$Res>
    implements _$CommsMessageCopyWith<$Res> {
  __$CommsMessageCopyWithImpl(this._self, this._then);

  final _CommsMessage _self;
  final $Res Function(_CommsMessage) _then;

/// Create a copy of CommsMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? senderId = null,Object? senderName = null,Object? content = null,Object? timestamp = null,Object? channel = null,Object? targetId = freezed,}) {
  return _then(_CommsMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as CommsChannel,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
