// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insight_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InsightCard {

 String get icon; String get label; String get body;
/// Create a copy of InsightCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightCardCopyWith<InsightCard> get copyWith => _$InsightCardCopyWithImpl<InsightCard>(this as InsightCard, _$identity);

  /// Serializes this InsightCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightCard&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.label, label) || other.label == label)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,label,body);

@override
String toString() {
  return 'InsightCard(icon: $icon, label: $label, body: $body)';
}


}

/// @nodoc
abstract mixin class $InsightCardCopyWith<$Res>  {
  factory $InsightCardCopyWith(InsightCard value, $Res Function(InsightCard) _then) = _$InsightCardCopyWithImpl;
@useResult
$Res call({
 String icon, String label, String body
});




}
/// @nodoc
class _$InsightCardCopyWithImpl<$Res>
    implements $InsightCardCopyWith<$Res> {
  _$InsightCardCopyWithImpl(this._self, this._then);

  final InsightCard _self;
  final $Res Function(InsightCard) _then;

/// Create a copy of InsightCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? label = null,Object? body = null,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InsightCard].
extension InsightCardPatterns on InsightCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsightCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsightCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsightCard value)  $default,){
final _that = this;
switch (_that) {
case _InsightCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsightCard value)?  $default,){
final _that = this;
switch (_that) {
case _InsightCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String icon,  String label,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsightCard() when $default != null:
return $default(_that.icon,_that.label,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String icon,  String label,  String body)  $default,) {final _that = this;
switch (_that) {
case _InsightCard():
return $default(_that.icon,_that.label,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String icon,  String label,  String body)?  $default,) {final _that = this;
switch (_that) {
case _InsightCard() when $default != null:
return $default(_that.icon,_that.label,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InsightCard implements InsightCard {
  const _InsightCard({required this.icon, required this.label, required this.body});
  factory _InsightCard.fromJson(Map<String, dynamic> json) => _$InsightCardFromJson(json);

@override final  String icon;
@override final  String label;
@override final  String body;

/// Create a copy of InsightCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsightCardCopyWith<_InsightCard> get copyWith => __$InsightCardCopyWithImpl<_InsightCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InsightCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsightCard&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.label, label) || other.label == label)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,label,body);

@override
String toString() {
  return 'InsightCard(icon: $icon, label: $label, body: $body)';
}


}

/// @nodoc
abstract mixin class _$InsightCardCopyWith<$Res> implements $InsightCardCopyWith<$Res> {
  factory _$InsightCardCopyWith(_InsightCard value, $Res Function(_InsightCard) _then) = __$InsightCardCopyWithImpl;
@override @useResult
$Res call({
 String icon, String label, String body
});




}
/// @nodoc
class __$InsightCardCopyWithImpl<$Res>
    implements _$InsightCardCopyWith<$Res> {
  __$InsightCardCopyWithImpl(this._self, this._then);

  final _InsightCard _self;
  final $Res Function(_InsightCard) _then;

/// Create a copy of InsightCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? label = null,Object? body = null,}) {
  return _then(_InsightCard(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
