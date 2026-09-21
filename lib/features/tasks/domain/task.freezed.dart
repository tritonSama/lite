// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequiredCredential {

 CredentialType get credentialType; bool get isRequired;
/// Create a copy of RequiredCredential
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequiredCredentialCopyWith<RequiredCredential> get copyWith => _$RequiredCredentialCopyWithImpl<RequiredCredential>(this as RequiredCredential, _$identity);

  /// Serializes this RequiredCredential to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequiredCredential&&(identical(other.credentialType, credentialType) || other.credentialType == credentialType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,credentialType,isRequired);

@override
String toString() {
  return 'RequiredCredential(credentialType: $credentialType, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class $RequiredCredentialCopyWith<$Res>  {
  factory $RequiredCredentialCopyWith(RequiredCredential value, $Res Function(RequiredCredential) _then) = _$RequiredCredentialCopyWithImpl;
@useResult
$Res call({
 CredentialType credentialType, bool isRequired
});




}
/// @nodoc
class _$RequiredCredentialCopyWithImpl<$Res>
    implements $RequiredCredentialCopyWith<$Res> {
  _$RequiredCredentialCopyWithImpl(this._self, this._then);

  final RequiredCredential _self;
  final $Res Function(RequiredCredential) _then;

/// Create a copy of RequiredCredential
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? credentialType = null,Object? isRequired = null,}) {
  return _then(_self.copyWith(
credentialType: null == credentialType ? _self.credentialType : credentialType // ignore: cast_nullable_to_non_nullable
as CredentialType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RequiredCredential].
extension RequiredCredentialPatterns on RequiredCredential {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequiredCredential value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequiredCredential() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequiredCredential value)  $default,){
final _that = this;
switch (_that) {
case _RequiredCredential():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequiredCredential value)?  $default,){
final _that = this;
switch (_that) {
case _RequiredCredential() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CredentialType credentialType,  bool isRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequiredCredential() when $default != null:
return $default(_that.credentialType,_that.isRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CredentialType credentialType,  bool isRequired)  $default,) {final _that = this;
switch (_that) {
case _RequiredCredential():
return $default(_that.credentialType,_that.isRequired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CredentialType credentialType,  bool isRequired)?  $default,) {final _that = this;
switch (_that) {
case _RequiredCredential() when $default != null:
return $default(_that.credentialType,_that.isRequired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequiredCredential implements RequiredCredential {
  const _RequiredCredential({required this.credentialType, this.isRequired = false});
  factory _RequiredCredential.fromJson(Map<String, dynamic> json) => _$RequiredCredentialFromJson(json);

@override final  CredentialType credentialType;
@override@JsonKey() final  bool isRequired;

/// Create a copy of RequiredCredential
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequiredCredentialCopyWith<_RequiredCredential> get copyWith => __$RequiredCredentialCopyWithImpl<_RequiredCredential>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequiredCredentialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequiredCredential&&(identical(other.credentialType, credentialType) || other.credentialType == credentialType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,credentialType,isRequired);

@override
String toString() {
  return 'RequiredCredential(credentialType: $credentialType, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class _$RequiredCredentialCopyWith<$Res> implements $RequiredCredentialCopyWith<$Res> {
  factory _$RequiredCredentialCopyWith(_RequiredCredential value, $Res Function(_RequiredCredential) _then) = __$RequiredCredentialCopyWithImpl;
@override @useResult
$Res call({
 CredentialType credentialType, bool isRequired
});




}
/// @nodoc
class __$RequiredCredentialCopyWithImpl<$Res>
    implements _$RequiredCredentialCopyWith<$Res> {
  __$RequiredCredentialCopyWithImpl(this._self, this._then);

  final _RequiredCredential _self;
  final $Res Function(_RequiredCredential) _then;

/// Create a copy of RequiredCredential
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? credentialType = null,Object? isRequired = null,}) {
  return _then(_RequiredCredential(
credentialType: null == credentialType ? _self.credentialType : credentialType // ignore: cast_nullable_to_non_nullable
as CredentialType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Task {

 String get id; String get creatorId; String get title; String get description; List<String> get photoUrls;@GeoPointConverter() GeoPoint get location; String get locationLabel; String get geohash;@TimestampConverter() DateTime get desiredCompletionDate; double get budgetAmount; String get currencyCode; List<String> get requiredSkills; List<String> get requiredEquipment; List<RequiredCredential> get requiredCredentials; int get workerCount; String? get specialRequirements; double? get platformFee; TaskStatus get status; String? get selectedProviderId; int get bidCount; TaskCategory get category;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, id) || other.id == id)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.photoUrls, photoUrls)&&(identical(other.location, location) || other.location == location)&&(identical(other.locationLabel, locationLabel) || other.locationLabel == locationLabel)&&(identical(other.geohash, geohash) || other.geohash == geohash)&&(identical(other.desiredCompletionDate, desiredCompletionDate) || other.desiredCompletionDate == desiredCompletionDate)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&const DeepCollectionEquality().equals(other.requiredSkills, requiredSkills)&&const DeepCollectionEquality().equals(other.requiredEquipment, requiredEquipment)&&const DeepCollectionEquality().equals(other.requiredCredentials, requiredCredentials)&&(identical(other.workerCount, workerCount) || other.workerCount == workerCount)&&(identical(other.specialRequirements, specialRequirements) || other.specialRequirements == specialRequirements)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.status, status) || other.status == status)&&(identical(other.selectedProviderId, selectedProviderId) || other.selectedProviderId == selectedProviderId)&&(identical(other.bidCount, bidCount) || other.bidCount == bidCount)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,creatorId,title,description,const DeepCollectionEquality().hash(photoUrls),location,locationLabel,geohash,desiredCompletionDate,budgetAmount,currencyCode,const DeepCollectionEquality().hash(requiredSkills),const DeepCollectionEquality().hash(requiredEquipment),const DeepCollectionEquality().hash(requiredCredentials),workerCount,specialRequirements,platformFee,status,selectedProviderId,bidCount,category,createdAt,updatedAt]);

@override
String toString() {
  return 'Task(id: $id, creatorId: $creatorId, title: $title, description: $description, photoUrls: $photoUrls, location: $location, locationLabel: $locationLabel, geohash: $geohash, desiredCompletionDate: $desiredCompletionDate, budgetAmount: $budgetAmount, currencyCode: $currencyCode, requiredSkills: $requiredSkills, requiredEquipment: $requiredEquipment, requiredCredentials: $requiredCredentials, workerCount: $workerCount, specialRequirements: $specialRequirements, platformFee: $platformFee, status: $status, selectedProviderId: $selectedProviderId, bidCount: $bidCount, category: $category, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 String id, String creatorId, String title, String description, List<String> photoUrls,@GeoPointConverter() GeoPoint location, String locationLabel, String geohash,@TimestampConverter() DateTime desiredCompletionDate, double budgetAmount, String currencyCode, List<String> requiredSkills, List<String> requiredEquipment, List<RequiredCredential> requiredCredentials, int workerCount, String? specialRequirements, double? platformFee, TaskStatus status, String? selectedProviderId, int bidCount, TaskCategory category,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? creatorId = null,Object? title = null,Object? description = null,Object? photoUrls = null,Object? location = null,Object? locationLabel = null,Object? geohash = null,Object? desiredCompletionDate = null,Object? budgetAmount = null,Object? currencyCode = null,Object? requiredSkills = null,Object? requiredEquipment = null,Object? requiredCredentials = null,Object? workerCount = null,Object? specialRequirements = freezed,Object? platformFee = freezed,Object? status = null,Object? selectedProviderId = freezed,Object? bidCount = null,Object? category = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,creatorId: null == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,photoUrls: null == photoUrls ? _self.photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,locationLabel: null == locationLabel ? _self.locationLabel : locationLabel // ignore: cast_nullable_to_non_nullable
as String,geohash: null == geohash ? _self.geohash : geohash // ignore: cast_nullable_to_non_nullable
as String,desiredCompletionDate: null == desiredCompletionDate ? _self.desiredCompletionDate : desiredCompletionDate // ignore: cast_nullable_to_non_nullable
as DateTime,budgetAmount: null == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,requiredSkills: null == requiredSkills ? _self.requiredSkills : requiredSkills // ignore: cast_nullable_to_non_nullable
as List<String>,requiredEquipment: null == requiredEquipment ? _self.requiredEquipment : requiredEquipment // ignore: cast_nullable_to_non_nullable
as List<String>,requiredCredentials: null == requiredCredentials ? _self.requiredCredentials : requiredCredentials // ignore: cast_nullable_to_non_nullable
as List<RequiredCredential>,workerCount: null == workerCount ? _self.workerCount : workerCount // ignore: cast_nullable_to_non_nullable
as int,specialRequirements: freezed == specialRequirements ? _self.specialRequirements : specialRequirements // ignore: cast_nullable_to_non_nullable
as String?,platformFee: freezed == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,selectedProviderId: freezed == selectedProviderId ? _self.selectedProviderId : selectedProviderId // ignore: cast_nullable_to_non_nullable
as String?,bidCount: null == bidCount ? _self.bidCount : bidCount // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskCategory,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String creatorId,  String title,  String description,  List<String> photoUrls, @GeoPointConverter()  GeoPoint location,  String locationLabel,  String geohash, @TimestampConverter()  DateTime desiredCompletionDate,  double budgetAmount,  String currencyCode,  List<String> requiredSkills,  List<String> requiredEquipment,  List<RequiredCredential> requiredCredentials,  int workerCount,  String? specialRequirements,  double? platformFee,  TaskStatus status,  String? selectedProviderId,  int bidCount,  TaskCategory category, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.creatorId,_that.title,_that.description,_that.photoUrls,_that.location,_that.locationLabel,_that.geohash,_that.desiredCompletionDate,_that.budgetAmount,_that.currencyCode,_that.requiredSkills,_that.requiredEquipment,_that.requiredCredentials,_that.workerCount,_that.specialRequirements,_that.platformFee,_that.status,_that.selectedProviderId,_that.bidCount,_that.category,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String creatorId,  String title,  String description,  List<String> photoUrls, @GeoPointConverter()  GeoPoint location,  String locationLabel,  String geohash, @TimestampConverter()  DateTime desiredCompletionDate,  double budgetAmount,  String currencyCode,  List<String> requiredSkills,  List<String> requiredEquipment,  List<RequiredCredential> requiredCredentials,  int workerCount,  String? specialRequirements,  double? platformFee,  TaskStatus status,  String? selectedProviderId,  int bidCount,  TaskCategory category, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.creatorId,_that.title,_that.description,_that.photoUrls,_that.location,_that.locationLabel,_that.geohash,_that.desiredCompletionDate,_that.budgetAmount,_that.currencyCode,_that.requiredSkills,_that.requiredEquipment,_that.requiredCredentials,_that.workerCount,_that.specialRequirements,_that.platformFee,_that.status,_that.selectedProviderId,_that.bidCount,_that.category,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String creatorId,  String title,  String description,  List<String> photoUrls, @GeoPointConverter()  GeoPoint location,  String locationLabel,  String geohash, @TimestampConverter()  DateTime desiredCompletionDate,  double budgetAmount,  String currencyCode,  List<String> requiredSkills,  List<String> requiredEquipment,  List<RequiredCredential> requiredCredentials,  int workerCount,  String? specialRequirements,  double? platformFee,  TaskStatus status,  String? selectedProviderId,  int bidCount,  TaskCategory category, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.creatorId,_that.title,_that.description,_that.photoUrls,_that.location,_that.locationLabel,_that.geohash,_that.desiredCompletionDate,_that.budgetAmount,_that.currencyCode,_that.requiredSkills,_that.requiredEquipment,_that.requiredCredentials,_that.workerCount,_that.specialRequirements,_that.platformFee,_that.status,_that.selectedProviderId,_that.bidCount,_that.category,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Task implements Task {
  const _Task({required this.id, required this.creatorId, required this.title, required this.description, final  List<String> photoUrls = const [], @GeoPointConverter() required this.location, required this.locationLabel, required this.geohash, @TimestampConverter() required this.desiredCompletionDate, required this.budgetAmount, this.currencyCode = 'USD', final  List<String> requiredSkills = const [], final  List<String> requiredEquipment = const [], final  List<RequiredCredential> requiredCredentials = const [], this.workerCount = 1, this.specialRequirements, this.platformFee, this.status = TaskStatus.draft, this.selectedProviderId, this.bidCount = 0, this.category = TaskCategory.cleanup, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt}): _photoUrls = photoUrls,_requiredSkills = requiredSkills,_requiredEquipment = requiredEquipment,_requiredCredentials = requiredCredentials;
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

@override final  String id;
@override final  String creatorId;
@override final  String title;
@override final  String description;
 final  List<String> _photoUrls;
@override@JsonKey() List<String> get photoUrls {
  if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoUrls);
}

@override@GeoPointConverter() final  GeoPoint location;
@override final  String locationLabel;
@override final  String geohash;
@override@TimestampConverter() final  DateTime desiredCompletionDate;
@override final  double budgetAmount;
@override@JsonKey() final  String currencyCode;
 final  List<String> _requiredSkills;
@override@JsonKey() List<String> get requiredSkills {
  if (_requiredSkills is EqualUnmodifiableListView) return _requiredSkills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requiredSkills);
}

 final  List<String> _requiredEquipment;
@override@JsonKey() List<String> get requiredEquipment {
  if (_requiredEquipment is EqualUnmodifiableListView) return _requiredEquipment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requiredEquipment);
}

 final  List<RequiredCredential> _requiredCredentials;
@override@JsonKey() List<RequiredCredential> get requiredCredentials {
  if (_requiredCredentials is EqualUnmodifiableListView) return _requiredCredentials;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requiredCredentials);
}

