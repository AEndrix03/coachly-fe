// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_metric_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseMetricModel {

 String get id; int get popularityScore; int get usageCount;
/// Create a copy of ExerciseMetricModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseMetricModelCopyWith<ExerciseMetricModel> get copyWith => _$ExerciseMetricModelCopyWithImpl<ExerciseMetricModel>(this as ExerciseMetricModel, _$identity);

  /// Serializes this ExerciseMetricModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseMetricModel&&(identical(other.id, id) || other.id == id)&&(identical(other.popularityScore, popularityScore) || other.popularityScore == popularityScore)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,popularityScore,usageCount);

@override
String toString() {
  return 'ExerciseMetricModel(id: $id, popularityScore: $popularityScore, usageCount: $usageCount)';
}


}

/// @nodoc
abstract mixin class $ExerciseMetricModelCopyWith<$Res>  {
  factory $ExerciseMetricModelCopyWith(ExerciseMetricModel value, $Res Function(ExerciseMetricModel) _then) = _$ExerciseMetricModelCopyWithImpl;
@useResult
$Res call({
 String id, int popularityScore, int usageCount
});




}
/// @nodoc
class _$ExerciseMetricModelCopyWithImpl<$Res>
    implements $ExerciseMetricModelCopyWith<$Res> {
  _$ExerciseMetricModelCopyWithImpl(this._self, this._then);

  final ExerciseMetricModel _self;
  final $Res Function(ExerciseMetricModel) _then;

/// Create a copy of ExerciseMetricModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? popularityScore = null,Object? usageCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,popularityScore: null == popularityScore ? _self.popularityScore : popularityScore // ignore: cast_nullable_to_non_nullable
as int,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseMetricModel].
extension ExerciseMetricModelPatterns on ExerciseMetricModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseMetricModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseMetricModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseMetricModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseMetricModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseMetricModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseMetricModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int popularityScore,  int usageCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseMetricModel() when $default != null:
return $default(_that.id,_that.popularityScore,_that.usageCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int popularityScore,  int usageCount)  $default,) {final _that = this;
switch (_that) {
case _ExerciseMetricModel():
return $default(_that.id,_that.popularityScore,_that.usageCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int popularityScore,  int usageCount)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseMetricModel() when $default != null:
return $default(_that.id,_that.popularityScore,_that.usageCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseMetricModel implements ExerciseMetricModel {
  const _ExerciseMetricModel({required this.id, required this.popularityScore, required this.usageCount});
  factory _ExerciseMetricModel.fromJson(Map<String, dynamic> json) => _$ExerciseMetricModelFromJson(json);

@override final  String id;
@override final  int popularityScore;
@override final  int usageCount;

/// Create a copy of ExerciseMetricModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseMetricModelCopyWith<_ExerciseMetricModel> get copyWith => __$ExerciseMetricModelCopyWithImpl<_ExerciseMetricModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseMetricModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseMetricModel&&(identical(other.id, id) || other.id == id)&&(identical(other.popularityScore, popularityScore) || other.popularityScore == popularityScore)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,popularityScore,usageCount);

@override
String toString() {
  return 'ExerciseMetricModel(id: $id, popularityScore: $popularityScore, usageCount: $usageCount)';
}


}

/// @nodoc
abstract mixin class _$ExerciseMetricModelCopyWith<$Res> implements $ExerciseMetricModelCopyWith<$Res> {
  factory _$ExerciseMetricModelCopyWith(_ExerciseMetricModel value, $Res Function(_ExerciseMetricModel) _then) = __$ExerciseMetricModelCopyWithImpl;
@override @useResult
$Res call({
 String id, int popularityScore, int usageCount
});




}
/// @nodoc
class __$ExerciseMetricModelCopyWithImpl<$Res>
    implements _$ExerciseMetricModelCopyWith<$Res> {
  __$ExerciseMetricModelCopyWithImpl(this._self, this._then);

  final _ExerciseMetricModel _self;
  final $Res Function(_ExerciseMetricModel) _then;

/// Create a copy of ExerciseMetricModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? popularityScore = null,Object? usageCount = null,}) {
  return _then(_ExerciseMetricModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,popularityScore: null == popularityScore ? _self.popularityScore : popularityScore // ignore: cast_nullable_to_non_nullable
as int,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
