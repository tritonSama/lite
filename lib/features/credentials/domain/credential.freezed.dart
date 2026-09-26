// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credential.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Credential {

 String get id; String get ownerId; CredentialType get credentialType; String get label; String get storagePath; String? get downloadUrl; CredentialStatus get status;@TimestampConverter() DateTime? get expiresAt;@TimestampConverter() DateTime get uploadedAt;@TimestampConverter() DateTime? get verifiedAt; String? get verifiedBy; String get mimeType; int get fileSizeBytes;
/// Create a copy of Credential
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CredentialCopyWith<Credential> get copyWith => _$CredentialCopyWithImpl<Credential>(this as Credential, _$identity);

  /// Serializes this Credential to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Credential;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Credential&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.credentialType, _this.credentialType) || other.credentialType == _this.credentialType)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.storagePath, _this.storagePath) || other.storagePath == _this.storagePath)&&(identical(other.downloadUrl, _this.downloadUrl) || other.downloadUrl == _this.downloadUrl)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.uploadedAt, _this.uploadedAt) || other.uploadedAt == _this.uploadedAt)&&(identical(other.verifiedAt, _this.verifiedAt) || other.verifiedAt == _this.verifiedAt)&&(identical(other.verifiedBy, _this.verifiedBy) || other.verifiedBy == _this.verifiedBy)&&(identical(other.mimeType, _this.mimeType) || other.mimeType == _this.mimeType)&&(identical(other.fileSizeBytes, _this.fileSizeBytes) || other.fileSizeBytes == _this.fileSizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Credential;
  return Object.hash(runtimeType,_this.id,_this.ownerId,_this.credentialType,_this.label,_this.storagePath,_this.downloadUrl,_this.status,_this.expiresAt,_this.uploadedAt,_this.verifiedAt,_this.verifiedBy,_this.mimeType,_this.fileSizeBytes);
}

@override
String toString() {
  final _this = this as Credential;
  return 'Credential(id: ${_this.id}, ownerId: ${_this.ownerId}, credentialType: ${_this.credentialType}, label: ${_this.label}, storagePath: ${_this.storagePath}, downloadUrl: ${_this.downloadUrl}, status: ${_this.status}, expiresAt: ${_this.expiresAt}, uploadedAt: ${_this.uploadedAt}, verifiedAt: ${_this.verifiedAt}, verifiedBy: ${_this.verifiedBy}, mimeType: ${_this.mimeType}, fileSizeBytes: ${_this.fileSizeBytes})';
}


}

