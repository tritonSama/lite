// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nexus_waitlist_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NexusWaitlistEntry {

 String get userId; String get name; String get email;@TimestampConverter() DateTime? get joinedAt;
/// Create a copy of NexusWaitlistEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NexusWaitlistEntryCopyWith<NexusWaitlistEntry> get copyWith => _$NexusWaitlistEntryCopyWithImpl<NexusWaitlistEntry>(this as NexusWaitlistEntry, _$identity);

  /// Serializes this NexusWaitlistEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NexusWaitlistEntry&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,name,email,joinedAt);

@override
String toString() {
  return 'NexusWaitlistEntry(userId: $userId, name: $name, email: $email, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $NexusWaitlistEntryCopyWith<$Res>  {
  factory $NexusWaitlistEntryCopyWith(NexusWaitlistEntry value, $Res Function(NexusWaitlistEntry) _then) = _$NexusWaitlistEntryCopyWithImpl;
@useResult
$Res call({
 String userId, String name, String email,@TimestampConverter() DateTime? joinedAt
});




}
/// @nodoc
class _$NexusWaitlistEntryCopyWithImpl<$Res>
    implements $NexusWaitlistEntryCopyWith<$Res> {
  _$NexusWaitlistEntryCopyWithImpl(this._self, this._then);

  final NexusWaitlistEntry _self;
  final $Res Function(NexusWaitlistEntry) _then;

/// Create a copy of NexusWaitlistEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? email = null,Object? joinedAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NexusWaitlistEntry].
extension NexusWaitlistEntryPatterns on NexusWaitlistEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NexusWaitlistEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NexusWaitlistEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NexusWaitlistEntry value)  $default,){
final _that = this;
switch (_that) {
case _NexusWaitlistEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NexusWaitlistEntry value)?  $default,){
final _that = this;
switch (_that) {
case _NexusWaitlistEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String name,  String email, @TimestampConverter()  DateTime? joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NexusWaitlistEntry() when $default != null:
return $default(_that.userId,_that.name,_that.email,_that.joinedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String name,  String email, @TimestampConverter()  DateTime? joinedAt)  $default,) {final _that = this;
switch (_that) {
case _NexusWaitlistEntry():
return $default(_that.userId,_that.name,_that.email,_that.joinedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String name,  String email, @TimestampConverter()  DateTime? joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _NexusWaitlistEntry() when $default != null:
return $default(_that.userId,_that.name,_that.email,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NexusWaitlistEntry implements NexusWaitlistEntry {
  const _NexusWaitlistEntry({required this.userId, required this.name, required this.email, @TimestampConverter() this.joinedAt});
  factory _NexusWaitlistEntry.fromJson(Map<String, dynamic> json) => _$NexusWaitlistEntryFromJson(json);

@override final  String userId;
@override final  String name;
@override final  String email;
@override@TimestampConverter() final  DateTime? joinedAt;

/// Create a copy of NexusWaitlistEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NexusWaitlistEntryCopyWith<_NexusWaitlistEntry> get copyWith => __$NexusWaitlistEntryCopyWithImpl<_NexusWaitlistEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NexusWaitlistEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NexusWaitlistEntry&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,name,email,joinedAt);

@override
String toString() {
  return 'NexusWaitlistEntry(userId: $userId, name: $name, email: $email, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$NexusWaitlistEntryCopyWith<$Res> implements $NexusWaitlistEntryCopyWith<$Res> {
  factory _$NexusWaitlistEntryCopyWith(_NexusWaitlistEntry value, $Res Function(_NexusWaitlistEntry) _then) = __$NexusWaitlistEntryCopyWithImpl;
@override @useResult
$Res call({
 String userId, String name, String email,@TimestampConverter() DateTime? joinedAt
});




}
/// @nodoc
class __$NexusWaitlistEntryCopyWithImpl<$Res>
    implements _$NexusWaitlistEntryCopyWith<$Res> {
  __$NexusWaitlistEntryCopyWithImpl(this._self, this._then);

  final _NexusWaitlistEntry _self;
  final $Res Function(_NexusWaitlistEntry) _then;

/// Create a copy of NexusWaitlistEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? email = null,Object? joinedAt = freezed,}) {
  return _then(_NexusWaitlistEntry(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
