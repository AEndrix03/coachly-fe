// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutModel {

 String get id; Map<String, String> get titleI18n; Map<String, String> get descriptionI18n; String? get coachId; String? get coachName; double get progress; int get durationMinutes; String get goal; DateTime get lastUsed; List<TagDto> get muscleTags;// Changed to List<TagDto>
 int get sessionsCount; int get lastSessionDays; String get type; List<WorkoutExerciseModel> get workoutExercises; bool get active; bool get dirty; bool get delete;
/// Create a copy of WorkoutModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutModelCopyWith<WorkoutModel> get copyWith => _$WorkoutModelCopyWithImpl<WorkoutModel>(this as WorkoutModel, _$identity);

  /// Serializes this WorkoutModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.titleI18n, titleI18n)&&const DeepCollectionEquality().equals(other.descriptionI18n, descriptionI18n)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.coachName, coachName) || other.coachName == coachName)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.lastUsed, lastUsed) || other.lastUsed == lastUsed)&&const DeepCollectionEquality().equals(other.muscleTags, muscleTags)&&(identical(other.sessionsCount, sessionsCount) || other.sessionsCount == sessionsCount)&&(identical(other.lastSessionDays, lastSessionDays) || other.lastSessionDays == lastSessionDays)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.workoutExercises, workoutExercises)&&(identical(other.active, active) || other.active == active)&&(identical(other.dirty, dirty) || other.dirty == dirty)&&(identical(other.delete, delete) || other.delete == delete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(titleI18n),const DeepCollectionEquality().hash(descriptionI18n),coachId,coachName,progress,durationMinutes,goal,lastUsed,const DeepCollectionEquality().hash(muscleTags),sessionsCount,lastSessionDays,type,const DeepCollectionEquality().hash(workoutExercises),active,dirty,delete);

@override
String toString() {
  return 'WorkoutModel(id: $id, titleI18n: $titleI18n, descriptionI18n: $descriptionI18n, coachId: $coachId, coachName: $coachName, progress: $progress, durationMinutes: $durationMinutes, goal: $goal, lastUsed: $lastUsed, muscleTags: $muscleTags, sessionsCount: $sessionsCount, lastSessionDays: $lastSessionDays, type: $type, workoutExercises: $workoutExercises, active: $active, dirty: $dirty, delete: $delete)';
}


}