@override@JsonKey() final  int workerCount;
@override final  String? specialRequirements;
@override final  double? platformFee;
@override@JsonKey() final  TaskStatus status;
@override final  String? selectedProviderId;
@override@JsonKey() final  int bidCount;
@override@JsonKey() final  TaskCategory category;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._photoUrls, _photoUrls)&&(identical(other.location, location) || other.location == location)&&(identical(other.locationLabel, locationLabel) || other.locationLabel == locationLabel)&&(identical(other.geohash, geohash) || other.geohash == geohash)&&(identical(other.desiredCompletionDate, desiredCompletionDate) || other.desiredCompletionDate == desiredCompletionDate)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&const DeepCollectionEquality().equals(other._requiredSkills, _requiredSkills)&&const DeepCollectionEquality().equals(other._requiredEquipment, _requiredEquipment)&&const DeepCollectionEquality().equals(other._requiredCredentials, _requiredCredentials)&&(identical(other.workerCount, workerCount) || other.workerCount == workerCount)&&(identical(other.specialRequirements, specialRequirements) || other.specialRequirements == specialRequirements)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.status, status) || other.status == status)&&(identical(other.selectedProviderId, selectedProviderId) || other.selectedProviderId == selectedProviderId)&&(identical(other.bidCount, bidCount) || other.bidCount == bidCount)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,creatorId,title,description,const DeepCollectionEquality().hash(_photoUrls),location,locationLabel,geohash,desiredCompletionDate,budgetAmount,currencyCode,const DeepCollectionEquality().hash(_requiredSkills),const DeepCollectionEquality().hash(_requiredEquipment),const DeepCollectionEquality().hash(_requiredCredentials),workerCount,specialRequirements,platformFee,status,selectedProviderId,bidCount,category,createdAt,updatedAt]);

