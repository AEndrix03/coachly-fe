// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_exercise_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutExerciseModel {

 String get id; ExerciseDetailModel get exercise; String get sets; String get rest; String get weight; double get progress;
/// Create a copy of WorkoutExerciseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutExerciseModelCopyWith<WorkoutExerciseModel> get copyWith => _$WorkoutExerciseModelCopyWithImpl<WorkoutExerciseModel>(this as WorkoutExerciseModel, _$identity);

  /// Serializes this WorkoutExerciseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutExerciseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.exercise, exercise) || other.exercise == exercise)&&(identical(other.sets, sets) || other.sets == sets)&&(identical(other.rest, rest) || other.rest == rest)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.progress, progress) || other.progress == progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,exercise,sets,rest,weight,progress);

@override
String toString() {
  return 'WorkoutExerciseModel(id: $id, exercise: $exercise, sets: $sets, rest: $rest, weight: $weight, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $WorkoutExerciseModelCopyWith<$Res>  {
  factory $WorkoutExerciseModelCopyWith(WorkoutExerciseModel value, $Res Function(WorkoutExerciseModel) _then) = _$WorkoutExerciseModelCopyWithImpl;
@useResult
$Res call({
 String id, ExerciseDetailModel exercise, String sets, String rest, String weight, double progress
});


$ExerciseDetailModelCopyWith<$Res> get exercise;

}
/// @nodoc
class _$WorkoutExerciseModelCopyWithImpl<$Res>
    implements $WorkoutExerciseModelCopyWith<$Res> {
  _$WorkoutExerciseModelCopyWithImpl(this._self, this._then);

  final WorkoutExerciseModel _self;
  final $Res Function(WorkoutExerciseModel) _then;

/// Create a copy of WorkoutExerciseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? exercise = null,Object? sets = null,Object? rest = null,Object? weight = null,Object? progress = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exercise: null == exercise ? _self.exercise : exercise // ignore: cast_nullable_to_non_nullable
as ExerciseDetailModel,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as String,rest: null == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of WorkoutExerciseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseDetailModelCopyWith<$Res> get exercise {
  
  return $ExerciseDetailModelCopyWith<$Res>(_self.exercise, (value) {
    return _then(_self.copyWith(exercise: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkoutExerciseModel].
extension WorkoutExerciseModelPatterns on WorkoutExerciseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutExerciseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutExerciseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutExerciseModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutExerciseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutExerciseModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutExerciseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ExerciseDetailModel exercise,  String sets,  String rest,  String weight,  double progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutExerciseModel() when $default != null:
return $default(_that.id,_that.exercise,_that.sets,_that.rest,_that.weight,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ExerciseDetailModel exercise,  String sets,  String rest,  String weight,  double progress)  $default,) {final _that = this;
switch (_that) {
case _WorkoutExerciseModel():
return $default(_that.id,_that.exercise,_that.sets,_that.rest,_that.weight,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ExerciseDetailModel exercise,  String sets,  String rest,  String weight,  double progress)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutExerciseModel() when $default != null:
return $default(_that.id,_that.exercise,_that.sets,_that.rest,_that.weight,_that.progress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutExerciseModel implements WorkoutExerciseModel {
  const _WorkoutExerciseModel({required this.id, required this.exercise, required this.sets, required this.rest, required this.weight, required this.progress});
  factory _WorkoutExerciseModel.fromJson(Map<String, dynamic> json) => _$WorkoutExerciseModelFromJson(json);

@override final  String id;
@override final  ExerciseDetailModel exercise;
@override final  String sets;
@override final  String rest;
@override final  String weight;
@override final  double progress;

/// Create a copy of WorkoutExerciseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutExerciseModelCopyWith<_WorkoutExerciseModel> get copyWith => __$WorkoutExerciseModelCopyWithImpl<_WorkoutExerciseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutExerciseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutExerciseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.exercise, exercise) || other.exercise == exercise)&&(identical(other.sets, sets) || other.sets == sets)&&(identical(other.rest, rest) || other.rest == rest)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.progress, progress) || other.progress == progress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,exercise,sets,rest,weight,progress);

@override
String toString() {
  return 'WorkoutExerciseModel(id: $id, exercise: $exercise, sets: $sets, rest: $rest, weight: $weight, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$WorkoutExerciseModelCopyWith<$Res> implements $WorkoutExerciseModelCopyWith<$Res> {
  factory _$WorkoutExerciseModelCopyWith(_WorkoutExerciseModel value, $Res Function(_WorkoutExerciseModel) _then) = __$WorkoutExerciseModelCopyWithImpl;
@override @useResult
$Res call({
 String id, ExerciseDetailModel exercise, String sets, String rest, String weight, double progress
});


@override $ExerciseDetailModelCopyWith<$Res> get exercise;

}
/// @nodoc
class __$WorkoutExerciseModelCopyWithImpl<$Res>
    implements _$WorkoutExerciseModelCopyWith<$Res> {
  __$WorkoutExerciseModelCopyWithImpl(this._self, this._then);

  final _WorkoutExerciseModel _self;
  final $Res Function(_WorkoutExerciseModel) _then;

/// Create a copy of WorkoutExerciseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? exercise = null,Object? sets = null,Object? rest = null,Object? weight = null,Object? progress = null,}) {
  return _then(_WorkoutExerciseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exercise: null == exercise ? _self.exercise : exercise // ignore: cast_nullable_to_non_nullable
as ExerciseDetailModel,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as String,rest: null == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of WorkoutExerciseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseDetailModelCopyWith<$Res> get exercise {
  
  return $ExerciseDetailModelCopyWith<$Res>(_self.exercise, (value) {
    return _then(_self.copyWith(exercise: value));
  });
}
}

// dart format on
