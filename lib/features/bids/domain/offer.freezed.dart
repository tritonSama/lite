// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Offer {

 String get id; String get taskId; String get bidderId; String? get bidderDisplayName; String? get bidderPhotoUrl; String? get parentOfferId; String get offerType; double get amount;@TimestampConverter() DateTime? get proposedCompletionDate; String? get message; OfferStatus get status; List<String> get attachedCredentialIds;@TimestampConverter() DateTime get createdAt;
/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferCopyWith<Offer> get copyWith => _$OfferCopyWithImpl<Offer>(this as Offer, _$identity);

  /// Serializes this Offer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Offer&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.bidderId, bidderId) || other.bidderId == bidderId)&&(identical(other.bidderDisplayName, bidderDisplayName) || other.bidderDisplayName == bidderDisplayName)&&(identical(other.bidderPhotoUrl, bidderPhotoUrl) || other.bidderPhotoUrl == bidderPhotoUrl)&&(identical(other.parentOfferId, parentOfferId) || other.parentOfferId == parentOfferId)&&(identical(other.offerType, offerType) || other.offerType == offerType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.proposedCompletionDate, proposedCompletionDate) || other.proposedCompletionDate == proposedCompletionDate)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.attachedCredentialIds, attachedCredentialIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,bidderId,bidderDisplayName,bidderPhotoUrl,parentOfferId,offerType,amount,proposedCompletionDate,message,status,const DeepCollectionEquality().hash(attachedCredentialIds),createdAt);

@override
String toString() {
  return 'Offer(id: $id, taskId: $taskId, bidderId: $bidderId, bidderDisplayName: $bidderDisplayName, bidderPhotoUrl: $bidderPhotoUrl, parentOfferId: $parentOfferId, offerType: $offerType, amount: $amount, proposedCompletionDate: $proposedCompletionDate, message: $message, status: $status, attachedCredentialIds: $attachedCredentialIds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $OfferCopyWith<$Res>  {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) _then) = _$OfferCopyWithImpl;
@useResult
$Res call({
 String id, String taskId, String bidderId, String? bidderDisplayName, String? bidderPhotoUrl, String? parentOfferId, String offerType, double amount,@TimestampConverter() DateTime? proposedCompletionDate, String? message, OfferStatus status, List<String> attachedCredentialIds,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class _$OfferCopyWithImpl<$Res>
    implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._self, this._then);

  final Offer _self;
  final $Res Function(Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? bidderId = null,Object? bidderDisplayName = freezed,Object? bidderPhotoUrl = freezed,Object? parentOfferId = freezed,Object? offerType = null,Object? amount = null,Object? proposedCompletionDate = freezed,Object? message = freezed,Object? status = null,Object? attachedCredentialIds = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,bidderId: null == bidderId ? _self.bidderId : bidderId // ignore: cast_nullable_to_non_nullable
as String,bidderDisplayName: freezed == bidderDisplayName ? _self.bidderDisplayName : bidderDisplayName // ignore: cast_nullable_to_non_nullable
as String?,bidderPhotoUrl: freezed == bidderPhotoUrl ? _self.bidderPhotoUrl : bidderPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,parentOfferId: freezed == parentOfferId ? _self.parentOfferId : parentOfferId // ignore: cast_nullable_to_non_nullable
as String?,offerType: null == offerType ? _self.offerType : offerType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,proposedCompletionDate: freezed == proposedCompletionDate ? _self.proposedCompletionDate : proposedCompletionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OfferStatus,attachedCredentialIds: null == attachedCredentialIds ? _self.attachedCredentialIds : attachedCredentialIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Offer].
extension OfferPatterns on Offer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Offer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Offer value)  $default,){
final _that = this;
switch (_that) {
case _Offer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Offer value)?  $default,){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskId,  String bidderId,  String? bidderDisplayName,  String? bidderPhotoUrl,  String? parentOfferId,  String offerType,  double amount, @TimestampConverter()  DateTime? proposedCompletionDate,  String? message,  OfferStatus status,  List<String> attachedCredentialIds, @TimestampConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.id,_that.taskId,_that.bidderId,_that.bidderDisplayName,_that.bidderPhotoUrl,_that.parentOfferId,_that.offerType,_that.amount,_that.proposedCompletionDate,_that.message,_that.status,_that.attachedCredentialIds,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskId,  String bidderId,  String? bidderDisplayName,  String? bidderPhotoUrl,  String? parentOfferId,  String offerType,  double amount, @TimestampConverter()  DateTime? proposedCompletionDate,  String? message,  OfferStatus status,  List<String> attachedCredentialIds, @TimestampConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Offer():
return $default(_that.id,_that.taskId,_that.bidderId,_that.bidderDisplayName,_that.bidderPhotoUrl,_that.parentOfferId,_that.offerType,_that.amount,_that.proposedCompletionDate,_that.message,_that.status,_that.attachedCredentialIds,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskId,  String bidderId,  String? bidderDisplayName,  String? bidderPhotoUrl,  String? parentOfferId,  String offerType,  double amount, @TimestampConverter()  DateTime? proposedCompletionDate,  String? message,  OfferStatus status,  List<String> attachedCredentialIds, @TimestampConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.id,_that.taskId,_that.bidderId,_that.bidderDisplayName,_that.bidderPhotoUrl,_that.parentOfferId,_that.offerType,_that.amount,_that.proposedCompletionDate,_that.message,_that.status,_that.attachedCredentialIds,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Offer implements Offer {
  const _Offer({required this.id, required this.taskId, required this.bidderId, this.bidderDisplayName, this.bidderPhotoUrl, this.parentOfferId, this.offerType = 'bid', required this.amount, @TimestampConverter() this.proposedCompletionDate, this.message, this.status = OfferStatus.pending, final  List<String> attachedCredentialIds = const [], @TimestampConverter() required this.createdAt}): _attachedCredentialIds = attachedCredentialIds;
  factory _Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

@override final  String id;
@override final  String taskId;
@override final  String bidderId;
@override final  String? bidderDisplayName;
@override final  String? bidderPhotoUrl;
@override final  String? parentOfferId;
@override@JsonKey() final  String offerType;
@override final  double amount;
@override@TimestampConverter() final  DateTime? proposedCompletionDate;
@override final  String? message;
@override@JsonKey() final  OfferStatus status;
 final  List<String> _attachedCredentialIds;
@override@JsonKey() List<String> get attachedCredentialIds {
  if (_attachedCredentialIds is EqualUnmodifiableListView) return _attachedCredentialIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachedCredentialIds);
}

@override@TimestampConverter() final  DateTime createdAt;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferCopyWith<_Offer> get copyWith => __$OfferCopyWithImpl<_Offer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Offer&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.bidderId, bidderId) || other.bidderId == bidderId)&&(identical(other.bidderDisplayName, bidderDisplayName) || other.bidderDisplayName == bidderDisplayName)&&(identical(other.bidderPhotoUrl, bidderPhotoUrl) || other.bidderPhotoUrl == bidderPhotoUrl)&&(identical(other.parentOfferId, parentOfferId) || other.parentOfferId == parentOfferId)&&(identical(other.offerType, offerType) || other.offerType == offerType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.proposedCompletionDate, proposedCompletionDate) || other.proposedCompletionDate == proposedCompletionDate)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._attachedCredentialIds, _attachedCredentialIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,bidderId,bidderDisplayName,bidderPhotoUrl,parentOfferId,offerType,amount,proposedCompletionDate,message,status,const DeepCollectionEquality().hash(_attachedCredentialIds),createdAt);

