// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseModel {

 String get id; Map<String, String> get nameI18n; Map<String, String> get descriptionI18n; Map<String, String> get tipsI18n; String get difficultyLevel; String get mechanicsType; String get forceType; bool get isUnilateral; bool get isBodyweight;
/// Create a copy of ExerciseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseModelCopyWith<ExerciseModel> get copyWith => _$ExerciseModelCopyWithImpl<ExerciseModel>(this as ExerciseModel, _$identity);

  /// Serializes this ExerciseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.nameI18n, nameI18n)&&const DeepCollectionEquality().equals(other.descriptionI18n, descriptionI18n)&&const DeepCollectionEquality().equals(other.tipsI18n, tipsI18n)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.mechanicsType, mechanicsType) || other.mechanicsType == mechanicsType)&&(identical(other.forceType, forceType) || other.forceType == forceType)&&(identical(other.isUnilateral, isUnilateral) || other.isUnilateral == isUnilateral)&&(identical(other.isBodyweight, isBodyweight) || other.isBodyweight == isBodyweight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(nameI18n),const DeepCollectionEquality().hash(descriptionI18n),const DeepCollectionEquality().hash(tipsI18n),difficultyLevel,mechanicsType,forceType,isUnilateral,isBodyweight);

@override
String toString() {
  return 'ExerciseModel(id: $id, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n, tipsI18n: $tipsI18n, difficultyLevel: $difficultyLevel, mechanicsType: $mechanicsType, forceType: $forceType, isUnilateral: $isUnilateral, isBodyweight: $isBodyweight)';
}


}

/// @nodoc
abstract mixin class $ExerciseModelCopyWith<$Res>  {
  factory $ExerciseModelCopyWith(ExerciseModel value, $Res Function(ExerciseModel) _then) = _$ExerciseModelCopyWithImpl;
@useResult
$Res call({
 String id, Map<String, String> nameI18n, Map<String, String> descriptionI18n, Map<String, String> tipsI18n, String difficultyLevel, String mechanicsType, String forceType, bool isUnilateral, bool isBodyweight
});




}
/// @nodoc
class _$ExerciseModelCopyWithImpl<$Res>
    implements $ExerciseModelCopyWith<$Res> {
  _$ExerciseModelCopyWithImpl(this._self, this._then);

  final ExerciseModel _self;
  final $Res Function(ExerciseModel) _then;

/// Create a copy of ExerciseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameI18n = null,Object? descriptionI18n = null,Object? tipsI18n = null,Object? difficultyLevel = null,Object? mechanicsType = null,Object? forceType = null,Object? isUnilateral = null,Object? isBodyweight = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameI18n: null == nameI18n ? _self.nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self.descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,tipsI18n: null == tipsI18n ? _self.tipsI18n : tipsI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,difficultyLevel: null == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as String,mechanicsType: null == mechanicsType ? _self.mechanicsType : mechanicsType // ignore: cast_nullable_to_non_nullable
as String,forceType: null == forceType ? _self.forceType : forceType // ignore: cast_nullable_to_non_nullable
as String,isUnilateral: null == isUnilateral ? _self.isUnilateral : isUnilateral // ignore: cast_nullable_to_non_nullable
as bool,isBodyweight: null == isBodyweight ? _self.isBodyweight : isBodyweight // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseModel].
extension ExerciseModelPatterns on ExerciseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  Map<String, String> tipsI18n,  String difficultyLevel,  String mechanicsType,  String forceType,  bool isUnilateral,  bool isBodyweight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseModel() when $default != null:
return $default(_that.id,_that.nameI18n,_that.descriptionI18n,_that.tipsI18n,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  Map<String, String> tipsI18n,  String difficultyLevel,  String mechanicsType,  String forceType,  bool isUnilateral,  bool isBodyweight)  $default,) {final _that = this;
switch (_that) {
case _ExerciseModel():
return $default(_that.id,_that.nameI18n,_that.descriptionI18n,_that.tipsI18n,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  Map<String, String> tipsI18n,  String difficultyLevel,  String mechanicsType,  String forceType,  bool isUnilateral,  bool isBodyweight)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseModel() when $default != null:
return $default(_that.id,_that.nameI18n,_that.descriptionI18n,_that.tipsI18n,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseModel implements ExerciseModel {
  const _ExerciseModel({required this.id, required final  Map<String, String> nameI18n, required final  Map<String, String> descriptionI18n, required final  Map<String, String> tipsI18n, required this.difficultyLevel, required this.mechanicsType, required this.forceType, required this.isUnilateral, required this.isBodyweight}): _nameI18n = nameI18n,_descriptionI18n = descriptionI18n,_tipsI18n = tipsI18n;
  factory _ExerciseModel.fromJson(Map<String, dynamic> json) => _$ExerciseModelFromJson(json);

@override final  String id;
 final  Map<String, String> _nameI18n;
@override Map<String, String> get nameI18n {
  if (_nameI18n is EqualUnmodifiableMapView) return _nameI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_nameI18n);
}

 final  Map<String, String> _descriptionI18n;
@override Map<String, String> get descriptionI18n {
  if (_descriptionI18n is EqualUnmodifiableMapView) return _descriptionI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_descriptionI18n);
}

 final  Map<String, String> _tipsI18n;
@override Map<String, String> get tipsI18n {
  if (_tipsI18n is EqualUnmodifiableMapView) return _tipsI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_tipsI18n);
}

@override final  String difficultyLevel;
@override final  String mechanicsType;
@override final  String forceType;
@override final  bool isUnilateral;
@override final  bool isBodyweight;

/// Create a copy of ExerciseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseModelCopyWith<_ExerciseModel> get copyWith => __$ExerciseModelCopyWithImpl<_ExerciseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._nameI18n, _nameI18n)&&const DeepCollectionEquality().equals(other._descriptionI18n, _descriptionI18n)&&const DeepCollectionEquality().equals(other._tipsI18n, _tipsI18n)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.mechanicsType, mechanicsType) || other.mechanicsType == mechanicsType)&&(identical(other.forceType, forceType) || other.forceType == forceType)&&(identical(other.isUnilateral, isUnilateral) || other.isUnilateral == isUnilateral)&&(identical(other.isBodyweight, isBodyweight) || other.isBodyweight == isBodyweight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_nameI18n),const DeepCollectionEquality().hash(_descriptionI18n),const DeepCollectionEquality().hash(_tipsI18n),difficultyLevel,mechanicsType,forceType,isUnilateral,isBodyweight);

@override
String toString() {
  return 'ExerciseModel(id: $id, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n, tipsI18n: $tipsI18n, difficultyLevel: $difficultyLevel, mechanicsType: $mechanicsType, forceType: $forceType, isUnilateral: $isUnilateral, isBodyweight: $isBodyweight)';
}


}

