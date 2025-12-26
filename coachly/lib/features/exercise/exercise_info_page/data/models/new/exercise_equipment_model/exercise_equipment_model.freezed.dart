// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_equipment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseEquipmentModel {

 EquipmentModel get equipment; bool get isRequired; bool get isPrimary; int get quantityNeeded;
/// Create a copy of ExerciseEquipmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseEquipmentModelCopyWith<ExerciseEquipmentModel> get copyWith => _$ExerciseEquipmentModelCopyWithImpl<ExerciseEquipmentModel>(this as ExerciseEquipmentModel, _$identity);

  /// Serializes this ExerciseEquipmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseEquipmentModel&&(identical(other.equipment, equipment) || other.equipment == equipment)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.quantityNeeded, quantityNeeded) || other.quantityNeeded == quantityNeeded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,equipment,isRequired,isPrimary,quantityNeeded);

@override
String toString() {
  return 'ExerciseEquipmentModel(equipment: $equipment, isRequired: $isRequired, isPrimary: $isPrimary, quantityNeeded: $quantityNeeded)';
}


}

/// @nodoc
abstract mixin class $ExerciseEquipmentModelCopyWith<$Res>  {
  factory $ExerciseEquipmentModelCopyWith(ExerciseEquipmentModel value, $Res Function(ExerciseEquipmentModel) _then) = _$ExerciseEquipmentModelCopyWithImpl;
@useResult
$Res call({
 EquipmentModel equipment, bool isRequired, bool isPrimary, int quantityNeeded
});


$EquipmentModelCopyWith<$Res> get equipment;

}
/// @nodoc
class _$ExerciseEquipmentModelCopyWithImpl<$Res>
    implements $ExerciseEquipmentModelCopyWith<$Res> {
  _$ExerciseEquipmentModelCopyWithImpl(this._self, this._then);

  final ExerciseEquipmentModel _self;
  final $Res Function(ExerciseEquipmentModel) _then;

/// Create a copy of ExerciseEquipmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? equipment = null,Object? isRequired = null,Object? isPrimary = null,Object? quantityNeeded = null,}) {
  return _then(_self.copyWith(
equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as EquipmentModel,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,quantityNeeded: null == quantityNeeded ? _self.quantityNeeded : quantityNeeded // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ExerciseEquipmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EquipmentModelCopyWith<$Res> get equipment {
  
  return $EquipmentModelCopyWith<$Res>(_self.equipment, (value) {
    return _then(_self.copyWith(equipment: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExerciseEquipmentModel].
extension ExerciseEquipmentModelPatterns on ExerciseEquipmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseEquipmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseEquipmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseEquipmentModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseEquipmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseEquipmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseEquipmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EquipmentModel equipment,  bool isRequired,  bool isPrimary,  int quantityNeeded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseEquipmentModel() when $default != null:
return $default(_that.equipment,_that.isRequired,_that.isPrimary,_that.quantityNeeded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EquipmentModel equipment,  bool isRequired,  bool isPrimary,  int quantityNeeded)  $default,) {final _that = this;
switch (_that) {
case _ExerciseEquipmentModel():
return $default(_that.equipment,_that.isRequired,_that.isPrimary,_that.quantityNeeded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EquipmentModel equipment,  bool isRequired,  bool isPrimary,  int quantityNeeded)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseEquipmentModel() when $default != null:
return $default(_that.equipment,_that.isRequired,_that.isPrimary,_that.quantityNeeded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseEquipmentModel implements ExerciseEquipmentModel {
  const _ExerciseEquipmentModel({required this.equipment, required this.isRequired, required this.isPrimary, required this.quantityNeeded});
  factory _ExerciseEquipmentModel.fromJson(Map<String, dynamic> json) => _$ExerciseEquipmentModelFromJson(json);

@override final  EquipmentModel equipment;
@override final  bool isRequired;
@override final  bool isPrimary;
@override final  int quantityNeeded;

/// Create a copy of ExerciseEquipmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseEquipmentModelCopyWith<_ExerciseEquipmentModel> get copyWith => __$ExerciseEquipmentModelCopyWithImpl<_ExerciseEquipmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseEquipmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseEquipmentModel&&(identical(other.equipment, equipment) || other.equipment == equipment)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.quantityNeeded, quantityNeeded) || other.quantityNeeded == quantityNeeded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,equipment,isRequired,isPrimary,quantityNeeded);

@override
String toString() {
  return 'ExerciseEquipmentModel(equipment: $equipment, isRequired: $isRequired, isPrimary: $isPrimary, quantityNeeded: $quantityNeeded)';
}


}

/// @nodoc
abstract mixin class _$ExerciseEquipmentModelCopyWith<$Res> implements $ExerciseEquipmentModelCopyWith<$Res> {
  factory _$ExerciseEquipmentModelCopyWith(_ExerciseEquipmentModel value, $Res Function(_ExerciseEquipmentModel) _then) = __$ExerciseEquipmentModelCopyWithImpl;
@override @useResult
$Res call({
 EquipmentModel equipment, bool isRequired, bool isPrimary, int quantityNeeded
});


@override $EquipmentModelCopyWith<$Res> get equipment;

}
/// @nodoc
class __$ExerciseEquipmentModelCopyWithImpl<$Res>
    implements _$ExerciseEquipmentModelCopyWith<$Res> {
  __$ExerciseEquipmentModelCopyWithImpl(this._self, this._then);

  final _ExerciseEquipmentModel _self;
  final $Res Function(_ExerciseEquipmentModel) _then;

/// Create a copy of ExerciseEquipmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? equipment = null,Object? isRequired = null,Object? isPrimary = null,Object? quantityNeeded = null,}) {
  return _then(_ExerciseEquipmentModel(
equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as EquipmentModel,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,quantityNeeded: null == quantityNeeded ? _self.quantityNeeded : quantityNeeded // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ExerciseEquipmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EquipmentModelCopyWith<$Res> get equipment {
  
  return $EquipmentModelCopyWith<$Res>(_self.equipment, (value) {
    return _then(_self.copyWith(equipment: value));
  });
}
}

// dart format on
