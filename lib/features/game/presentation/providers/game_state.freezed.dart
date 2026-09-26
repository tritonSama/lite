// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Point {

 int get x; int get y;
/// Create a copy of Point
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointCopyWith<Point> get copyWith => _$PointCopyWithImpl<Point>(this as Point, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Point;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Point&&(identical(other.x, _this.x) || other.x == _this.x)&&(identical(other.y, _this.y) || other.y == _this.y));
}


@override
int get hashCode {
  final _this = this as Point;
  return Object.hash(runtimeType,_this.x,_this.y);
}

@override
String toString() {
  final _this = this as Point;
  return 'Point(x: ${_this.x}, y: ${_this.y})';
}


}

/// @nodoc
abstract mixin class $PointCopyWith<$Res>  {
  factory $PointCopyWith(Point value, $Res Function(Point) _then) = _$PointCopyWithImpl;
@useResult
$Res call({
 int x, int y
});




}
/// @nodoc
class _$PointCopyWithImpl<$Res>
    implements $PointCopyWith<$Res> {
  _$PointCopyWithImpl(this._self, this._then);

  final Point _self;
  final $Res Function(Point) _then;

/// Create a copy of Point
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,}) {
  return _then(Point(
null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as int,null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Point].
extension PointPatterns on Point {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Point value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Point() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Point value)  $default,){
final _that = this;
switch (_that) {
case _Point():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Point value)?  $default,){
final _that = this;
switch (_that) {
case _Point() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int x,  int y)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Point() when $default != null:
return $default(_that.x,_that.y);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int x,  int y)  $default,) {final _that = this;
switch (_that) {
case _Point():
return $default(_that.x,_that.y);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int x,  int y)?  $default,) {final _that = this;
switch (_that) {
case _Point() when $default != null:
return $default(_that.x,_that.y);case _:
  return null;

}
}

}

/// @nodoc


class _Point implements Point {
  const _Point(this.x, this.y);
  

@override final  int x;
@override final  int y;

/// Create a copy of Point
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointCopyWith<_Point> get copyWith => __$PointCopyWithImpl<_Point>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Point&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y));
}


@override
int get hashCode {
    return Object.hash(runtimeType,x,y);
}

@override
String toString() {
    return 'Point(x: $x, y: $y)';
}


}

