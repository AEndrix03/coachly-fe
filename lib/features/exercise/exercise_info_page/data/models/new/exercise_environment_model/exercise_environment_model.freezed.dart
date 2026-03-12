// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_environment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseEnvironmentModel {

 String get id; bool get canDoAtHome; bool get canDoInGym; bool get equipmentSetupRequired;
/// Create a copy of ExerciseEnvironmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseEnvironmentModelCopyWith<ExerciseEnvironmentModel> get copyWith => _$ExerciseEnvironmentModelCopyWithImpl<ExerciseEnvironmentModel>(this as ExerciseEnvironmentModel, _$identity);

  /// Serializes this ExerciseEnvironmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseEnvironmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.canDoAtHome, canDoAtHome) || other.canDoAtHome == canDoAtHome)&&(identical(other.canDoInGym, canDoInGym) || other.canDoInGym == canDoInGym)&&(identical(other.equipmentSetupRequired, equipmentSetupRequired) || other.equipmentSetupRequired == equipmentSetupRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,canDoAtHome,canDoInGym,equipmentSetupRequired);

@override
String toString() {
  return 'ExerciseEnvironmentModel(id: $id, canDoAtHome: $canDoAtHome, canDoInGym: $canDoInGym, equipmentSetupRequired: $equipmentSetupRequired)';
}


}

/// @nodoc
abstract mixin class $ExerciseEnvironmentModelCopyWith<$Res>  {
  factory $ExerciseEnvironmentModelCopyWith(ExerciseEnvironmentModel value, $Res Function(ExerciseEnvironmentModel) _then) = _$ExerciseEnvironmentModelCopyWithImpl;
@useResult
$Res call({
 String id, bool canDoAtHome, bool canDoInGym, bool equipmentSetupRequired
});




}
/// @nodoc
class _$ExerciseEnvironmentModelCopyWithImpl<$Res>
    implements $ExerciseEnvironmentModelCopyWith<$Res> {
  _$ExerciseEnvironmentModelCopyWithImpl(this._self, this._then);

  final ExerciseEnvironmentModel _self;
  final $Res Function(ExerciseEnvironmentModel) _then;

/// Create a copy of ExerciseEnvironmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? canDoAtHome = null,Object? canDoInGym = null,Object? equipmentSetupRequired = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,canDoAtHome: null == canDoAtHome ? _self.canDoAtHome : canDoAtHome // ignore: cast_nullable_to_non_nullable
as bool,canDoInGym: null == canDoInGym ? _self.canDoInGym : canDoInGym // ignore: cast_nullable_to_non_nullable
as bool,equipmentSetupRequired: null == equipmentSetupRequired ? _self.equipmentSetupRequired : equipmentSetupRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseEnvironmentModel].
extension ExerciseEnvironmentModelPatterns on ExerciseEnvironmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseEnvironmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseEnvironmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseEnvironmentModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseEnvironmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseEnvironmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseEnvironmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool canDoAtHome,  bool canDoInGym,  bool equipmentSetupRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseEnvironmentModel() when $default != null:
return $default(_that.id,_that.canDoAtHome,_that.canDoInGym,_that.equipmentSetupRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool canDoAtHome,  bool canDoInGym,  bool equipmentSetupRequired)  $default,) {final _that = this;
switch (_that) {
case _ExerciseEnvironmentModel():
return $default(_that.id,_that.canDoAtHome,_that.canDoInGym,_that.equipmentSetupRequired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool canDoAtHome,  bool canDoInGym,  bool equipmentSetupRequired)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseEnvironmentModel() when $default != null:
return $default(_that.id,_that.canDoAtHome,_that.canDoInGym,_that.equipmentSetupRequired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseEnvironmentModel implements ExerciseEnvironmentModel {
  const _ExerciseEnvironmentModel({required this.id, required this.canDoAtHome, required this.canDoInGym, required this.equipmentSetupRequired});
  factory _ExerciseEnvironmentModel.fromJson(Map<String, dynamic> json) => _$ExerciseEnvironmentModelFromJson(json);

@override final  String id;
@override final  bool canDoAtHome;
@override final  bool canDoInGym;
@override final  bool equipmentSetupRequired;

/// Create a copy of ExerciseEnvironmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseEnvironmentModelCopyWith<_ExerciseEnvironmentModel> get copyWith => __$ExerciseEnvironmentModelCopyWithImpl<_ExerciseEnvironmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseEnvironmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseEnvironmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.canDoAtHome, canDoAtHome) || other.canDoAtHome == canDoAtHome)&&(identical(other.canDoInGym, canDoInGym) || other.canDoInGym == canDoInGym)&&(identical(other.equipmentSetupRequired, equipmentSetupRequired) || other.equipmentSetupRequired == equipmentSetupRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,canDoAtHome,canDoInGym,equipmentSetupRequired);

@override
String toString() {
  return 'ExerciseEnvironmentModel(id: $id, canDoAtHome: $canDoAtHome, canDoInGym: $canDoInGym, equipmentSetupRequired: $equipmentSetupRequired)';
}


}

/// @nodoc
abstract mixin class _$ExerciseEnvironmentModelCopyWith<$Res> implements $ExerciseEnvironmentModelCopyWith<$Res> {
  factory _$ExerciseEnvironmentModelCopyWith(_ExerciseEnvironmentModel value, $Res Function(_ExerciseEnvironmentModel) _then) = __$ExerciseEnvironmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, bool canDoAtHome, bool canDoInGym, bool equipmentSetupRequired
});




}
/// @nodoc
class __$ExerciseEnvironmentModelCopyWithImpl<$Res>
    implements _$ExerciseEnvironmentModelCopyWith<$Res> {
  __$ExerciseEnvironmentModelCopyWithImpl(this._self, this._then);

  final _ExerciseEnvironmentModel _self;
  final $Res Function(_ExerciseEnvironmentModel) _then;

/// Create a copy of ExerciseEnvironmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? canDoAtHome = null,Object? canDoInGym = null,Object? equipmentSetupRequired = null,}) {
  return _then(_ExerciseEnvironmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,canDoAtHome: null == canDoAtHome ? _self.canDoAtHome : canDoAtHome // ignore: cast_nullable_to_non_nullable
as bool,canDoInGym: null == canDoInGym ? _self.canDoInGym : canDoInGym // ignore: cast_nullable_to_non_nullable
as bool,equipmentSetupRequired: null == equipmentSetupRequired ? _self.equipmentSetupRequired : equipmentSetupRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