@override
String toString() {
  return 'Offer(id: $id, taskId: $taskId, bidderId: $bidderId, bidderDisplayName: $bidderDisplayName, bidderPhotoUrl: $bidderPhotoUrl, parentOfferId: $parentOfferId, offerType: $offerType, amount: $amount, proposedCompletionDate: $proposedCompletionDate, message: $message, status: $status, attachedCredentialIds: $attachedCredentialIds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$OfferCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$OfferCopyWith(_Offer value, $Res Function(_Offer) _then) = __$OfferCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskId, String bidderId, String? bidderDisplayName, String? bidderPhotoUrl, String? parentOfferId, String offerType, double amount,@TimestampConverter() DateTime? proposedCompletionDate, String? message, OfferStatus status, List<String> attachedCredentialIds,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class __$OfferCopyWithImpl<$Res>
    implements _$OfferCopyWith<$Res> {
  __$OfferCopyWithImpl(this._self, this._then);

  final _Offer _self;
  final $Res Function(_Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? bidderId = null,Object? bidderDisplayName = freezed,Object? bidderPhotoUrl = freezed,Object? parentOfferId = freezed,Object? offerType = null,Object? amount = null,Object? proposedCompletionDate = freezed,Object? message = freezed,Object? status = null,Object? attachedCredentialIds = null,Object? createdAt = null,}) {
  return _then(_Offer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,bidderId: null == bidderId ? _self.bidderId : bidderId // ignore: cast_nullable_to_non_nullable
as String,bidderDisplayName: freezed == bidderDisplayName ? _self.bidderDisplayName : bidderDisplayName // ignore: cast_nullable_to_non_nullable
as String?,bidderPhotoUrl: freezed == bidderPhotoUrl ? _self.bidderPhotoUrl : bidderPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,parentOfferId: freezed == parentOfferId ? _self.parentOfferId : parentOfferId // ignore: cast_nullable_to_non_nullable
as String?,offerType: null == offerType ? _self.offerType : offerType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,proposedCompletionDate: freezed == proposedCompletionDate ? _self.proposedCompletionDate : proposedCompletionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OfferStatus,attachedCredentialIds: null == attachedCredentialIds ? _self._attachedCredentialIds : attachedCredentialIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