/// @nodoc
abstract mixin class _$PointCopyWith<$Res> implements $PointCopyWith<$Res> {
  factory _$PointCopyWith(_Point value, $Res Function(_Point) _then) = __$PointCopyWithImpl;
@override @useResult
$Res call({
 int x, int y
});




}
/// @nodoc
class __$PointCopyWithImpl<$Res>
    implements _$PointCopyWith<$Res> {
  __$PointCopyWithImpl(this._self, this._then);

  final _Point _self;
  final $Res Function(_Point) _then;

/// Create a copy of Point
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,}) {
  return _then(_Point(
null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as int,null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Card {

 int get value;
/// Create a copy of Card
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardCopyWith<Card> get copyWith => _$CardCopyWithImpl<Card>(this as Card, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Card;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Card&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as Card;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as Card;
  return 'Card(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $CardCopyWith<$Res>  {
  factory $CardCopyWith(Card value, $Res Function(Card) _then) = _$CardCopyWithImpl;
@useResult
$Res call({
 int value
});




}
/// @nodoc
class _$CardCopyWithImpl<$Res>
    implements $CardCopyWith<$Res> {
  _$CardCopyWithImpl(this._self, this._then);

  final Card _self;
  final $Res Function(Card) _then;

/// Create a copy of Card
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(Card(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Card].
extension CardPatterns on Card {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Card value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Card() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Card value)  $default,){
final _that = this;
switch (_that) {
case _Card():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Card value)?  $default,){
final _that = this;
switch (_that) {
case _Card() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Card() when $default != null:
return $default(_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int value)  $default,) {final _that = this;
switch (_that) {
case _Card():
return $default(_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int value)?  $default,) {final _that = this;
switch (_that) {
case _Card() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _Card implements Card {
  const _Card(this.value);
  

@override final  int value;

/// Create a copy of Card
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardCopyWith<_Card> get copyWith => __$CardCopyWithImpl<_Card>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Card&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'Card(value: $value)';
}


}

/// @nodoc
abstract mixin class _$CardCopyWith<$Res> implements $CardCopyWith<$Res> {
  factory _$CardCopyWith(_Card value, $Res Function(_Card) _then) = __$CardCopyWithImpl;
@override @useResult
$Res call({
 int value
});




}
/// @nodoc
class __$CardCopyWithImpl<$Res>
    implements _$CardCopyWith<$Res> {
  __$CardCopyWithImpl(this._self, this._then);

  final _Card _self;
  final $Res Function(_Card) _then;

/// Create a copy of Card
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_Card(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PlayerState {

 PlayerId get id; int get hp; List<Card> get unplacedTraps; int get piecesToPlace; bool get flagPlaced; bool get setupComplete;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlayerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.hp, _this.hp) || other.hp == _this.hp)&&const DeepCollectionEquality().equals(other.unplacedTraps, _this.unplacedTraps)&&(identical(other.piecesToPlace, _this.piecesToPlace) || other.piecesToPlace == _this.piecesToPlace)&&(identical(other.flagPlaced, _this.flagPlaced) || other.flagPlaced == _this.flagPlaced)&&(identical(other.setupComplete, _this.setupComplete) || other.setupComplete == _this.setupComplete));
}


@override
int get hashCode {
  final _this = this as PlayerState;
  return Object.hash(runtimeType,_this.id,_this.hp,const DeepCollectionEquality().hash(_this.unplacedTraps),_this.piecesToPlace,_this.flagPlaced,_this.setupComplete);
}

@override
String toString() {
  final _this = this as PlayerState;
  return 'PlayerState(id: ${_this.id}, hp: ${_this.hp}, unplacedTraps: ${_this.unplacedTraps}, piecesToPlace: ${_this.piecesToPlace}, flagPlaced: ${_this.flagPlaced}, setupComplete: ${_this.setupComplete})';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 PlayerId id, int hp, List<Card> unplacedTraps, int piecesToPlace, bool flagPlaced, bool setupComplete
});




}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hp = null,Object? unplacedTraps = null,Object? piecesToPlace = null,Object? flagPlaced = null,Object? setupComplete = null,}) {
  return _then(PlayerState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as PlayerId,hp: null == hp ? _self.hp : hp // ignore: cast_nullable_to_non_nullable
as int,unplacedTraps: null == unplacedTraps ? _self.unplacedTraps : unplacedTraps // ignore: cast_nullable_to_non_nullable
as List<Card>,piecesToPlace: null == piecesToPlace ? _self.piecesToPlace : piecesToPlace // ignore: cast_nullable_to_non_nullable
as int,flagPlaced: null == flagPlaced ? _self.flagPlaced : flagPlaced // ignore: cast_nullable_to_non_nullable
as bool,setupComplete: null == setupComplete ? _self.setupComplete : setupComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlayerId id,  int hp,  List<Card> unplacedTraps,  int piecesToPlace,  bool flagPlaced,  bool setupComplete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.id,_that.hp,_that.unplacedTraps,_that.piecesToPlace,_that.flagPlaced,_that.setupComplete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlayerId id,  int hp,  List<Card> unplacedTraps,  int piecesToPlace,  bool flagPlaced,  bool setupComplete)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.id,_that.hp,_that.unplacedTraps,_that.piecesToPlace,_that.flagPlaced,_that.setupComplete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlayerId id,  int hp,  List<Card> unplacedTraps,  int piecesToPlace,  bool flagPlaced,  bool setupComplete)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.id,_that.hp,_that.unplacedTraps,_that.piecesToPlace,_that.flagPlaced,_that.setupComplete);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerState implements PlayerState {
  const _PlayerState({required this.id, this.hp = 20, required  List<Card> unplacedTraps, this.piecesToPlace = 7, this.flagPlaced = false, this.setupComplete = false}): _unplacedTraps = unplacedTraps;
  

@override final  PlayerId id;
@override@JsonKey() final  int hp;
 final  List<Card> _unplacedTraps;
@override List<Card> get unplacedTraps {
  if (_unplacedTraps is EqualUnmodifiableListView) return _unplacedTraps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unplacedTraps);
}

@override@JsonKey() final  int piecesToPlace;
@override@JsonKey() final  bool flagPlaced;
@override@JsonKey() final  bool setupComplete;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.id, id) || other.id == id)&&(identical(other.hp, hp) || other.hp == hp)&&const DeepCollectionEquality().equals(other.unplacedTraps, _unplacedTraps)&&(identical(other.piecesToPlace, piecesToPlace) || other.piecesToPlace == piecesToPlace)&&(identical(other.flagPlaced, flagPlaced) || other.flagPlaced == flagPlaced)&&(identical(other.setupComplete, setupComplete) || other.setupComplete == setupComplete));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,hp,const DeepCollectionEquality().hash(_unplacedTraps),piecesToPlace,flagPlaced,setupComplete);
}

