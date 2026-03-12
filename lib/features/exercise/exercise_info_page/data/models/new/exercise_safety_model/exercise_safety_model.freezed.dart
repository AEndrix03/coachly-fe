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

 String get id; String get overallRiskLevel; bool get spotterRequired; Map<String, String> get safetyNotesI18n;
/// Create a copy of ExerciseSafetyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseSafetyModelCopyWith<ExerciseSafetyModel> get copyWith => _$ExerciseSafetyModelCopyWithImpl<ExerciseSafetyModel>(this as ExerciseSafetyModel, _$identity);

  /// Serializes this ExerciseSafetyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseSafetyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.overallRiskLevel, overallRiskLevel) || other.overallRiskLevel == overallRiskLevel)&&(identical(other.spotterRequired, spotterRequired) || other.spotterRequired == spotterRequired)&&const DeepCollectionEquality().equals(other.safetyNotesI18n, safetyNotesI18n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,overallRiskLevel,spotterRequired,const DeepCollectionEquality().hash(safetyNotesI18n));

@override
String toString() {
  return 'ExerciseSafetyModel(id: $id, overallRiskLevel: $overallRiskLevel, spotterRequired: $spotterRequired, safetyNotesI18n: $safetyNotesI18n)';
}


}

/// @nodoc
abstract mixin class $ExerciseSafetyModelCopyWith<$Res>  {
  factory $ExerciseSafetyModelCopyWith(ExerciseSafetyModel value, $Res Function(ExerciseSafetyModel) _then) = _$ExerciseSafetyModelCopyWithImpl;
@useResult
$Res call({
 String id, String overallRiskLevel, bool spotterRequired, Map<String, String> safetyNotesI18n
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? overallRiskLevel = null,Object? spotterRequired = null,Object? safetyNotesI18n = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,overallRiskLevel: null == overallRiskLevel ? _self.overallRiskLevel : overallRiskLevel // ignore: cast_nullable_to_non_nullable
as String,spotterRequired: null == spotterRequired ? _self.spotterRequired : spotterRequired // ignore: cast_nullable_to_non_nullable
as bool,safetyNotesI18n: null == safetyNotesI18n ? _self.safetyNotesI18n : safetyNotesI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String overallRiskLevel,  bool spotterRequired,  Map<String, String> safetyNotesI18n)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseSafetyModel() when $default != null:
return $default(_that.id,_that.overallRiskLevel,_that.spotterRequired,_that.safetyNotesI18n);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String overallRiskLevel,  bool spotterRequired,  Map<String, String> safetyNotesI18n)  $default,) {final _that = this;
switch (_that) {
case _ExerciseSafetyModel():
return $default(_that.id,_that.overallRiskLevel,_that.spotterRequired,_that.safetyNotesI18n);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String overallRiskLevel,  bool spotterRequired,  Map<String, String> safetyNotesI18n)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseSafetyModel() when $default != null:
return $default(_that.id,_that.overallRiskLevel,_that.spotterRequired,_that.safetyNotesI18n);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseSafetyModel implements ExerciseSafetyModel {
  const _ExerciseSafetyModel({required this.id, required this.overallRiskLevel, required this.spotterRequired, required final  Map<String, String> safetyNotesI18n}): _safetyNotesI18n = safetyNotesI18n;
  factory _ExerciseSafetyModel.fromJson(Map<String, dynamic> json) => _$ExerciseSafetyModelFromJson(json);

@override final  String id;
@override final  String overallRiskLevel;
@override final  bool spotterRequired;
 final  Map<String, String> _safetyNotesI18n;
@override Map<String, String> get safetyNotesI18n {
  if (_safetyNotesI18n is EqualUnmodifiableMapView) return _safetyNotesI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_safetyNotesI18n);
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseSafetyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.overallRiskLevel, overallRiskLevel) || other.overallRiskLevel == overallRiskLevel)&&(identical(other.spotterRequired, spotterRequired) || other.spotterRequired == spotterRequired)&&const DeepCollectionEquality().equals(other._safetyNotesI18n, _safetyNotesI18n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,overallRiskLevel,spotterRequired,const DeepCollectionEquality().hash(_safetyNotesI18n));

@override
String toString() {
  return 'ExerciseSafetyModel(id: $id, overallRiskLevel: $overallRiskLevel, spotterRequired: $spotterRequired, safetyNotesI18n: $safetyNotesI18n)';
}


}

/// @nodoc
abstract mixin class _$ExerciseSafetyModelCopyWith<$Res> implements $ExerciseSafetyModelCopyWith<$Res> {
  factory _$ExerciseSafetyModelCopyWith(_ExerciseSafetyModel value, $Res Function(_ExerciseSafetyModel) _then) = __$ExerciseSafetyModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String overallRiskLevel, bool spotterRequired, Map<String, String> safetyNotesI18n
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? overallRiskLevel = null,Object? spotterRequired = null,Object? safetyNotesI18n = null,}) {
  return _then(_ExerciseSafetyModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,overallRiskLevel: null == overallRiskLevel ? _self.overallRiskLevel : overallRiskLevel // ignore: cast_nullable_to_non_nullable
as String,spotterRequired: null == spotterRequired ? _self.spotterRequired : spotterRequired // ignore: cast_nullable_to_non_nullable
as bool,safetyNotesI18n: null == safetyNotesI18n ? _self._safetyNotesI18n : safetyNotesI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
