// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Team {

 String get id; String get name; String? get description; String get ownerId; int get memberCount; List<String> get credentialIds; double get rating; int get completedJobCount;@TimestampConverter() DateTime get createdAt;
/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamCopyWith<Team> get copyWith => _$TeamCopyWithImpl<Team>(this as Team, _$identity);

  /// Serializes this Team to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Team&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other.credentialIds, credentialIds)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.completedJobCount, completedJobCount) || other.completedJobCount == completedJobCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,ownerId,memberCount,const DeepCollectionEquality().hash(credentialIds),rating,completedJobCount,createdAt);

@override
String toString() {
  return 'Team(id: $id, name: $name, description: $description, ownerId: $ownerId, memberCount: $memberCount, credentialIds: $credentialIds, rating: $rating, completedJobCount: $completedJobCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TeamCopyWith<$Res>  {
  factory $TeamCopyWith(Team value, $Res Function(Team) _then) = _$TeamCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String ownerId, int memberCount, List<String> credentialIds, double rating, int completedJobCount,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class _$TeamCopyWithImpl<$Res>
    implements $TeamCopyWith<$Res> {
  _$TeamCopyWithImpl(this._self, this._then);

  final Team _self;
  final $Res Function(Team) _then;

/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? ownerId = null,Object? memberCount = null,Object? credentialIds = null,Object? rating = null,Object? completedJobCount = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,credentialIds: null == credentialIds ? _self.credentialIds : credentialIds // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,completedJobCount: null == completedJobCount ? _self.completedJobCount : completedJobCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Team].
extension TeamPatterns on Team {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Team value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Team() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Team value)  $default,){
final _that = this;
switch (_that) {
case _Team():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Team value)?  $default,){
final _that = this;
switch (_that) {
case _Team() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String ownerId,  int memberCount,  List<String> credentialIds,  double rating,  int completedJobCount, @TimestampConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Team() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.ownerId,_that.memberCount,_that.credentialIds,_that.rating,_that.completedJobCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String ownerId,  int memberCount,  List<String> credentialIds,  double rating,  int completedJobCount, @TimestampConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Team():
return $default(_that.id,_that.name,_that.description,_that.ownerId,_that.memberCount,_that.credentialIds,_that.rating,_that.completedJobCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String ownerId,  int memberCount,  List<String> credentialIds,  double rating,  int completedJobCount, @TimestampConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Team() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.ownerId,_that.memberCount,_that.credentialIds,_that.rating,_that.completedJobCount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Team implements Team {
  const _Team({required this.id, required this.name, this.description, required this.ownerId, this.memberCount = 0, final  List<String> credentialIds = const [], this.rating = 0.0, this.completedJobCount = 0, @TimestampConverter() required this.createdAt}): _credentialIds = credentialIds;
  factory _Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String ownerId;
@override@JsonKey() final  int memberCount;
 final  List<String> _credentialIds;
@override@JsonKey() List<String> get credentialIds {
  if (_credentialIds is EqualUnmodifiableListView) return _credentialIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_credentialIds);
}

@override@JsonKey() final  double rating;
@override@JsonKey() final  int completedJobCount;
@override@TimestampConverter() final  DateTime createdAt;

/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamCopyWith<_Team> get copyWith => __$TeamCopyWithImpl<_Team>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Team&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other._credentialIds, _credentialIds)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.completedJobCount, completedJobCount) || other.completedJobCount == completedJobCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,ownerId,memberCount,const DeepCollectionEquality().hash(_credentialIds),rating,completedJobCount,createdAt);

@override
String toString() {
  return 'Team(id: $id, name: $name, description: $description, ownerId: $ownerId, memberCount: $memberCount, credentialIds: $credentialIds, rating: $rating, completedJobCount: $completedJobCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TeamCopyWith<$Res> implements $TeamCopyWith<$Res> {
  factory _$TeamCopyWith(_Team value, $Res Function(_Team) _then) = __$TeamCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String ownerId, int memberCount, List<String> credentialIds, double rating, int completedJobCount,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class __$TeamCopyWithImpl<$Res>
    implements _$TeamCopyWith<$Res> {
  __$TeamCopyWithImpl(this._self, this._then);

  final _Team _self;
  final $Res Function(_Team) _then;

/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? ownerId = null,Object? memberCount = null,Object? credentialIds = null,Object? rating = null,Object? completedJobCount = null,Object? createdAt = null,}) {
  return _then(_Team(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,credentialIds: null == credentialIds ? _self._credentialIds : credentialIds // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,completedJobCount: null == completedJobCount ? _self.completedJobCount : completedJobCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Membership {

 String get id; String get teamId; String get userId; String? get userDisplayName; String? get userPhotoUrl; MemberRole get role; MemberStatus get status;@TimestampConverter() DateTime get joinedAt;
/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipCopyWith<Membership> get copyWith => _$MembershipCopyWithImpl<Membership>(this as Membership, _$identity);

  /// Serializes this Membership to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Membership&&(identical(other.id, id) || other.id == id)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userDisplayName, userDisplayName) || other.userDisplayName == userDisplayName)&&(identical(other.userPhotoUrl, userPhotoUrl) || other.userPhotoUrl == userPhotoUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teamId,userId,userDisplayName,userPhotoUrl,role,status,joinedAt);

@override
String toString() {
  return 'Membership(id: $id, teamId: $teamId, userId: $userId, userDisplayName: $userDisplayName, userPhotoUrl: $userPhotoUrl, role: $role, status: $status, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $MembershipCopyWith<$Res>  {
  factory $MembershipCopyWith(Membership value, $Res Function(Membership) _then) = _$MembershipCopyWithImpl;
@useResult
$Res call({
 String id, String teamId, String userId, String? userDisplayName, String? userPhotoUrl, MemberRole role, MemberStatus status,@TimestampConverter() DateTime joinedAt
});




}
/// @nodoc
class _$MembershipCopyWithImpl<$Res>
    implements $MembershipCopyWith<$Res> {
  _$MembershipCopyWithImpl(this._self, this._then);

  final Membership _self;
  final $Res Function(Membership) _then;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? teamId = null,Object? userId = null,Object? userDisplayName = freezed,Object? userPhotoUrl = freezed,Object? role = null,Object? status = null,Object? joinedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userDisplayName: freezed == userDisplayName ? _self.userDisplayName : userDisplayName // ignore: cast_nullable_to_non_nullable
as String?,userPhotoUrl: freezed == userPhotoUrl ? _self.userPhotoUrl : userPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Membership].
extension MembershipPatterns on Membership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Membership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Membership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Membership value)  $default,){
final _that = this;
switch (_that) {
case _Membership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Membership value)?  $default,){
final _that = this;
switch (_that) {
case _Membership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String teamId,  String userId,  String? userDisplayName,  String? userPhotoUrl,  MemberRole role,  MemberStatus status, @TimestampConverter()  DateTime joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Membership() when $default != null:
return $default(_that.id,_that.teamId,_that.userId,_that.userDisplayName,_that.userPhotoUrl,_that.role,_that.status,_that.joinedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String teamId,  String userId,  String? userDisplayName,  String? userPhotoUrl,  MemberRole role,  MemberStatus status, @TimestampConverter()  DateTime joinedAt)  $default,) {final _that = this;
switch (_that) {
case _Membership():
return $default(_that.id,_that.teamId,_that.userId,_that.userDisplayName,_that.userPhotoUrl,_that.role,_that.status,_that.joinedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String teamId,  String userId,  String? userDisplayName,  String? userPhotoUrl,  MemberRole role,  MemberStatus status, @TimestampConverter()  DateTime joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _Membership() when $default != null:
return $default(_that.id,_that.teamId,_that.userId,_that.userDisplayName,_that.userPhotoUrl,_that.role,_that.status,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Membership implements Membership {
  const _Membership({required this.id, required this.teamId, required this.userId, this.userDisplayName, this.userPhotoUrl, this.role = MemberRole.member, this.status = MemberStatus.invited, @TimestampConverter() required this.joinedAt});
  factory _Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

@override final  String id;
@override final  String teamId;
@override final  String userId;
@override final  String? userDisplayName;
@override final  String? userPhotoUrl;
@override@JsonKey() final  MemberRole role;
@override@JsonKey() final  MemberStatus status;
@override@TimestampConverter() final  DateTime joinedAt;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipCopyWith<_Membership> get copyWith => __$MembershipCopyWithImpl<_Membership>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MembershipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Membership&&(identical(other.id, id) || other.id == id)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userDisplayName, userDisplayName) || other.userDisplayName == userDisplayName)&&(identical(other.userPhotoUrl, userPhotoUrl) || other.userPhotoUrl == userPhotoUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teamId,userId,userDisplayName,userPhotoUrl,role,status,joinedAt);

@override
String toString() {
  return 'Membership(id: $id, teamId: $teamId, userId: $userId, userDisplayName: $userDisplayName, userPhotoUrl: $userPhotoUrl, role: $role, status: $status, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$MembershipCopyWith<$Res> implements $MembershipCopyWith<$Res> {
  factory _$MembershipCopyWith(_Membership value, $Res Function(_Membership) _then) = __$MembershipCopyWithImpl;
@override @useResult
$Res call({
 String id, String teamId, String userId, String? userDisplayName, String? userPhotoUrl, MemberRole role, MemberStatus status,@TimestampConverter() DateTime joinedAt
});




}
/// @nodoc
class __$MembershipCopyWithImpl<$Res>
    implements _$MembershipCopyWith<$Res> {
  __$MembershipCopyWithImpl(this._self, this._then);

  final _Membership _self;
  final $Res Function(_Membership) _then;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? teamId = null,Object? userId = null,Object? userDisplayName = freezed,Object? userPhotoUrl = freezed,Object? role = null,Object? status = null,Object? joinedAt = null,}) {
  return _then(_Membership(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userDisplayName: freezed == userDisplayName ? _self.userDisplayName : userDisplayName // ignore: cast_nullable_to_non_nullable
as String?,userPhotoUrl: freezed == userPhotoUrl ? _self.userPhotoUrl : userPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
