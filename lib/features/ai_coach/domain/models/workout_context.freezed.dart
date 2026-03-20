// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutContext {

 String get exerciseName; int get currentSet; int get totalSets; double get weightKg; int get targetReps; int? get completedReps; double? get fatigueIndex; List<double>? get recentWeights; DateTime get sessionStart; String? get workoutPlan;
/// Create a copy of WorkoutContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutContextCopyWith<WorkoutContext> get copyWith => _$WorkoutContextCopyWithImpl<WorkoutContext>(this as WorkoutContext, _$identity);

  /// Serializes this WorkoutContext to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutContext&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.currentSet, currentSet) || other.currentSet == currentSet)&&(identical(other.totalSets, totalSets) || other.totalSets == totalSets)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.targetReps, targetReps) || other.targetReps == targetReps)&&(identical(other.completedReps, completedReps) || other.completedReps == completedReps)&&(identical(other.fatigueIndex, fatigueIndex) || other.fatigueIndex == fatigueIndex)&&const DeepCollectionEquality().equals(other.recentWeights, recentWeights)&&(identical(other.sessionStart, sessionStart) || other.sessionStart == sessionStart)&&(identical(other.workoutPlan, workoutPlan) || other.workoutPlan == workoutPlan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exerciseName,currentSet,totalSets,weightKg,targetReps,completedReps,fatigueIndex,const DeepCollectionEquality().hash(recentWeights),sessionStart,workoutPlan);

@override
String toString() {
  return 'WorkoutContext(exerciseName: $exerciseName, currentSet: $currentSet, totalSets: $totalSets, weightKg: $weightKg, targetReps: $targetReps, completedReps: $completedReps, fatigueIndex: $fatigueIndex, recentWeights: $recentWeights, sessionStart: $sessionStart, workoutPlan: $workoutPlan)';
}


}