@override
String toString() {
    return 'PlayerState(id: $id, hp: $hp, unplacedTraps: $unplacedTraps, piecesToPlace: $piecesToPlace, flagPlaced: $flagPlaced, setupComplete: $setupComplete)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 PlayerId id, int hp, List<Card> unplacedTraps, int piecesToPlace, bool flagPlaced, bool setupComplete
});




}
/// @nodoc
class __$PlayerStateCopyWithImpl<$Res>
    implements _$PlayerStateCopyWith<$Res> {
  __$PlayerStateCopyWithImpl(this._self, this._then);

  final _PlayerState _self;
  final $Res Function(_PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hp = null,Object? unplacedTraps = null,Object? piecesToPlace = null,Object? flagPlaced = null,Object? setupComplete = null,}) {
  return _then(_PlayerState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as PlayerId,hp: null == hp ? _self.hp : hp // ignore: cast_nullable_to_non_nullable
as int,unplacedTraps: null == unplacedTraps ? _self._unplacedTraps : unplacedTraps // ignore: cast_nullable_to_non_nullable
as List<Card>,piecesToPlace: null == piecesToPlace ? _self.piecesToPlace : piecesToPlace // ignore: cast_nullable_to_non_nullable
as int,flagPlaced: null == flagPlaced ? _self.flagPlaced : flagPlaced // ignore: cast_nullable_to_non_nullable
as bool,setupComplete: null == setupComplete ? _self.setupComplete : setupComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$GameState {

 GamePhase get phase; TurnPhase get turnPhase; PlayerId get currentPlayer; Map<Point, PlayerId> get pieces; Map<Point, MapEntry<PlayerId, Card>> get traps; Map<Point, PlayerId> get flags; Map<PlayerId, PlayerState> get players; int get movementPointsLeft; Point? get selectedPiece; Point? get pendingTrapLocation; Point? get pendingCombatLocation; List<String> get combatLogs; PlayerId? get winner;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GameState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.phase, _this.phase) || other.phase == _this.phase)&&(identical(other.turnPhase, _this.turnPhase) || other.turnPhase == _this.turnPhase)&&(identical(other.currentPlayer, _this.currentPlayer) || other.currentPlayer == _this.currentPlayer)&&const DeepCollectionEquality().equals(other.pieces, _this.pieces)&&const DeepCollectionEquality().equals(other.traps, _this.traps)&&const DeepCollectionEquality().equals(other.flags, _this.flags)&&const DeepCollectionEquality().equals(other.players, _this.players)&&(identical(other.movementPointsLeft, _this.movementPointsLeft) || other.movementPointsLeft == _this.movementPointsLeft)&&(identical(other.selectedPiece, _this.selectedPiece) || other.selectedPiece == _this.selectedPiece)&&(identical(other.pendingTrapLocation, _this.pendingTrapLocation) || other.pendingTrapLocation == _this.pendingTrapLocation)&&(identical(other.pendingCombatLocation, _this.pendingCombatLocation) || other.pendingCombatLocation == _this.pendingCombatLocation)&&const DeepCollectionEquality().equals(other.combatLogs, _this.combatLogs)&&(identical(other.winner, _this.winner) || other.winner == _this.winner));
}


@override
int get hashCode {
  final _this = this as GameState;
  return Object.hash(runtimeType,_this.phase,_this.turnPhase,_this.currentPlayer,const DeepCollectionEquality().hash(_this.pieces),const DeepCollectionEquality().hash(_this.traps),const DeepCollectionEquality().hash(_this.flags),const DeepCollectionEquality().hash(_this.players),_this.movementPointsLeft,_this.selectedPiece,_this.pendingTrapLocation,_this.pendingCombatLocation,const DeepCollectionEquality().hash(_this.combatLogs),_this.winner);
}

