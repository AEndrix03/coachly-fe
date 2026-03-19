// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoachMessage {

 String get id; String get text; MessageSender get sender; DateTime get timestamp; InsightCard? get insightCard;
/// Create a copy of CoachMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachMessageCopyWith<CoachMessage> get copyWith => _$CoachMessageCopyWithImpl<CoachMessage>(this as CoachMessage, _$identity);

  /// Serializes this CoachMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.insightCard, insightCard) || other.insightCard == insightCard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,sender,timestamp,insightCard);

@override
String toString() {
  return 'CoachMessage(id: $id, text: $text, sender: $sender, timestamp: $timestamp, insightCard: $insightCard)';
}


}

/// @nodoc
abstract mixin class $CoachMessageCopyWith<$Res>  {
  factory $CoachMessageCopyWith(CoachMessage value, $Res Function(CoachMessage) _then) = _$CoachMessageCopyWithImpl;
@useResult
$Res call({
 String id, String text, MessageSender sender, DateTime timestamp, InsightCard? insightCard
});


$InsightCardCopyWith<$Res>? get insightCard;

}
/// @nodoc
class _$CoachMessageCopyWithImpl<$Res>
    implements $CoachMessageCopyWith<$Res> {
  _$CoachMessageCopyWithImpl(this._self, this._then);

  final CoachMessage _self;
  final $Res Function(CoachMessage) _then;

/// Create a copy of CoachMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? sender = null,Object? timestamp = null,Object? insightCard = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as MessageSender,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,insightCard: freezed == insightCard ? _self.insightCard : insightCard // ignore: cast_nullable_to_non_nullable
as InsightCard?,
  ));
}
/// Create a copy of CoachMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InsightCardCopyWith<$Res>? get insightCard {
    if (_self.insightCard == null) {
    return null;
  }

  return $InsightCardCopyWith<$Res>(_self.insightCard!, (value) {
    return _then(_self.copyWith(insightCard: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoachMessage].
extension CoachMessagePatterns on CoachMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachMessage value)  $default,){
final _that = this;
switch (_that) {
case _CoachMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachMessage value)?  $default,){
final _that = this;
switch (_that) {
case _CoachMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  MessageSender sender,  DateTime timestamp,  InsightCard? insightCard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachMessage() when $default != null:
return $default(_that.id,_that.text,_that.sender,_that.timestamp,_that.insightCard);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  MessageSender sender,  DateTime timestamp,  InsightCard? insightCard)  $default,) {final _that = this;
switch (_that) {
case _CoachMessage():
return $default(_that.id,_that.text,_that.sender,_that.timestamp,_that.insightCard);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  MessageSender sender,  DateTime timestamp,  InsightCard? insightCard)?  $default,) {final _that = this;
switch (_that) {
case _CoachMessage() when $default != null:
return $default(_that.id,_that.text,_that.sender,_that.timestamp,_that.insightCard);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoachMessage implements CoachMessage {
  const _CoachMessage({required this.id, required this.text, required this.sender, required this.timestamp, this.insightCard});
  factory _CoachMessage.fromJson(Map<String, dynamic> json) => _$CoachMessageFromJson(json);

@override final  String id;
@override final  String text;
@override final  MessageSender sender;
@override final  DateTime timestamp;
@override final  InsightCard? insightCard;

/// Create a copy of CoachMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachMessageCopyWith<_CoachMessage> get copyWith => __$CoachMessageCopyWithImpl<_CoachMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.insightCard, insightCard) || other.insightCard == insightCard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,sender,timestamp,insightCard);

@override
String toString() {
  return 'CoachMessage(id: $id, text: $text, sender: $sender, timestamp: $timestamp, insightCard: $insightCard)';
}


}

/// @nodoc
abstract mixin class _$CoachMessageCopyWith<$Res> implements $CoachMessageCopyWith<$Res> {
  factory _$CoachMessageCopyWith(_CoachMessage value, $Res Function(_CoachMessage) _then) = __$CoachMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, MessageSender sender, DateTime timestamp, InsightCard? insightCard
});


@override $InsightCardCopyWith<$Res>? get insightCard;

}
/// @nodoc
class __$CoachMessageCopyWithImpl<$Res>
    implements _$CoachMessageCopyWith<$Res> {
  __$CoachMessageCopyWithImpl(this._self, this._then);

  final _CoachMessage _self;
  final $Res Function(_CoachMessage) _then;

/// Create a copy of CoachMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? sender = null,Object? timestamp = null,Object? insightCard = freezed,}) {
  return _then(_CoachMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as MessageSender,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,insightCard: freezed == insightCard ? _self.insightCard : insightCard // ignore: cast_nullable_to_non_nullable
as InsightCard?,
  ));
}

/// Create a copy of CoachMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InsightCardCopyWith<$Res>? get insightCard {
    if (_self.insightCard == null) {
    return null;
  }

  return $InsightCardCopyWith<$Res>(_self.insightCard!, (value) {
    return _then(_self.copyWith(insightCard: value));
  });
}
}

// dart format on
