// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_safety_contraindication_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseSafetyContraindicationModel {

 String get id; String get contraindicationType; String get conditionName; Map<String, String> get warningTextI18n;
/// Create a copy of ExerciseSafetyContraindicationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseSafetyContraindicationModelCopyWith<ExerciseSafetyContraindicationModel> get copyWith => _$ExerciseSafetyContraindicationModelCopyWithImpl<ExerciseSafetyContraindicationModel>(this as ExerciseSafetyContraindicationModel, _$identity);

  /// Serializes this ExerciseSafetyContraindicationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseSafetyContraindicationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.contraindicationType, contraindicationType) || other.contraindicationType == contraindicationType)&&(identical(other.conditionName, conditionName) || other.conditionName == conditionName)&&const DeepCollectionEquality().equals(other.warningTextI18n, warningTextI18n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,contraindicationType,conditionName,const DeepCollectionEquality().hash(warningTextI18n));

@override
String toString() {
  return 'ExerciseSafetyContraindicationModel(id: $id, contraindicationType: $contraindicationType, conditionName: $conditionName, warningTextI18n: $warningTextI18n)';
}


}

/// @nodoc
abstract mixin class $ExerciseSafetyContraindicationModelCopyWith<$Res>  {
  factory $ExerciseSafetyContraindicationModelCopyWith(ExerciseSafetyContraindicationModel value, $Res Function(ExerciseSafetyContraindicationModel) _then) = _$ExerciseSafetyContraindicationModelCopyWithImpl;
@useResult
$Res call({
 String id, String contraindicationType, String conditionName, Map<String, String> warningTextI18n
});




}
/// @nodoc
class _$ExerciseSafetyContraindicationModelCopyWithImpl<$Res>
    implements $ExerciseSafetyContraindicationModelCopyWith<$Res> {
  _$ExerciseSafetyContraindicationModelCopyWithImpl(this._self, this._then);

  final ExerciseSafetyContraindicationModel _self;
  final $Res Function(ExerciseSafetyContraindicationModel) _then;

/// Create a copy of ExerciseSafetyContraindicationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contraindicationType = null,Object? conditionName = null,Object? warningTextI18n = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contraindicationType: null == contraindicationType ? _self.contraindicationType : contraindicationType // ignore: cast_nullable_to_non_nullable
as String,conditionName: null == conditionName ? _self.conditionName : conditionName // ignore: cast_nullable_to_non_nullable
as String,warningTextI18n: null == warningTextI18n ? _self.warningTextI18n : warningTextI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseSafetyContraindicationModel].
extension ExerciseSafetyContraindicationModelPatterns on ExerciseSafetyContraindicationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseSafetyContraindicationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseSafetyContraindicationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseSafetyContraindicationModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseSafetyContraindicationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseSafetyContraindicationModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseSafetyContraindicationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String contraindicationType,  String conditionName,  Map<String, String> warningTextI18n)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseSafetyContraindicationModel() when $default != null:
return $default(_that.id,_that.contraindicationType,_that.conditionName,_that.warningTextI18n);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String contraindicationType,  String conditionName,  Map<String, String> warningTextI18n)  $default,) {final _that = this;
switch (_that) {
case _ExerciseSafetyContraindicationModel():
return $default(_that.id,_that.contraindicationType,_that.conditionName,_that.warningTextI18n);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String contraindicationType,  String conditionName,  Map<String, String> warningTextI18n)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseSafetyContraindicationModel() when $default != null:
return $default(_that.id,_that.contraindicationType,_that.conditionName,_that.warningTextI18n);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseSafetyContraindicationModel implements ExerciseSafetyContraindicationModel {
  const _ExerciseSafetyContraindicationModel({required this.id, required this.contraindicationType, required this.conditionName, required final  Map<String, String> warningTextI18n}): _warningTextI18n = warningTextI18n;
  factory _ExerciseSafetyContraindicationModel.fromJson(Map<String, dynamic> json) => _$ExerciseSafetyContraindicationModelFromJson(json);

@override final  String id;
@override final  String contraindicationType;
@override final  String conditionName;
 final  Map<String, String> _warningTextI18n;
@override Map<String, String> get warningTextI18n {
  if (_warningTextI18n is EqualUnmodifiableMapView) return _warningTextI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_warningTextI18n);
}


/// Create a copy of ExerciseSafetyContraindicationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseSafetyContraindicationModelCopyWith<_ExerciseSafetyContraindicationModel> get copyWith => __$ExerciseSafetyContraindicationModelCopyWithImpl<_ExerciseSafetyContraindicationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseSafetyContraindicationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseSafetyContraindicationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.contraindicationType, contraindicationType) || other.contraindicationType == contraindicationType)&&(identical(other.conditionName, conditionName) || other.conditionName == conditionName)&&const DeepCollectionEquality().equals(other._warningTextI18n, _warningTextI18n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,contraindicationType,conditionName,const DeepCollectionEquality().hash(_warningTextI18n));

@override
String toString() {
  return 'ExerciseSafetyContraindicationModel(id: $id, contraindicationType: $contraindicationType, conditionName: $conditionName, warningTextI18n: $warningTextI18n)';
}


}

/// @nodoc
abstract mixin class _$ExerciseSafetyContraindicationModelCopyWith<$Res> implements $ExerciseSafetyContraindicationModelCopyWith<$Res> {
  factory _$ExerciseSafetyContraindicationModelCopyWith(_ExerciseSafetyContraindicationModel value, $Res Function(_ExerciseSafetyContraindicationModel) _then) = __$ExerciseSafetyContraindicationModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String contraindicationType, String conditionName, Map<String, String> warningTextI18n
});




}
/// @nodoc
class __$ExerciseSafetyContraindicationModelCopyWithImpl<$Res>
    implements _$ExerciseSafetyContraindicationModelCopyWith<$Res> {
  __$ExerciseSafetyContraindicationModelCopyWithImpl(this._self, this._then);

  final _ExerciseSafetyContraindicationModel _self;
  final $Res Function(_ExerciseSafetyContraindicationModel) _then;

/// Create a copy of ExerciseSafetyContraindicationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contraindicationType = null,Object? conditionName = null,Object? warningTextI18n = null,}) {
  return _then(_ExerciseSafetyContraindicationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contraindicationType: null == contraindicationType ? _self.contraindicationType : contraindicationType // ignore: cast_nullable_to_non_nullable
as String,conditionName: null == conditionName ? _self.conditionName : conditionName // ignore: cast_nullable_to_non_nullable
as String,warningTextI18n: null == warningTextI18n ? _self._warningTextI18n : warningTextI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