@override
String toString() {
  final _this = this as GameState;
  return 'GameState(phase: ${_this.phase}, turnPhase: ${_this.turnPhase}, currentPlayer: ${_this.currentPlayer}, pieces: ${_this.pieces}, traps: ${_this.traps}, flags: ${_this.flags}, players: ${_this.players}, movementPointsLeft: ${_this.movementPointsLeft}, selectedPiece: ${_this.selectedPiece}, pendingTrapLocation: ${_this.pendingTrapLocation}, pendingCombatLocation: ${_this.pendingCombatLocation}, combatLogs: ${_this.combatLogs}, winner: ${_this.winner})';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 GamePhase phase, TurnPhase turnPhase, PlayerId currentPlayer, Map<Point, PlayerId> pieces, Map<Point, MapEntry<PlayerId, Card>> traps, Map<Point, PlayerId> flags, Map<PlayerId, PlayerState> players, int movementPointsLeft, Point? selectedPiece, Point? pendingTrapLocation, Point? pendingCombatLocation, List<String> combatLogs, PlayerId? winner
});


$PointCopyWith<$Res>? get selectedPiece;$PointCopyWith<$Res>? get pendingTrapLocation;$PointCopyWith<$Res>? get pendingCombatLocation;

}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? turnPhase = null,Object? currentPlayer = null,Object? pieces = null,Object? traps = null,Object? flags = null,Object? players = null,Object? movementPointsLeft = null,Object? selectedPiece = freezed,Object? pendingTrapLocation = freezed,Object? pendingCombatLocation = freezed,Object? combatLogs = null,Object? winner = freezed,}) {
  return _then(GameState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GamePhase,turnPhase: null == turnPhase ? _self.turnPhase : turnPhase // ignore: cast_nullable_to_non_nullable
as TurnPhase,currentPlayer: null == currentPlayer ? _self.currentPlayer : currentPlayer // ignore: cast_nullable_to_non_nullable
as PlayerId,pieces: null == pieces ? _self.pieces : pieces // ignore: cast_nullable_to_non_nullable
as Map<Point, PlayerId>,traps: null == traps ? _self.traps : traps // ignore: cast_nullable_to_non_nullable
as Map<Point, MapEntry<PlayerId, Card>>,flags: null == flags ? _self.flags : flags // ignore: cast_nullable_to_non_nullable
as Map<Point, PlayerId>,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as Map<PlayerId, PlayerState>,movementPointsLeft: null == movementPointsLeft ? _self.movementPointsLeft : movementPointsLeft // ignore: cast_nullable_to_non_nullable
as int,selectedPiece: freezed == selectedPiece ? _self.selectedPiece : selectedPiece // ignore: cast_nullable_to_non_nullable
as Point?,pendingTrapLocation: freezed == pendingTrapLocation ? _self.pendingTrapLocation : pendingTrapLocation // ignore: cast_nullable_to_non_nullable
as Point?,pendingCombatLocation: freezed == pendingCombatLocation ? _self.pendingCombatLocation : pendingCombatLocation // ignore: cast_nullable_to_non_nullable
as Point?,combatLogs: null == combatLogs ? _self.combatLogs : combatLogs // ignore: cast_nullable_to_non_nullable
as List<String>,winner: freezed == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as PlayerId?,
  ));
}
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointCopyWith<$Res>? get selectedPiece {
    if (_self.selectedPiece == null) {
    return null;
  }

  return $PointCopyWith<$Res>(_self.selectedPiece!, (value) {
    return _then(_self.copyWith(selectedPiece: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointCopyWith<$Res>? get pendingTrapLocation {
    if (_self.pendingTrapLocation == null) {
    return null;
  }

  return $PointCopyWith<$Res>(_self.pendingTrapLocation!, (value) {
    return _then(_self.copyWith(pendingTrapLocation: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointCopyWith<$Res>? get pendingCombatLocation {
    if (_self.pendingCombatLocation == null) {
    return null;
  }

  return $PointCopyWith<$Res>(_self.pendingCombatLocation!, (value) {
    return _then(_self.copyWith(pendingCombatLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GamePhase phase,  TurnPhase turnPhase,  PlayerId currentPlayer,  Map<Point, PlayerId> pieces,  Map<Point, MapEntry<PlayerId, Card>> traps,  Map<Point, PlayerId> flags,  Map<PlayerId, PlayerState> players,  int movementPointsLeft,  Point? selectedPiece,  Point? pendingTrapLocation,  Point? pendingCombatLocation,  List<String> combatLogs,  PlayerId? winner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.phase,_that.turnPhase,_that.currentPlayer,_that.pieces,_that.traps,_that.flags,_that.players,_that.movementPointsLeft,_that.selectedPiece,_that.pendingTrapLocation,_that.pendingCombatLocation,_that.combatLogs,_that.winner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GamePhase phase,  TurnPhase turnPhase,  PlayerId currentPlayer,  Map<Point, PlayerId> pieces,  Map<Point, MapEntry<PlayerId, Card>> traps,  Map<Point, PlayerId> flags,  Map<PlayerId, PlayerState> players,  int movementPointsLeft,  Point? selectedPiece,  Point? pendingTrapLocation,  Point? pendingCombatLocation,  List<String> combatLogs,  PlayerId? winner)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.phase,_that.turnPhase,_that.currentPlayer,_that.pieces,_that.traps,_that.flags,_that.players,_that.movementPointsLeft,_that.selectedPiece,_that.pendingTrapLocation,_that.pendingCombatLocation,_that.combatLogs,_that.winner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GamePhase phase,  TurnPhase turnPhase,  PlayerId currentPlayer,  Map<Point, PlayerId> pieces,  Map<Point, MapEntry<PlayerId, Card>> traps,  Map<Point, PlayerId> flags,  Map<PlayerId, PlayerState> players,  int movementPointsLeft,  Point? selectedPiece,  Point? pendingTrapLocation,  Point? pendingCombatLocation,  List<String> combatLogs,  PlayerId? winner)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.phase,_that.turnPhase,_that.currentPlayer,_that.pieces,_that.traps,_that.flags,_that.players,_that.movementPointsLeft,_that.selectedPiece,_that.pendingTrapLocation,_that.pendingCombatLocation,_that.combatLogs,_that.winner);case _:
  return null;

}
}

}

/// @nodoc


class _GameState implements GameState {
  const _GameState({this.phase = GamePhase.setup, this.turnPhase = TurnPhase.rollForMovement, this.currentPlayer = PlayerId.p1,  Map<Point, PlayerId> pieces = const {},  Map<Point, MapEntry<PlayerId, Card>> traps = const {},  Map<Point, PlayerId> flags = const {}, required  Map<PlayerId, PlayerState> players, this.movementPointsLeft = 0, this.selectedPiece, this.pendingTrapLocation, this.pendingCombatLocation,  List<String> combatLogs = const [], this.winner}): _pieces = pieces,_traps = traps,_flags = flags,_players = players,_combatLogs = combatLogs;
  

@override@JsonKey() final  GamePhase phase;
@override@JsonKey() final  TurnPhase turnPhase;
@override@JsonKey() final  PlayerId currentPlayer;
 final  Map<Point, PlayerId> _pieces;
@override@JsonKey() Map<Point, PlayerId> get pieces {
  if (_pieces is EqualUnmodifiableMapView) return _pieces;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pieces);
}

 final  Map<Point, MapEntry<PlayerId, Card>> _traps;
@override@JsonKey() Map<Point, MapEntry<PlayerId, Card>> get traps {
  if (_traps is EqualUnmodifiableMapView) return _traps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_traps);
}

 final  Map<Point, PlayerId> _flags;
@override@JsonKey() Map<Point, PlayerId> get flags {
  if (_flags is EqualUnmodifiableMapView) return _flags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_flags);
}

 final  Map<PlayerId, PlayerState> _players;
@override Map<PlayerId, PlayerState> get players {
  if (_players is EqualUnmodifiableMapView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_players);
}

@override@JsonKey() final  int movementPointsLeft;
@override final  Point? selectedPiece;
@override final  Point? pendingTrapLocation;
@override final  Point? pendingCombatLocation;
 final  List<String> _combatLogs;
@override@JsonKey() List<String> get combatLogs {
  if (_combatLogs is EqualUnmodifiableListView) return _combatLogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_combatLogs);
}

@override final  PlayerId? winner;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.turnPhase, turnPhase) || other.turnPhase == turnPhase)&&(identical(other.currentPlayer, currentPlayer) || other.currentPlayer == currentPlayer)&&const DeepCollectionEquality().equals(other.pieces, _pieces)&&const DeepCollectionEquality().equals(other.traps, _traps)&&const DeepCollectionEquality().equals(other.flags, _flags)&&const DeepCollectionEquality().equals(other.players, _players)&&(identical(other.movementPointsLeft, movementPointsLeft) || other.movementPointsLeft == movementPointsLeft)&&(identical(other.selectedPiece, selectedPiece) || other.selectedPiece == selectedPiece)&&(identical(other.pendingTrapLocation, pendingTrapLocation) || other.pendingTrapLocation == pendingTrapLocation)&&(identical(other.pendingCombatLocation, pendingCombatLocation) || other.pendingCombatLocation == pendingCombatLocation)&&const DeepCollectionEquality().equals(other.combatLogs, _combatLogs)&&(identical(other.winner, winner) || other.winner == winner));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phase,turnPhase,currentPlayer,const DeepCollectionEquality().hash(_pieces),const DeepCollectionEquality().hash(_traps),const DeepCollectionEquality().hash(_flags),const DeepCollectionEquality().hash(_players),movementPointsLeft,selectedPiece,pendingTrapLocation,pendingCombatLocation,const DeepCollectionEquality().hash(_combatLogs),winner);
}

@override
String toString() {
    return 'GameState(phase: $phase, turnPhase: $turnPhase, currentPlayer: $currentPlayer, pieces: $pieces, traps: $traps, flags: $flags, players: $players, movementPointsLeft: $movementPointsLeft, selectedPiece: $selectedPiece, pendingTrapLocation: $pendingTrapLocation, pendingCombatLocation: $pendingCombatLocation, combatLogs: $combatLogs, winner: $winner)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 GamePhase phase, TurnPhase turnPhase, PlayerId currentPlayer, Map<Point, PlayerId> pieces, Map<Point, MapEntry<PlayerId, Card>> traps, Map<Point, PlayerId> flags, Map<PlayerId, PlayerState> players, int movementPointsLeft, Point? selectedPiece, Point? pendingTrapLocation, Point? pendingCombatLocation, List<String> combatLogs, PlayerId? winner
});


