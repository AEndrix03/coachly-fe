// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutDetailModel {

 String get title; String get coachName; List<String> get muscleTags; double get progress; int get sessionsCount; int get lastSessionDays;
/// Create a copy of WorkoutDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutDetailModelCopyWith<WorkoutDetailModel> get copyWith => _$WorkoutDetailModelCopyWithImpl<WorkoutDetailModel>(this as WorkoutDetailModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutDetailModel&&(identical(other.title, title) || other.title == title)&&(identical(other.coachName, coachName) || other.coachName == coachName)&&const DeepCollectionEquality().equals(other.muscleTags, muscleTags)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.sessionsCount, sessionsCount) || other.sessionsCount == sessionsCount)&&(identical(other.lastSessionDays, lastSessionDays) || other.lastSessionDays == lastSessionDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,coachName,const DeepCollectionEquality().hash(muscleTags),progress,sessionsCount,lastSessionDays);

@override
String toString() {
  return 'WorkoutDetailModel(title: $title, coachName: $coachName, muscleTags: $muscleTags, progress: $progress, sessionsCount: $sessionsCount, lastSessionDays: $lastSessionDays)';
}


}

/// @nodoc
abstract mixin class $WorkoutDetailModelCopyWith<$Res>  {
  factory $WorkoutDetailModelCopyWith(WorkoutDetailModel value, $Res Function(WorkoutDetailModel) _then) = _$WorkoutDetailModelCopyWithImpl;
@useResult
$Res call({
 String title, String coachName, List<String> muscleTags, double progress, int sessionsCount, int lastSessionDays
});




}
/// @nodoc
class _$WorkoutDetailModelCopyWithImpl<$Res>
    implements $WorkoutDetailModelCopyWith<$Res> {
  _$WorkoutDetailModelCopyWithImpl(this._self, this._then);

  final WorkoutDetailModel _self;
  final $Res Function(WorkoutDetailModel) _then;

/// Create a copy of WorkoutDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? coachName = null,Object? muscleTags = null,Object? progress = null,Object? sessionsCount = null,Object? lastSessionDays = null,}) {
  return _then(WorkoutDetailModel(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coachName: null == coachName ? _self.coachName : coachName // ignore: cast_nullable_to_non_nullable
as String,muscleTags: null == muscleTags ? _self.muscleTags : muscleTags // ignore: cast_nullable_to_non_nullable
as List<String>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,sessionsCount: null == sessionsCount ? _self.sessionsCount : sessionsCount // ignore: cast_nullable_to_non_nullable
as int,lastSessionDays: null == lastSessionDays ? _self.lastSessionDays : lastSessionDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutDetailModel].
extension WorkoutDetailModelPatterns on WorkoutDetailModel {
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
