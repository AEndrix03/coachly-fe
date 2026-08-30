// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_safety_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseSafetyModel {

 String? get spotterPolicy;@MapConverter() Map<String, String>? get notesI18n; Map<String, List<String>>? get notesListI18n;
/// Create a copy of ExerciseSafetyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseSafetyModelCopyWith<ExerciseSafetyModel> get copyWith => _$ExerciseSafetyModelCopyWithImpl<ExerciseSafetyModel>(this as ExerciseSafetyModel, _$identity);

  /// Serializes this ExerciseSafetyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseSafetyModel&&(identical(other.spotterPolicy, spotterPolicy) || other.spotterPolicy == spotterPolicy)&&const DeepCollectionEquality().equals(other.notesI18n, notesI18n)&&const DeepCollectionEquality().equals(other.notesListI18n, notesListI18n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spotterPolicy,const DeepCollectionEquality().hash(notesI18n),const DeepCollectionEquality().hash(notesListI18n));

@override
String toString() {
  return 'ExerciseSafetyModel(spotterPolicy: $spotterPolicy, notesI18n: $notesI18n, notesListI18n: $notesListI18n)';
}


}

/// @nodoc
abstract mixin class $ExerciseSafetyModelCopyWith<$Res>  {
  factory $ExerciseSafetyModelCopyWith(ExerciseSafetyModel value, $Res Function(ExerciseSafetyModel) _then) = _$ExerciseSafetyModelCopyWithImpl;
@useResult
$Res call({
 String? spotterPolicy,@MapConverter() Map<String, String>? notesI18n, Map<String, List<String>>? notesListI18n
});




}
/// @nodoc
class _$ExerciseSafetyModelCopyWithImpl<$Res>
    implements $ExerciseSafetyModelCopyWith<$Res> {
  _$ExerciseSafetyModelCopyWithImpl(this._self, this._then);

  final ExerciseSafetyModel _self;
  final $Res Function(ExerciseSafetyModel) _then;

/// Create a copy of ExerciseSafetyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spotterPolicy = freezed,Object? notesI18n = freezed,Object? notesListI18n = freezed,}) {
  return _then(_self.copyWith(
spotterPolicy: freezed == spotterPolicy ? _self.spotterPolicy : spotterPolicy // ignore: cast_nullable_to_non_nullable
as String?,notesI18n: freezed == notesI18n ? _self.notesI18n : notesI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,notesListI18n: freezed == notesListI18n ? _self.notesListI18n : notesListI18n // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseSafetyModel].
extension ExerciseSafetyModelPatterns on ExerciseSafetyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseSafetyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseSafetyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseSafetyModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseSafetyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseSafetyModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseSafetyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? spotterPolicy, @MapConverter()  Map<String, String>? notesI18n,  Map<String, List<String>>? notesListI18n)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseSafetyModel() when $default != null:
return $default(_that.spotterPolicy,_that.notesI18n,_that.notesListI18n);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? spotterPolicy, @MapConverter()  Map<String, String>? notesI18n,  Map<String, List<String>>? notesListI18n)  $default,) {final _that = this;
switch (_that) {
case _ExerciseSafetyModel():
return $default(_that.spotterPolicy,_that.notesI18n,_that.notesListI18n);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? spotterPolicy, @MapConverter()  Map<String, String>? notesI18n,  Map<String, List<String>>? notesListI18n)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseSafetyModel() when $default != null:
return $default(_that.spotterPolicy,_that.notesI18n,_that.notesListI18n);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseSafetyModel implements ExerciseSafetyModel {
  const _ExerciseSafetyModel({this.spotterPolicy = null, @MapConverter() final  Map<String, String>? notesI18n = null, final  Map<String, List<String>>? notesListI18n = null}): _notesI18n = notesI18n,_notesListI18n = notesListI18n;
  factory _ExerciseSafetyModel.fromJson(Map<String, dynamic> json) => _$ExerciseSafetyModelFromJson(json);

@override@JsonKey() final  String? spotterPolicy;
 final  Map<String, String>? _notesI18n;
@override@JsonKey()@MapConverter() Map<String, String>? get notesI18n {
  final value = _notesI18n;
  if (value == null) return null;
  if (_notesI18n is EqualUnmodifiableMapView) return _notesI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, List<String>>? _notesListI18n;
@override@JsonKey() Map<String, List<String>>? get notesListI18n {
  final value = _notesListI18n;
  if (value == null) return null;
  if (_notesListI18n is EqualUnmodifiableMapView) return _notesListI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ExerciseSafetyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseSafetyModelCopyWith<_ExerciseSafetyModel> get copyWith => __$ExerciseSafetyModelCopyWithImpl<_ExerciseSafetyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseSafetyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseSafetyModel&&(identical(other.spotterPolicy, spotterPolicy) || other.spotterPolicy == spotterPolicy)&&const DeepCollectionEquality().equals(other._notesI18n, _notesI18n)&&const DeepCollectionEquality().equals(other._notesListI18n, _notesListI18n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spotterPolicy,const DeepCollectionEquality().hash(_notesI18n),const DeepCollectionEquality().hash(_notesListI18n));

@override
String toString() {
  return 'ExerciseSafetyModel(spotterPolicy: $spotterPolicy, notesI18n: $notesI18n, notesListI18n: $notesListI18n)';
}


}

/// @nodoc
abstract mixin class _$ExerciseSafetyModelCopyWith<$Res> implements $ExerciseSafetyModelCopyWith<$Res> {
  factory _$ExerciseSafetyModelCopyWith(_ExerciseSafetyModel value, $Res Function(_ExerciseSafetyModel) _then) = __$ExerciseSafetyModelCopyWithImpl;
@override @useResult
$Res call({
 String? spotterPolicy,@MapConverter() Map<String, String>? notesI18n, Map<String, List<String>>? notesListI18n
});




}
/// @nodoc
class __$ExerciseSafetyModelCopyWithImpl<$Res>
    implements _$ExerciseSafetyModelCopyWith<$Res> {
  __$ExerciseSafetyModelCopyWithImpl(this._self, this._then);

  final _ExerciseSafetyModel _self;
  final $Res Function(_ExerciseSafetyModel) _then;

/// Create a copy of ExerciseSafetyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spotterPolicy = freezed,Object? notesI18n = freezed,Object? notesListI18n = freezed,}) {
  return _then(_ExerciseSafetyModel(
spotterPolicy: freezed == spotterPolicy ? _self.spotterPolicy : spotterPolicy // ignore: cast_nullable_to_non_nullable
as String?,notesI18n: freezed == notesI18n ? _self._notesI18n : notesI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,notesListI18n: freezed == notesListI18n ? _self._notesListI18n : notesListI18n // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,
  ));
}


}

// dart format on