/// @nodoc
abstract mixin class $WorkoutModelCopyWith<$Res>  {
  factory $WorkoutModelCopyWith(WorkoutModel value, $Res Function(WorkoutModel) _then) = _$WorkoutModelCopyWithImpl;
@useResult
$Res call({
 String id, Map<String, String> titleI18n, Map<String, String> descriptionI18n, String? coachId, String? coachName, double progress, int durationMinutes, String goal, DateTime lastUsed, List<TagDto> muscleTags, int sessionsCount, int lastSessionDays, String type, List<WorkoutExerciseModel> workoutExercises, bool active, bool dirty, bool delete
});




}
/// @nodoc
class _$WorkoutModelCopyWithImpl<$Res>
    implements $WorkoutModelCopyWith<$Res> {
  _$WorkoutModelCopyWithImpl(this._self, this._then);

  final WorkoutModel _self;
  final $Res Function(WorkoutModel) _then;

/// Create a copy of WorkoutModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titleI18n = null,Object? descriptionI18n = null,Object? coachId = freezed,Object? coachName = freezed,Object? progress = null,Object? durationMinutes = null,Object? goal = null,Object? lastUsed = null,Object? muscleTags = null,Object? sessionsCount = null,Object? lastSessionDays = null,Object? type = null,Object? workoutExercises = null,Object? active = null,Object? dirty = null,Object? delete = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleI18n: null == titleI18n ? _self.titleI18n : titleI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self.descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,coachId: freezed == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String?,coachName: freezed == coachName ? _self.coachName : coachName // ignore: cast_nullable_to_non_nullable
as String?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,lastUsed: null == lastUsed ? _self.lastUsed : lastUsed // ignore: cast_nullable_to_non_nullable
as DateTime,muscleTags: null == muscleTags ? _self.muscleTags : muscleTags // ignore: cast_nullable_to_non_nullable
as List<TagDto>,sessionsCount: null == sessionsCount ? _self.sessionsCount : sessionsCount // ignore: cast_nullable_to_non_nullable
as int,lastSessionDays: null == lastSessionDays ? _self.lastSessionDays : lastSessionDays // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,workoutExercises: null == workoutExercises ? _self.workoutExercises : workoutExercises // ignore: cast_nullable_to_non_nullable
as List<WorkoutExerciseModel>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,dirty: null == dirty ? _self.dirty : dirty // ignore: cast_nullable_to_non_nullable
as bool,delete: null == delete ? _self.delete : delete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutModel].
extension WorkoutModelPatterns on WorkoutModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Map<String, String> titleI18n,  Map<String, String> descriptionI18n,  String? coachId,  String? coachName,  double progress,  int durationMinutes,  String goal,  DateTime lastUsed,  List<TagDto> muscleTags,  int sessionsCount,  int lastSessionDays,  String type,  List<WorkoutExerciseModel> workoutExercises,  bool active,  bool dirty,  bool delete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutModel() when $default != null:
return $default(_that.id,_that.titleI18n,_that.descriptionI18n,_that.coachId,_that.coachName,_that.progress,_that.durationMinutes,_that.goal,_that.lastUsed,_that.muscleTags,_that.sessionsCount,_that.lastSessionDays,_that.type,_that.workoutExercises,_that.active,_that.dirty,_that.delete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Map<String, String> titleI18n,  Map<String, String> descriptionI18n,  String? coachId,  String? coachName,  double progress,  int durationMinutes,  String goal,  DateTime lastUsed,  List<TagDto> muscleTags,  int sessionsCount,  int lastSessionDays,  String type,  List<WorkoutExerciseModel> workoutExercises,  bool active,  bool dirty,  bool delete)  $default,) {final _that = this;
switch (_that) {
case _WorkoutModel():
return $default(_that.id,_that.titleI18n,_that.descriptionI18n,_that.coachId,_that.coachName,_that.progress,_that.durationMinutes,_that.goal,_that.lastUsed,_that.muscleTags,_that.sessionsCount,_that.lastSessionDays,_that.type,_that.workoutExercises,_that.active,_that.dirty,_that.delete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Map<String, String> titleI18n,  Map<String, String> descriptionI18n,  String? coachId,  String? coachName,  double progress,  int durationMinutes,  String goal,  DateTime lastUsed,  List<TagDto> muscleTags,  int sessionsCount,  int lastSessionDays,  String type,  List<WorkoutExerciseModel> workoutExercises,  bool active,  bool dirty,  bool delete)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutModel() when $default != null:
return $default(_that.id,_that.titleI18n,_that.descriptionI18n,_that.coachId,_that.coachName,_that.progress,_that.durationMinutes,_that.goal,_that.lastUsed,_that.muscleTags,_that.sessionsCount,_that.lastSessionDays,_that.type,_that.workoutExercises,_that.active,_that.dirty,_that.delete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutModel implements WorkoutModel {
  const _WorkoutModel({required this.id, required final  Map<String, String> titleI18n, required final  Map<String, String> descriptionI18n, this.coachId, this.coachName, required this.progress, required this.durationMinutes, required this.goal, required this.lastUsed, final  List<TagDto> muscleTags = const [], required this.sessionsCount, required this.lastSessionDays, required this.type, final  List<WorkoutExerciseModel> workoutExercises = const [], this.active = true, this.dirty = false, this.delete = false}): _titleI18n = titleI18n,_descriptionI18n = descriptionI18n,_muscleTags = muscleTags,_workoutExercises = workoutExercises;
  factory _WorkoutModel.fromJson(Map<String, dynamic> json) => _$WorkoutModelFromJson(json);

@override final  String id;
 final  Map<String, String> _titleI18n;
@override Map<String, String> get titleI18n {
  if (_titleI18n is EqualUnmodifiableMapView) return _titleI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_titleI18n);
}

 final  Map<String, String> _descriptionI18n;
@override Map<String, String> get descriptionI18n {
  if (_descriptionI18n is EqualUnmodifiableMapView) return _descriptionI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_descriptionI18n);
}

@override final  String? coachId;
@override final  String? coachName;
@override final  double progress;
@override final  int durationMinutes;
@override final  String goal;
@override final  DateTime lastUsed;
 final  List<TagDto> _muscleTags;
@override@JsonKey() List<TagDto> get muscleTags {
  if (_muscleTags is EqualUnmodifiableListView) return _muscleTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_muscleTags);
}

// Changed to List<TagDto>
@override final  int sessionsCount;
@override final  int lastSessionDays;
@override final  String type;
 final  List<WorkoutExerciseModel> _workoutExercises;
@override@JsonKey() List<WorkoutExerciseModel> get workoutExercises {
  if (_workoutExercises is EqualUnmodifiableListView) return _workoutExercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workoutExercises);
}

