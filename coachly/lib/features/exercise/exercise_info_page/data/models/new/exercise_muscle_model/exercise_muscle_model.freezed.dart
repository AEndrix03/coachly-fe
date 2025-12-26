// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_muscle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseMuscleModel {

 MuscleModel get muscle; String get involvementLevel; ContractionTypeModel get primaryContractionType; int get activationPercentage;
/// Create a copy of ExerciseMuscleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseMuscleModelCopyWith<ExerciseMuscleModel> get copyWith => _$ExerciseMuscleModelCopyWithImpl<ExerciseMuscleModel>(this as ExerciseMuscleModel, _$identity);

  /// Serializes this ExerciseMuscleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseMuscleModel&&(identical(other.muscle, muscle) || other.muscle == muscle)&&(identical(other.involvementLevel, involvementLevel) || other.involvementLevel == involvementLevel)&&(identical(other.primaryContractionType, primaryContractionType) || other.primaryContractionType == primaryContractionType)&&(identical(other.activationPercentage, activationPercentage) || other.activationPercentage == activationPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,muscle,involvementLevel,primaryContractionType,activationPercentage);

@override
String toString() {
  return 'ExerciseMuscleModel(muscle: $muscle, involvementLevel: $involvementLevel, primaryContractionType: $primaryContractionType, activationPercentage: $activationPercentage)';
}


}

