// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutStatsModel {

 int get activeWorkouts; int get completedWorkouts; double get progressPercentage; int get currentStreak; int get weeklyWorkouts;
/// Create a copy of WorkoutStatsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutStatsModelCopyWith<WorkoutStatsModel> get copyWith => _$WorkoutStatsModelCopyWithImpl<WorkoutStatsModel>(this as WorkoutStatsModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutStatsModel&&(identical(other.activeWorkouts, activeWorkouts) || other.activeWorkouts == activeWorkouts)&&(identical(other.completedWorkouts, completedWorkouts) || other.completedWorkouts == completedWorkouts)&&(identical(other.progressPercentage, progressPercentage) || other.progressPercentage == progressPercentage)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.weeklyWorkouts, weeklyWorkouts) || other.weeklyWorkouts == weeklyWorkouts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeWorkouts,completedWorkouts,progressPercentage,currentStreak,weeklyWorkouts);

@override
String toString() {
  return 'WorkoutStatsModel(activeWorkouts: $activeWorkouts, completedWorkouts: $completedWorkouts, progressPercentage: $progressPercentage, currentStreak: $currentStreak, weeklyWorkouts: $weeklyWorkouts)';
}


}

/// @nodoc
abstract mixin class $WorkoutStatsModelCopyWith<$Res>  {
  factory $WorkoutStatsModelCopyWith(WorkoutStatsModel value, $Res Function(WorkoutStatsModel) _then) = _$WorkoutStatsModelCopyWithImpl;
@useResult
$Res call({
 int activeWorkouts, int completedWorkouts, double progressPercentage, int currentStreak, int weeklyWorkouts
});




}
/// @nodoc
class _$WorkoutStatsModelCopyWithImpl<$Res>
    implements $WorkoutStatsModelCopyWith<$Res> {
  _$WorkoutStatsModelCopyWithImpl(this._self, this._then);

  final WorkoutStatsModel _self;
  final $Res Function(WorkoutStatsModel) _then;

/// Create a copy of WorkoutStatsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeWorkouts = null,Object? completedWorkouts = null,Object? progressPercentage = null,Object? currentStreak = null,Object? weeklyWorkouts = null,}) {
  return _then(WorkoutStatsModel(
activeWorkouts: null == activeWorkouts ? _self.activeWorkouts : activeWorkouts // ignore: cast_nullable_to_non_nullable
as int,completedWorkouts: null == completedWorkouts ? _self.completedWorkouts : completedWorkouts // ignore: cast_nullable_to_non_nullable
as int,progressPercentage: null == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as double,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,weeklyWorkouts: null == weeklyWorkouts ? _self.weeklyWorkouts : weeklyWorkouts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutStatsModel].
extension WorkoutStatsModelPatterns on WorkoutStatsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