/// @nodoc
abstract mixin class $CredentialCopyWith<$Res>  {
  factory $CredentialCopyWith(Credential value, $Res Function(Credential) _then) = _$CredentialCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, CredentialType credentialType, String label, String storagePath, String? downloadUrl, CredentialStatus status,@TimestampConverter() DateTime? expiresAt,@TimestampConverter() DateTime uploadedAt,@TimestampConverter() DateTime? verifiedAt, String? verifiedBy, String mimeType, int fileSizeBytes
});




}
/// @nodoc
class _$CredentialCopyWithImpl<$Res>
    implements $CredentialCopyWith<$Res> {
  _$CredentialCopyWithImpl(this._self, this._then);

  final Credential _self;
  final $Res Function(Credential) _then;

/// Create a copy of Credential
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? credentialType = null,Object? label = null,Object? storagePath = null,Object? downloadUrl = freezed,Object? status = null,Object? expiresAt = freezed,Object? uploadedAt = null,Object? verifiedAt = freezed,Object? verifiedBy = freezed,Object? mimeType = null,Object? fileSizeBytes = null,}) {
  return _then(Credential(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,credentialType: null == credentialType ? _self.credentialType : credentialType // ignore: cast_nullable_to_non_nullable
as CredentialType,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CredentialStatus,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,verifiedBy: freezed == verifiedBy ? _self.verifiedBy : verifiedBy // ignore: cast_nullable_to_non_nullable
as String?,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Credential].
extension CredentialPatterns on Credential {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Credential value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Credential() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Credential value)  $default,){
final _that = this;
switch (_that) {
case _Credential():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Credential value)?  $default,){
final _that = this;
switch (_that) {
case _Credential() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  CredentialType credentialType,  String label,  String storagePath,  String? downloadUrl,  CredentialStatus status, @TimestampConverter()  DateTime? expiresAt, @TimestampConverter()  DateTime uploadedAt, @TimestampConverter()  DateTime? verifiedAt,  String? verifiedBy,  String mimeType,  int fileSizeBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Credential() when $default != null:
return $default(_that.id,_that.ownerId,_that.credentialType,_that.label,_that.storagePath,_that.downloadUrl,_that.status,_that.expiresAt,_that.uploadedAt,_that.verifiedAt,_that.verifiedBy,_that.mimeType,_that.fileSizeBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  CredentialType credentialType,  String label,  String storagePath,  String? downloadUrl,  CredentialStatus status, @TimestampConverter()  DateTime? expiresAt, @TimestampConverter()  DateTime uploadedAt, @TimestampConverter()  DateTime? verifiedAt,  String? verifiedBy,  String mimeType,  int fileSizeBytes)  $default,) {final _that = this;
switch (_that) {
case _Credential():
return $default(_that.id,_that.ownerId,_that.credentialType,_that.label,_that.storagePath,_that.downloadUrl,_that.status,_that.expiresAt,_that.uploadedAt,_that.verifiedAt,_that.verifiedBy,_that.mimeType,_that.fileSizeBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  CredentialType credentialType,  String label,  String storagePath,  String? downloadUrl,  CredentialStatus status, @TimestampConverter()  DateTime? expiresAt, @TimestampConverter()  DateTime uploadedAt, @TimestampConverter()  DateTime? verifiedAt,  String? verifiedBy,  String mimeType,  int fileSizeBytes)?  $default,) {final _that = this;
switch (_that) {
case _Credential() when $default != null:
return $default(_that.id,_that.ownerId,_that.credentialType,_that.label,_that.storagePath,_that.downloadUrl,_that.status,_that.expiresAt,_that.uploadedAt,_that.verifiedAt,_that.verifiedBy,_that.mimeType,_that.fileSizeBytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Credential implements Credential {
  const _Credential({required this.id, required this.ownerId, required this.credentialType, required this.label, required this.storagePath, this.downloadUrl, this.status = CredentialStatus.uploaded, @TimestampConverter() this.expiresAt, @TimestampConverter() required this.uploadedAt, @TimestampConverter() this.verifiedAt, this.verifiedBy, required this.mimeType, this.fileSizeBytes = 0});
  factory _Credential.fromJson(Map<String, dynamic> json) => _$CredentialFromJson(json);

@override final  String id;
@override final  String ownerId;
@override final  CredentialType credentialType;
@override final  String label;
@override final  String storagePath;
@override final  String? downloadUrl;
@override@JsonKey() final  CredentialStatus status;
@override@TimestampConverter() final  DateTime? expiresAt;
@override@TimestampConverter() final  DateTime uploadedAt;
@override@TimestampConverter() final  DateTime? verifiedAt;
@override final  String? verifiedBy;
@override final  String mimeType;
@override@JsonKey() final  int fileSizeBytes;

/// Create a copy of Credential
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CredentialCopyWith<_Credential> get copyWith => __$CredentialCopyWithImpl<_Credential>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CredentialToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Credential&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.credentialType, credentialType) || other.credentialType == credentialType)&&(identical(other.label, label) || other.label == label)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.verifiedBy, verifiedBy) || other.verifiedBy == verifiedBy)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,ownerId,credentialType,label,storagePath,downloadUrl,status,expiresAt,uploadedAt,verifiedAt,verifiedBy,mimeType,fileSizeBytes);
}

@override
String toString() {
    return 'Credential(id: $id, ownerId: $ownerId, credentialType: $credentialType, label: $label, storagePath: $storagePath, downloadUrl: $downloadUrl, status: $status, expiresAt: $expiresAt, uploadedAt: $uploadedAt, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes)';
}


}

/// @nodoc
abstract mixin class _$CredentialCopyWith<$Res> implements $CredentialCopyWith<$Res> {
  factory _$CredentialCopyWith(_Credential value, $Res Function(_Credential) _then) = __$CredentialCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, CredentialType credentialType, String label, String storagePath, String? downloadUrl, CredentialStatus status,@TimestampConverter() DateTime? expiresAt,@TimestampConverter() DateTime uploadedAt,@TimestampConverter() DateTime? verifiedAt, String? verifiedBy, String mimeType, int fileSizeBytes
});




}
/// @nodoc
class __$CredentialCopyWithImpl<$Res>
    implements _$CredentialCopyWith<$Res> {
  __$CredentialCopyWithImpl(this._self, this._then);

  final _Credential _self;
  final $Res Function(_Credential) _then;

/// Create a copy of Credential
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? credentialType = null,Object? label = null,Object? storagePath = null,Object? downloadUrl = freezed,Object? status = null,Object? expiresAt = freezed,Object? uploadedAt = null,Object? verifiedAt = freezed,Object? verifiedBy = freezed,Object? mimeType = null,Object? fileSizeBytes = null,}) {
  return _then(_Credential(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,credentialType: null == credentialType ? _self.credentialType : credentialType // ignore: cast_nullable_to_non_nullable
as CredentialType,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CredentialStatus,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,verifiedBy: freezed == verifiedBy ? _self.verifiedBy : verifiedBy // ignore: cast_nullable_to_non_nullable
as String?,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