/// @nodoc
abstract mixin class _$ExerciseModelCopyWith<$Res> implements $ExerciseModelCopyWith<$Res> {
  factory _$ExerciseModelCopyWith(_ExerciseModel value, $Res Function(_ExerciseModel) _then) = __$ExerciseModelCopyWithImpl;
@override @useResult
$Res call({
 String id, Map<String, String> nameI18n, Map<String, String> descriptionI18n, Map<String, String> tipsI18n, String difficultyLevel, String mechanicsType, String forceType, bool isUnilateral, bool isBodyweight
});




}
/// @nodoc
class __$ExerciseModelCopyWithImpl<$Res>
    implements _$ExerciseModelCopyWith<$Res> {
  __$ExerciseModelCopyWithImpl(this._self, this._then);

  final _ExerciseModel _self;
  final $Res Function(_ExerciseModel) _then;

/// Create a copy of ExerciseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameI18n = null,Object? descriptionI18n = null,Object? tipsI18n = null,Object? difficultyLevel = null,Object? mechanicsType = null,Object? forceType = null,Object? isUnilateral = null,Object? isBodyweight = null,}) {
  return _then(_ExerciseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameI18n: null == nameI18n ? _self._nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self._descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,tipsI18n: null == tipsI18n ? _self._tipsI18n : tipsI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,difficultyLevel: null == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as String,mechanicsType: null == mechanicsType ? _self.mechanicsType : mechanicsType // ignore: cast_nullable_to_non_nullable
as String,forceType: null == forceType ? _self.forceType : forceType // ignore: cast_nullable_to_non_nullable
as String,isUnilateral: null == isUnilateral ? _self.isUnilateral : isUnilateral // ignore: cast_nullable_to_non_nullable
as bool,isBodyweight: null == isBodyweight ? _self.isBodyweight : isBodyweight // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