/// @nodoc
abstract mixin class $ExerciseMuscleModelCopyWith<$Res>  {
  factory $ExerciseMuscleModelCopyWith(ExerciseMuscleModel value, $Res Function(ExerciseMuscleModel) _then) = _$ExerciseMuscleModelCopyWithImpl;
@useResult
$Res call({
 MuscleModel muscle, String involvementLevel, ContractionTypeModel primaryContractionType, int activationPercentage
});


$MuscleModelCopyWith<$Res> get muscle;$ContractionTypeModelCopyWith<$Res> get primaryContractionType;

}
/// @nodoc
class _$ExerciseMuscleModelCopyWithImpl<$Res>
    implements $ExerciseMuscleModelCopyWith<$Res> {
  _$ExerciseMuscleModelCopyWithImpl(this._self, this._then);

  final ExerciseMuscleModel _self;
  final $Res Function(ExerciseMuscleModel) _then;

/// Create a copy of ExerciseMuscleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? muscle = null,Object? involvementLevel = null,Object? primaryContractionType = null,Object? activationPercentage = null,}) {
  return _then(_self.copyWith(
muscle: null == muscle ? _self.muscle : muscle // ignore: cast_nullable_to_non_nullable
as MuscleModel,involvementLevel: null == involvementLevel ? _self.involvementLevel : involvementLevel // ignore: cast_nullable_to_non_nullable
as String,primaryContractionType: null == primaryContractionType ? _self.primaryContractionType : primaryContractionType // ignore: cast_nullable_to_non_nullable
as ContractionTypeModel,activationPercentage: null == activationPercentage ? _self.activationPercentage : activationPercentage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ExerciseMuscleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MuscleModelCopyWith<$Res> get muscle {
  
  return $MuscleModelCopyWith<$Res>(_self.muscle, (value) {
    return _then(_self.copyWith(muscle: value));
  });
}/// Create a copy of ExerciseMuscleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContractionTypeModelCopyWith<$Res> get primaryContractionType {
  
  return $ContractionTypeModelCopyWith<$Res>(_self.primaryContractionType, (value) {
    return _then(_self.copyWith(primaryContractionType: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExerciseMuscleModel].
extension ExerciseMuscleModelPatterns on ExerciseMuscleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseMuscleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseMuscleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseMuscleModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseMuscleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseMuscleModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseMuscleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MuscleModel muscle,  String involvementLevel,  ContractionTypeModel primaryContractionType,  int activationPercentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseMuscleModel() when $default != null:
return $default(_that.muscle,_that.involvementLevel,_that.primaryContractionType,_that.activationPercentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MuscleModel muscle,  String involvementLevel,  ContractionTypeModel primaryContractionType,  int activationPercentage)  $default,) {final _that = this;
switch (_that) {
case _ExerciseMuscleModel():
return $default(_that.muscle,_that.involvementLevel,_that.primaryContractionType,_that.activationPercentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MuscleModel muscle,  String involvementLevel,  ContractionTypeModel primaryContractionType,  int activationPercentage)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseMuscleModel() when $default != null:
return $default(_that.muscle,_that.involvementLevel,_that.primaryContractionType,_that.activationPercentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseMuscleModel implements ExerciseMuscleModel {
  const _ExerciseMuscleModel({required this.muscle, required this.involvementLevel, required this.primaryContractionType, required this.activationPercentage});
  factory _ExerciseMuscleModel.fromJson(Map<String, dynamic> json) => _$ExerciseMuscleModelFromJson(json);

@override final  MuscleModel muscle;
@override final  String involvementLevel;
@override final  ContractionTypeModel primaryContractionType;
@override final  int activationPercentage;

/// Create a copy of ExerciseMuscleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseMuscleModelCopyWith<_ExerciseMuscleModel> get copyWith => __$ExerciseMuscleModelCopyWithImpl<_ExerciseMuscleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseMuscleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseMuscleModel&&(identical(other.muscle, muscle) || other.muscle == muscle)&&(identical(other.involvementLevel, involvementLevel) || other.involvementLevel == involvementLevel)&&(identical(other.primaryContractionType, primaryContractionType) || other.primaryContractionType == primaryContractionType)&&(identical(other.activationPercentage, activationPercentage) || other.activationPercentage == activationPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,muscle,involvementLevel,primaryContractionType,activationPercentage);

@override
String toString() {
  return 'ExerciseMuscleModel(muscle: $muscle, involvementLevel: $involvementLevel, primaryContractionType: $primaryContractionType, activationPercentage: $activationPercentage)';
}


}

/// @nodoc
abstract mixin class _$ExerciseMuscleModelCopyWith<$Res> implements $ExerciseMuscleModelCopyWith<$Res> {
  factory _$ExerciseMuscleModelCopyWith(_ExerciseMuscleModel value, $Res Function(_ExerciseMuscleModel) _then) = __$ExerciseMuscleModelCopyWithImpl;
@override @useResult
$Res call({
 MuscleModel muscle, String involvementLevel, ContractionTypeModel primaryContractionType, int activationPercentage
});


@override $MuscleModelCopyWith<$Res> get muscle;@override $ContractionTypeModelCopyWith<$Res> get primaryContractionType;

}
/// @nodoc
class __$ExerciseMuscleModelCopyWithImpl<$Res>
    implements _$ExerciseMuscleModelCopyWith<$Res> {
  __$ExerciseMuscleModelCopyWithImpl(this._self, this._then);

  final _ExerciseMuscleModel _self;
  final $Res Function(_ExerciseMuscleModel) _then;

/// Create a copy of ExerciseMuscleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? muscle = null,Object? involvementLevel = null,Object? primaryContractionType = null,Object? activationPercentage = null,}) {
  return _then(_ExerciseMuscleModel(
muscle: null == muscle ? _self.muscle : muscle // ignore: cast_nullable_to_non_nullable
as MuscleModel,involvementLevel: null == involvementLevel ? _self.involvementLevel : involvementLevel // ignore: cast_nullable_to_non_nullable
as String,primaryContractionType: null == primaryContractionType ? _self.primaryContractionType : primaryContractionType // ignore: cast_nullable_to_non_nullable
as ContractionTypeModel,activationPercentage: null == activationPercentage ? _self.activationPercentage : activationPercentage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ExerciseMuscleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MuscleModelCopyWith<$Res> get muscle {
  
  return $MuscleModelCopyWith<$Res>(_self.muscle, (value) {
    return _then(_self.copyWith(muscle: value));
  });
}/// Create a copy of ExerciseMuscleModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContractionTypeModelCopyWith<$Res> get primaryContractionType {
  
  return $ContractionTypeModelCopyWith<$Res>(_self.primaryContractionType, (value) {
    return _then(_self.copyWith(primaryContractionType: value));
  });
}
}

// dart format on