@override
String toString() {
  return 'Task(id: $id, creatorId: $creatorId, title: $title, description: $description, photoUrls: $photoUrls, location: $location, locationLabel: $locationLabel, geohash: $geohash, desiredCompletionDate: $desiredCompletionDate, budgetAmount: $budgetAmount, currencyCode: $currencyCode, requiredSkills: $requiredSkills, requiredEquipment: $requiredEquipment, requiredCredentials: $requiredCredentials, workerCount: $workerCount, specialRequirements: $specialRequirements, platformFee: $platformFee, status: $status, selectedProviderId: $selectedProviderId, bidCount: $bidCount, category: $category, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String creatorId, String title, String description, List<String> photoUrls,@GeoPointConverter() GeoPoint location, String locationLabel, String geohash,@TimestampConverter() DateTime desiredCompletionDate, double budgetAmount, String currencyCode, List<String> requiredSkills, List<String> requiredEquipment, List<RequiredCredential> requiredCredentials, int workerCount, String? specialRequirements, double? platformFee, TaskStatus status, String? selectedProviderId, int bidCount, TaskCategory category,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? creatorId = null,Object? title = null,Object? description = null,Object? photoUrls = null,Object? location = null,Object? locationLabel = null,Object? geohash = null,Object? desiredCompletionDate = null,Object? budgetAmount = null,Object? currencyCode = null,Object? requiredSkills = null,Object? requiredEquipment = null,Object? requiredCredentials = null,Object? workerCount = null,Object? specialRequirements = freezed,Object? platformFee = freezed,Object? status = null,Object? selectedProviderId = freezed,Object? bidCount = null,Object? category = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,creatorId: null == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,photoUrls: null == photoUrls ? _self._photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,locationLabel: null == locationLabel ? _self.locationLabel : locationLabel // ignore: cast_nullable_to_non_nullable
as String,geohash: null == geohash ? _self.geohash : geohash // ignore: cast_nullable_to_non_nullable
as String,desiredCompletionDate: null == desiredCompletionDate ? _self.desiredCompletionDate : desiredCompletionDate // ignore: cast_nullable_to_non_nullable
as DateTime,budgetAmount: null == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,requiredSkills: null == requiredSkills ? _self._requiredSkills : requiredSkills // ignore: cast_nullable_to_non_nullable
as List<String>,requiredEquipment: null == requiredEquipment ? _self._requiredEquipment : requiredEquipment // ignore: cast_nullable_to_non_nullable
as List<String>,requiredCredentials: null == requiredCredentials ? _self._requiredCredentials : requiredCredentials // ignore: cast_nullable_to_non_nullable
as List<RequiredCredential>,workerCount: null == workerCount ? _self.workerCount : workerCount // ignore: cast_nullable_to_non_nullable
as int,specialRequirements: freezed == specialRequirements ? _self.specialRequirements : specialRequirements // ignore: cast_nullable_to_non_nullable
as String?,platformFee: freezed == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,selectedProviderId: freezed == selectedProviderId ? _self.selectedProviderId : selectedProviderId // ignore: cast_nullable_to_non_nullable
as String?,bidCount: null == bidCount ? _self.bidCount : bidCount // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskCategory,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