@override@JsonKey() final  bool active;
@override@JsonKey() final  bool dirty;
@override@JsonKey() final  bool delete;

/// Create a copy of WorkoutModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutModelCopyWith<_WorkoutModel> get copyWith => __$WorkoutModelCopyWithImpl<_WorkoutModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._titleI18n, _titleI18n)&&const DeepCollectionEquality().equals(other._descriptionI18n, _descriptionI18n)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&(identical(other.coachName, coachName) || other.coachName == coachName)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.lastUsed, lastUsed) || other.lastUsed == lastUsed)&&const DeepCollectionEquality().equals(other._muscleTags, _muscleTags)&&(identical(other.sessionsCount, sessionsCount) || other.sessionsCount == sessionsCount)&&(identical(other.lastSessionDays, lastSessionDays) || other.lastSessionDays == lastSessionDays)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._workoutExercises, _workoutExercises)&&(identical(other.active, active) || other.active == active)&&(identical(other.dirty, dirty) || other.dirty == dirty)&&(identical(other.delete, delete) || other.delete == delete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_titleI18n),const DeepCollectionEquality().hash(_descriptionI18n),coachId,coachName,progress,durationMinutes,goal,lastUsed,const DeepCollectionEquality().hash(_muscleTags),sessionsCount,lastSessionDays,type,const DeepCollectionEquality().hash(_workoutExercises),active,dirty,delete);

@override
String toString() {
  return 'WorkoutModel(id: $id, titleI18n: $titleI18n, descriptionI18n: $descriptionI18n, coachId: $coachId, coachName: $coachName, progress: $progress, durationMinutes: $durationMinutes, goal: $goal, lastUsed: $lastUsed, muscleTags: $muscleTags, sessionsCount: $sessionsCount, lastSessionDays: $lastSessionDays, type: $type, workoutExercises: $workoutExercises, active: $active, dirty: $dirty, delete: $delete)';
}


}

/// @nodoc
abstract mixin class _$WorkoutModelCopyWith<$Res> implements $WorkoutModelCopyWith<$Res> {
  factory _$WorkoutModelCopyWith(_WorkoutModel value, $Res Function(_WorkoutModel) _then) = __$WorkoutModelCopyWithImpl;
@override @useResult
$Res call({
 String id, Map<String, String> titleI18n, Map<String, String> descriptionI18n, String? coachId, String? coachName, double progress, int durationMinutes, String goal, DateTime lastUsed, List<TagDto> muscleTags, int sessionsCount, int lastSessionDays, String type, List<WorkoutExerciseModel> workoutExercises, bool active, bool dirty, bool delete
});




}
/// @nodoc
class __$WorkoutModelCopyWithImpl<$Res>
    implements _$WorkoutModelCopyWith<$Res> {
  __$WorkoutModelCopyWithImpl(this._self, this._then);

  final _WorkoutModel _self;
  final $Res Function(_WorkoutModel) _then;

/// Create a copy of WorkoutModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titleI18n = null,Object? descriptionI18n = null,Object? coachId = freezed,Object? coachName = freezed,Object? progress = null,Object? durationMinutes = null,Object? goal = null,Object? lastUsed = null,Object? muscleTags = null,Object? sessionsCount = null,Object? lastSessionDays = null,Object? type = null,Object? workoutExercises = null,Object? active = null,Object? dirty = null,Object? delete = null,}) {
  return _then(_WorkoutModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleI18n: null == titleI18n ? _self._titleI18n : titleI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self._descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,coachId: freezed == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String?,coachName: freezed == coachName ? _self.coachName : coachName // ignore: cast_nullable_to_non_nullable
as String?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,lastUsed: null == lastUsed ? _self.lastUsed : lastUsed // ignore: cast_nullable_to_non_nullable
as DateTime,muscleTags: null == muscleTags ? _self._muscleTags : muscleTags // ignore: cast_nullable_to_non_nullable
as List<TagDto>,sessionsCount: null == sessionsCount ? _self.sessionsCount : sessionsCount // ignore: cast_nullable_to_non_nullable
as int,lastSessionDays: null == lastSessionDays ? _self.lastSessionDays : lastSessionDays // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,workoutExercises: null == workoutExercises ? _self._workoutExercises : workoutExercises // ignore: cast_nullable_to_non_nullable
as List<WorkoutExerciseModel>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,dirty: null == dirty ? _self.dirty : dirty // ignore: cast_nullable_to_non_nullable
as bool,delete: null == delete ? _self.delete : delete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