/// @nodoc
abstract mixin class $WorkoutContextCopyWith<$Res>  {
  factory $WorkoutContextCopyWith(WorkoutContext value, $Res Function(WorkoutContext) _then) = _$WorkoutContextCopyWithImpl;
@useResult
$Res call({
 String exerciseName, int currentSet, int totalSets, double weightKg, int targetReps, int? completedReps, double? fatigueIndex, List<double>? recentWeights, DateTime sessionStart, String? workoutPlan
});




}
/// @nodoc
class _$WorkoutContextCopyWithImpl<$Res>
    implements $WorkoutContextCopyWith<$Res> {
  _$WorkoutContextCopyWithImpl(this._self, this._then);

  final WorkoutContext _self;
  final $Res Function(WorkoutContext) _then;

/// Create a copy of WorkoutContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseName = null,Object? currentSet = null,Object? totalSets = null,Object? weightKg = null,Object? targetReps = null,Object? completedReps = freezed,Object? fatigueIndex = freezed,Object? recentWeights = freezed,Object? sessionStart = null,Object? workoutPlan = freezed,}) {
  return _then(_self.copyWith(
exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,currentSet: null == currentSet ? _self.currentSet : currentSet // ignore: cast_nullable_to_non_nullable
as int,totalSets: null == totalSets ? _self.totalSets : totalSets // ignore: cast_nullable_to_non_nullable
as int,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,targetReps: null == targetReps ? _self.targetReps : targetReps // ignore: cast_nullable_to_non_nullable
as int,completedReps: freezed == completedReps ? _self.completedReps : completedReps // ignore: cast_nullable_to_non_nullable
as int?,fatigueIndex: freezed == fatigueIndex ? _self.fatigueIndex : fatigueIndex // ignore: cast_nullable_to_non_nullable
as double?,recentWeights: freezed == recentWeights ? _self.recentWeights : recentWeights // ignore: cast_nullable_to_non_nullable
as List<double>?,sessionStart: null == sessionStart ? _self.sessionStart : sessionStart // ignore: cast_nullable_to_non_nullable
as DateTime,workoutPlan: freezed == workoutPlan ? _self.workoutPlan : workoutPlan // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutContext].
extension WorkoutContextPatterns on WorkoutContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutContext value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutContext value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseName,  int currentSet,  int totalSets,  double weightKg,  int targetReps,  int? completedReps,  double? fatigueIndex,  List<double>? recentWeights,  DateTime sessionStart)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutContext() when $default != null:
return $default(_that.exerciseName,_that.currentSet,_that.totalSets,_that.weightKg,_that.targetReps,_that.completedReps,_that.fatigueIndex,_that.recentWeights,_that.sessionStart);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseName,  int currentSet,  int totalSets,  double weightKg,  int targetReps,  int? completedReps,  double? fatigueIndex,  List<double>? recentWeights,  DateTime sessionStart)  $default,) {final _that = this;
switch (_that) {
case _WorkoutContext():
return $default(_that.exerciseName,_that.currentSet,_that.totalSets,_that.weightKg,_that.targetReps,_that.completedReps,_that.fatigueIndex,_that.recentWeights,_that.sessionStart);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseName,  int currentSet,  int totalSets,  double weightKg,  int targetReps,  int? completedReps,  double? fatigueIndex,  List<double>? recentWeights,  DateTime sessionStart)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutContext() when $default != null:
return $default(_that.exerciseName,_that.currentSet,_that.totalSets,_that.weightKg,_that.targetReps,_that.completedReps,_that.fatigueIndex,_that.recentWeights,_that.sessionStart);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutContext implements WorkoutContext {
  const _WorkoutContext({required this.exerciseName, required this.currentSet, required this.totalSets, required this.weightKg, required this.targetReps, this.completedReps, this.fatigueIndex, final  List<double>? recentWeights, required this.sessionStart, this.workoutPlan}): _recentWeights = recentWeights;
  factory _WorkoutContext.fromJson(Map<String, dynamic> json) => _$WorkoutContextFromJson(json);

@override final  String exerciseName;
@override final  int currentSet;
@override final  int totalSets;
@override final  double weightKg;
@override final  int targetReps;
@override final  int? completedReps;
@override final  double? fatigueIndex;
 final  List<double>? _recentWeights;
@override List<double>? get recentWeights {
  final value = _recentWeights;
  if (value == null) return null;
  if (_recentWeights is EqualUnmodifiableListView) return _recentWeights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime sessionStart;
@override final  String? workoutPlan;

/// Create a copy of WorkoutContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutContextCopyWith<_WorkoutContext> get copyWith => __$WorkoutContextCopyWithImpl<_WorkoutContext>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutContextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutContext&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.currentSet, currentSet) || other.currentSet == currentSet)&&(identical(other.totalSets, totalSets) || other.totalSets == totalSets)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.targetReps, targetReps) || other.targetReps == targetReps)&&(identical(other.completedReps, completedReps) || other.completedReps == completedReps)&&(identical(other.fatigueIndex, fatigueIndex) || other.fatigueIndex == fatigueIndex)&&const DeepCollectionEquality().equals(other._recentWeights, _recentWeights)&&(identical(other.sessionStart, sessionStart) || other.sessionStart == sessionStart)&&(identical(other.workoutPlan, workoutPlan) || other.workoutPlan == workoutPlan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exerciseName,currentSet,totalSets,weightKg,targetReps,completedReps,fatigueIndex,const DeepCollectionEquality().hash(_recentWeights),sessionStart,workoutPlan);

@override
String toString() {
  return 'WorkoutContext(exerciseName: $exerciseName, currentSet: $currentSet, totalSets: $totalSets, weightKg: $weightKg, targetReps: $targetReps, completedReps: $completedReps, fatigueIndex: $fatigueIndex, recentWeights: $recentWeights, sessionStart: $sessionStart, workoutPlan: $workoutPlan)';
}


}

/// @nodoc
abstract mixin class _$WorkoutContextCopyWith<$Res> implements $WorkoutContextCopyWith<$Res> {
  factory _$WorkoutContextCopyWith(_WorkoutContext value, $Res Function(_WorkoutContext) _then) = __$WorkoutContextCopyWithImpl;
@override @useResult
$Res call({
 String exerciseName, int currentSet, int totalSets, double weightKg, int targetReps, int? completedReps, double? fatigueIndex, List<double>? recentWeights, DateTime sessionStart, String? workoutPlan
});




}
/// @nodoc
class __$WorkoutContextCopyWithImpl<$Res>
    implements _$WorkoutContextCopyWith<$Res> {
  __$WorkoutContextCopyWithImpl(this._self, this._then);

  final _WorkoutContext _self;
  final $Res Function(_WorkoutContext) _then;

/// Create a copy of WorkoutContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseName = null,Object? currentSet = null,Object? totalSets = null,Object? weightKg = null,Object? targetReps = null,Object? completedReps = freezed,Object? fatigueIndex = freezed,Object? recentWeights = freezed,Object? sessionStart = null,Object? workoutPlan = freezed,}) {
  return _then(_WorkoutContext(
exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,currentSet: null == currentSet ? _self.currentSet : currentSet // ignore: cast_nullable_to_non_nullable
as int,totalSets: null == totalSets ? _self.totalSets : totalSets // ignore: cast_nullable_to_non_nullable
as int,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,targetReps: null == targetReps ? _self.targetReps : targetReps // ignore: cast_nullable_to_non_nullable
as int,completedReps: freezed == completedReps ? _self.completedReps : completedReps // ignore: cast_nullable_to_non_nullable
as int?,fatigueIndex: freezed == fatigueIndex ? _self.fatigueIndex : fatigueIndex // ignore: cast_nullable_to_non_nullable
as double?,recentWeights: freezed == recentWeights ? _self._recentWeights : recentWeights // ignore: cast_nullable_to_non_nullable
as List<double>?,sessionStart: null == sessionStart ? _self.sessionStart : sessionStart // ignore: cast_nullable_to_non_nullable
as DateTime,workoutPlan: freezed == workoutPlan ? _self.workoutPlan : workoutPlan // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
