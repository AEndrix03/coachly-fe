// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_movement_pattern_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseMovementPatternModel {

 String get id; String get movementPlane; String get movementPattern; String get powerGenerationLevel;
/// Create a copy of ExerciseMovementPatternModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseMovementPatternModelCopyWith<ExerciseMovementPatternModel> get copyWith => _$ExerciseMovementPatternModelCopyWithImpl<ExerciseMovementPatternModel>(this as ExerciseMovementPatternModel, _$identity);

  /// Serializes this ExerciseMovementPatternModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseMovementPatternModel&&(identical(other.id, id) || other.id == id)&&(identical(other.movementPlane, movementPlane) || other.movementPlane == movementPlane)&&(identical(other.movementPattern, movementPattern) || other.movementPattern == movementPattern)&&(identical(other.powerGenerationLevel, powerGenerationLevel) || other.powerGenerationLevel == powerGenerationLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,movementPlane,movementPattern,powerGenerationLevel);

@override
String toString() {
  return 'ExerciseMovementPatternModel(id: $id, movementPlane: $movementPlane, movementPattern: $movementPattern, powerGenerationLevel: $powerGenerationLevel)';
}


}

/// @nodoc
abstract mixin class $ExerciseMovementPatternModelCopyWith<$Res>  {
  factory $ExerciseMovementPatternModelCopyWith(ExerciseMovementPatternModel value, $Res Function(ExerciseMovementPatternModel) _then) = _$ExerciseMovementPatternModelCopyWithImpl;
@useResult
$Res call({
 String id, String movementPlane, String movementPattern, String powerGenerationLevel
});




}
/// @nodoc
class _$ExerciseMovementPatternModelCopyWithImpl<$Res>
    implements $ExerciseMovementPatternModelCopyWith<$Res> {
  _$ExerciseMovementPatternModelCopyWithImpl(this._self, this._then);

  final ExerciseMovementPatternModel _self;
  final $Res Function(ExerciseMovementPatternModel) _then;

/// Create a copy of ExerciseMovementPatternModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? movementPlane = null,Object? movementPattern = null,Object? powerGenerationLevel = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,movementPlane: null == movementPlane ? _self.movementPlane : movementPlane // ignore: cast_nullable_to_non_nullable
as String,movementPattern: null == movementPattern ? _self.movementPattern : movementPattern // ignore: cast_nullable_to_non_nullable
as String,powerGenerationLevel: null == powerGenerationLevel ? _self.powerGenerationLevel : powerGenerationLevel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseMovementPatternModel].
extension ExerciseMovementPatternModelPatterns on ExerciseMovementPatternModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseMovementPatternModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseMovementPatternModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseMovementPatternModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseMovementPatternModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseMovementPatternModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseMovementPatternModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String movementPlane,  String movementPattern,  String powerGenerationLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseMovementPatternModel() when $default != null:
return $default(_that.id,_that.movementPlane,_that.movementPattern,_that.powerGenerationLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String movementPlane,  String movementPattern,  String powerGenerationLevel)  $default,) {final _that = this;
switch (_that) {
case _ExerciseMovementPatternModel():
return $default(_that.id,_that.movementPlane,_that.movementPattern,_that.powerGenerationLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String movementPlane,  String movementPattern,  String powerGenerationLevel)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseMovementPatternModel() when $default != null:
return $default(_that.id,_that.movementPlane,_that.movementPattern,_that.powerGenerationLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseMovementPatternModel implements ExerciseMovementPatternModel {
  const _ExerciseMovementPatternModel({required this.id, required this.movementPlane, required this.movementPattern, required this.powerGenerationLevel});
  factory _ExerciseMovementPatternModel.fromJson(Map<String, dynamic> json) => _$ExerciseMovementPatternModelFromJson(json);

@override final  String id;
@override final  String movementPlane;
@override final  String movementPattern;
@override final  String powerGenerationLevel;

/// Create a copy of ExerciseMovementPatternModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseMovementPatternModelCopyWith<_ExerciseMovementPatternModel> get copyWith => __$ExerciseMovementPatternModelCopyWithImpl<_ExerciseMovementPatternModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseMovementPatternModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseMovementPatternModel&&(identical(other.id, id) || other.id == id)&&(identical(other.movementPlane, movementPlane) || other.movementPlane == movementPlane)&&(identical(other.movementPattern, movementPattern) || other.movementPattern == movementPattern)&&(identical(other.powerGenerationLevel, powerGenerationLevel) || other.powerGenerationLevel == powerGenerationLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,movementPlane,movementPattern,powerGenerationLevel);

@override
String toString() {
  return 'ExerciseMovementPatternModel(id: $id, movementPlane: $movementPlane, movementPattern: $movementPattern, powerGenerationLevel: $powerGenerationLevel)';
}


}

/// @nodoc
abstract mixin class _$ExerciseMovementPatternModelCopyWith<$Res> implements $ExerciseMovementPatternModelCopyWith<$Res> {
  factory _$ExerciseMovementPatternModelCopyWith(_ExerciseMovementPatternModel value, $Res Function(_ExerciseMovementPatternModel) _then) = __$ExerciseMovementPatternModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String movementPlane, String movementPattern, String powerGenerationLevel
});




}
/// @nodoc
class __$ExerciseMovementPatternModelCopyWithImpl<$Res>
    implements _$ExerciseMovementPatternModelCopyWith<$Res> {
  __$ExerciseMovementPatternModelCopyWithImpl(this._self, this._then);

  final _ExerciseMovementPatternModel _self;
  final $Res Function(_ExerciseMovementPatternModel) _then;

/// Create a copy of ExerciseMovementPatternModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? movementPlane = null,Object? movementPattern = null,Object? powerGenerationLevel = null,}) {
  return _then(_ExerciseMovementPatternModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,movementPlane: null == movementPlane ? _self.movementPlane : movementPlane // ignore: cast_nullable_to_non_nullable
as String,movementPattern: null == movementPattern ? _self.movementPattern : movementPattern // ignore: cast_nullable_to_non_nullable
as String,powerGenerationLevel: null == powerGenerationLevel ? _self.powerGenerationLevel : powerGenerationLevel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
