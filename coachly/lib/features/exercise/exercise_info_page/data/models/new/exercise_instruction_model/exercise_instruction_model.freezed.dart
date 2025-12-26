// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_instruction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseInstructionModel {

 String get id; String get instructionType; int get stepNumber; Map<String, String> get instructionTextI18n; bool get isCritical;
/// Create a copy of ExerciseInstructionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseInstructionModelCopyWith<ExerciseInstructionModel> get copyWith => _$ExerciseInstructionModelCopyWithImpl<ExerciseInstructionModel>(this as ExerciseInstructionModel, _$identity);

  /// Serializes this ExerciseInstructionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseInstructionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.instructionType, instructionType) || other.instructionType == instructionType)&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&const DeepCollectionEquality().equals(other.instructionTextI18n, instructionTextI18n)&&(identical(other.isCritical, isCritical) || other.isCritical == isCritical));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,instructionType,stepNumber,const DeepCollectionEquality().hash(instructionTextI18n),isCritical);

@override
String toString() {
  return 'ExerciseInstructionModel(id: $id, instructionType: $instructionType, stepNumber: $stepNumber, instructionTextI18n: $instructionTextI18n, isCritical: $isCritical)';
}


}

/// @nodoc
abstract mixin class $ExerciseInstructionModelCopyWith<$Res>  {
  factory $ExerciseInstructionModelCopyWith(ExerciseInstructionModel value, $Res Function(ExerciseInstructionModel) _then) = _$ExerciseInstructionModelCopyWithImpl;
@useResult
$Res call({
 String id, String instructionType, int stepNumber, Map<String, String> instructionTextI18n, bool isCritical
});




}
/// @nodoc
class _$ExerciseInstructionModelCopyWithImpl<$Res>
    implements $ExerciseInstructionModelCopyWith<$Res> {
  _$ExerciseInstructionModelCopyWithImpl(this._self, this._then);

  final ExerciseInstructionModel _self;
  final $Res Function(ExerciseInstructionModel) _then;

/// Create a copy of ExerciseInstructionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? instructionType = null,Object? stepNumber = null,Object? instructionTextI18n = null,Object? isCritical = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,instructionType: null == instructionType ? _self.instructionType : instructionType // ignore: cast_nullable_to_non_nullable
as String,stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,instructionTextI18n: null == instructionTextI18n ? _self.instructionTextI18n : instructionTextI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,isCritical: null == isCritical ? _self.isCritical : isCritical // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseInstructionModel].
extension ExerciseInstructionModelPatterns on ExerciseInstructionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseInstructionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseInstructionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseInstructionModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseInstructionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseInstructionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseInstructionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String instructionType,  int stepNumber,  Map<String, String> instructionTextI18n,  bool isCritical)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseInstructionModel() when $default != null:
return $default(_that.id,_that.instructionType,_that.stepNumber,_that.instructionTextI18n,_that.isCritical);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String instructionType,  int stepNumber,  Map<String, String> instructionTextI18n,  bool isCritical)  $default,) {final _that = this;
switch (_that) {
case _ExerciseInstructionModel():
return $default(_that.id,_that.instructionType,_that.stepNumber,_that.instructionTextI18n,_that.isCritical);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String instructionType,  int stepNumber,  Map<String, String> instructionTextI18n,  bool isCritical)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseInstructionModel() when $default != null:
return $default(_that.id,_that.instructionType,_that.stepNumber,_that.instructionTextI18n,_that.isCritical);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseInstructionModel implements ExerciseInstructionModel {
  const _ExerciseInstructionModel({required this.id, required this.instructionType, required this.stepNumber, required final  Map<String, String> instructionTextI18n, required this.isCritical}): _instructionTextI18n = instructionTextI18n;
  factory _ExerciseInstructionModel.fromJson(Map<String, dynamic> json) => _$ExerciseInstructionModelFromJson(json);

@override final  String id;
@override final  String instructionType;
@override final  int stepNumber;
 final  Map<String, String> _instructionTextI18n;
@override Map<String, String> get instructionTextI18n {
  if (_instructionTextI18n is EqualUnmodifiableMapView) return _instructionTextI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_instructionTextI18n);
}

@override final  bool isCritical;

/// Create a copy of ExerciseInstructionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseInstructionModelCopyWith<_ExerciseInstructionModel> get copyWith => __$ExerciseInstructionModelCopyWithImpl<_ExerciseInstructionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseInstructionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseInstructionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.instructionType, instructionType) || other.instructionType == instructionType)&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&const DeepCollectionEquality().equals(other._instructionTextI18n, _instructionTextI18n)&&(identical(other.isCritical, isCritical) || other.isCritical == isCritical));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,instructionType,stepNumber,const DeepCollectionEquality().hash(_instructionTextI18n),isCritical);

@override
String toString() {
  return 'ExerciseInstructionModel(id: $id, instructionType: $instructionType, stepNumber: $stepNumber, instructionTextI18n: $instructionTextI18n, isCritical: $isCritical)';
}


}

/// @nodoc
abstract mixin class _$ExerciseInstructionModelCopyWith<$Res> implements $ExerciseInstructionModelCopyWith<$Res> {
  factory _$ExerciseInstructionModelCopyWith(_ExerciseInstructionModel value, $Res Function(_ExerciseInstructionModel) _then) = __$ExerciseInstructionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String instructionType, int stepNumber, Map<String, String> instructionTextI18n, bool isCritical
});




}
/// @nodoc
class __$ExerciseInstructionModelCopyWithImpl<$Res>
    implements _$ExerciseInstructionModelCopyWith<$Res> {
  __$ExerciseInstructionModelCopyWithImpl(this._self, this._then);

  final _ExerciseInstructionModel _self;
  final $Res Function(_ExerciseInstructionModel) _then;

/// Create a copy of ExerciseInstructionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? instructionType = null,Object? stepNumber = null,Object? instructionTextI18n = null,Object? isCritical = null,}) {
  return _then(_ExerciseInstructionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,instructionType: null == instructionType ? _self.instructionType : instructionType // ignore: cast_nullable_to_non_nullable
as String,stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,instructionTextI18n: null == instructionTextI18n ? _self._instructionTextI18n : instructionTextI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,isCritical: null == isCritical ? _self.isCritical : isCritical // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