@override $PointCopyWith<$Res>? get selectedPiece;@override $PointCopyWith<$Res>? get pendingTrapLocation;@override $PointCopyWith<$Res>? get pendingCombatLocation;

}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? turnPhase = null,Object? currentPlayer = null,Object? pieces = null,Object? traps = null,Object? flags = null,Object? players = null,Object? movementPointsLeft = null,Object? selectedPiece = freezed,Object? pendingTrapLocation = freezed,Object? pendingCombatLocation = freezed,Object? combatLogs = null,Object? winner = freezed,}) {
  return _then(_GameState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GamePhase,turnPhase: null == turnPhase ? _self.turnPhase : turnPhase // ignore: cast_nullable_to_non_nullable
as TurnPhase,currentPlayer: null == currentPlayer ? _self.currentPlayer : currentPlayer // ignore: cast_nullable_to_non_nullable
as PlayerId,pieces: null == pieces ? _self._pieces : pieces // ignore: cast_nullable_to_non_nullable
as Map<Point, PlayerId>,traps: null == traps ? _self._traps : traps // ignore: cast_nullable_to_non_nullable
as Map<Point, MapEntry<PlayerId, Card>>,flags: null == flags ? _self._flags : flags // ignore: cast_nullable_to_non_nullable
as Map<Point, PlayerId>,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as Map<PlayerId, PlayerState>,movementPointsLeft: null == movementPointsLeft ? _self.movementPointsLeft : movementPointsLeft // ignore: cast_nullable_to_non_nullable
as int,selectedPiece: freezed == selectedPiece ? _self.selectedPiece : selectedPiece // ignore: cast_nullable_to_non_nullable
as Point?,pendingTrapLocation: freezed == pendingTrapLocation ? _self.pendingTrapLocation : pendingTrapLocation // ignore: cast_nullable_to_non_nullable
as Point?,pendingCombatLocation: freezed == pendingCombatLocation ? _self.pendingCombatLocation : pendingCombatLocation // ignore: cast_nullable_to_non_nullable
as Point?,combatLogs: null == combatLogs ? _self._combatLogs : combatLogs // ignore: cast_nullable_to_non_nullable
as List<String>,winner: freezed == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as PlayerId?,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointCopyWith<$Res>? get selectedPiece {
    if (_self.selectedPiece == null) {
    return null;
  }

  return $PointCopyWith<$Res>(_self.selectedPiece!, (value) {
    return _then(_self.copyWith(selectedPiece: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointCopyWith<$Res>? get pendingTrapLocation {
    if (_self.pendingTrapLocation == null) {
    return null;
  }

  return $PointCopyWith<$Res>(_self.pendingTrapLocation!, (value) {
    return _then(_self.copyWith(pendingTrapLocation: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointCopyWith<$Res>? get pendingCombatLocation {
    if (_self.pendingCombatLocation == null) {
    return null;
  }

  return $PointCopyWith<$Res>(_self.pendingCombatLocation!, (value) {
    return _then(_self.copyWith(pendingCombatLocation: value));
  });
}
}

// dart format on
