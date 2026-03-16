// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_variant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseVariantModel {

 String? get id;@MapConverter() Map<String, String>? get nameI18n;@MapConverter() Map<String, String>? get descriptionI18n;@MapConverter() Map<String, String>? get tipsI18n; String? get difficultyLevel; String? get mechanicsType; String? get forceType; bool? get isUnilateral; bool? get isBodyweight; int? get difficultyDelta;
/// Create a copy of ExerciseVariantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseVariantModelCopyWith<ExerciseVariantModel> get copyWith => _$ExerciseVariantModelCopyWithImpl<ExerciseVariantModel>(this as ExerciseVariantModel, _$identity);

  /// Serializes this ExerciseVariantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseVariantModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.nameI18n, nameI18n)&&const DeepCollectionEquality().equals(other.descriptionI18n, descriptionI18n)&&const DeepCollectionEquality().equals(other.tipsI18n, tipsI18n)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.mechanicsType, mechanicsType) || other.mechanicsType == mechanicsType)&&(identical(other.forceType, forceType) || other.forceType == forceType)&&(identical(other.isUnilateral, isUnilateral) || other.isUnilateral == isUnilateral)&&(identical(other.isBodyweight, isBodyweight) || other.isBodyweight == isBodyweight)&&(identical(other.difficultyDelta, difficultyDelta) || other.difficultyDelta == difficultyDelta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(nameI18n),const DeepCollectionEquality().hash(descriptionI18n),const DeepCollectionEquality().hash(tipsI18n),difficultyLevel,mechanicsType,forceType,isUnilateral,isBodyweight,difficultyDelta);

@override
String toString() {
  return 'ExerciseVariantModel(id: $id, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n, tipsI18n: $tipsI18n, difficultyLevel: $difficultyLevel, mechanicsType: $mechanicsType, forceType: $forceType, isUnilateral: $isUnilateral, isBodyweight: $isBodyweight, difficultyDelta: $difficultyDelta)';
}


}

/// @nodoc
abstract mixin class $ExerciseVariantModelCopyWith<$Res>  {
  factory $ExerciseVariantModelCopyWith(ExerciseVariantModel value, $Res Function(ExerciseVariantModel) _then) = _$ExerciseVariantModelCopyWithImpl;
@useResult
$Res call({
 String? id,@MapConverter() Map<String, String>? nameI18n,@MapConverter() Map<String, String>? descriptionI18n,@MapConverter() Map<String, String>? tipsI18n, String? difficultyLevel, String? mechanicsType, String? forceType, bool? isUnilateral, bool? isBodyweight, int? difficultyDelta
});




}
/// @nodoc
class _$ExerciseVariantModelCopyWithImpl<$Res>
    implements $ExerciseVariantModelCopyWith<$Res> {
  _$ExerciseVariantModelCopyWithImpl(this._self, this._then);

  final ExerciseVariantModel _self;
  final $Res Function(ExerciseVariantModel) _then;

/// Create a copy of ExerciseVariantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? nameI18n = freezed,Object? descriptionI18n = freezed,Object? tipsI18n = freezed,Object? difficultyLevel = freezed,Object? mechanicsType = freezed,Object? forceType = freezed,Object? isUnilateral = freezed,Object? isBodyweight = freezed,Object? difficultyDelta = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,nameI18n: freezed == nameI18n ? _self.nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,descriptionI18n: freezed == descriptionI18n ? _self.descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,tipsI18n: freezed == tipsI18n ? _self.tipsI18n : tipsI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,difficultyLevel: freezed == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as String?,mechanicsType: freezed == mechanicsType ? _self.mechanicsType : mechanicsType // ignore: cast_nullable_to_non_nullable
as String?,forceType: freezed == forceType ? _self.forceType : forceType // ignore: cast_nullable_to_non_nullable
as String?,isUnilateral: freezed == isUnilateral ? _self.isUnilateral : isUnilateral // ignore: cast_nullable_to_non_nullable
as bool?,isBodyweight: freezed == isBodyweight ? _self.isBodyweight : isBodyweight // ignore: cast_nullable_to_non_nullable
as bool?,difficultyDelta: freezed == difficultyDelta ? _self.difficultyDelta : difficultyDelta // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseVariantModel].
extension ExerciseVariantModelPatterns on ExerciseVariantModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseVariantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseVariantModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseVariantModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseVariantModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseVariantModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseVariantModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @MapConverter()  Map<String, String>? nameI18n, @MapConverter()  Map<String, String>? descriptionI18n, @MapConverter()  Map<String, String>? tipsI18n,  String? difficultyLevel,  String? mechanicsType,  String? forceType,  bool? isUnilateral,  bool? isBodyweight,  int? difficultyDelta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseVariantModel() when $default != null:
return $default(_that.id,_that.nameI18n,_that.descriptionI18n,_that.tipsI18n,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight,_that.difficultyDelta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @MapConverter()  Map<String, String>? nameI18n, @MapConverter()  Map<String, String>? descriptionI18n, @MapConverter()  Map<String, String>? tipsI18n,  String? difficultyLevel,  String? mechanicsType,  String? forceType,  bool? isUnilateral,  bool? isBodyweight,  int? difficultyDelta)  $default,) {final _that = this;
switch (_that) {
case _ExerciseVariantModel():
return $default(_that.id,_that.nameI18n,_that.descriptionI18n,_that.tipsI18n,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight,_that.difficultyDelta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @MapConverter()  Map<String, String>? nameI18n, @MapConverter()  Map<String, String>? descriptionI18n, @MapConverter()  Map<String, String>? tipsI18n,  String? difficultyLevel,  String? mechanicsType,  String? forceType,  bool? isUnilateral,  bool? isBodyweight,  int? difficultyDelta)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseVariantModel() when $default != null:
return $default(_that.id,_that.nameI18n,_that.descriptionI18n,_that.tipsI18n,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight,_that.difficultyDelta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseVariantModel implements ExerciseVariantModel {
  const _ExerciseVariantModel({this.id = null, @MapConverter() final  Map<String, String>? nameI18n = null, @MapConverter() final  Map<String, String>? descriptionI18n = null, @MapConverter() final  Map<String, String>? tipsI18n = null, this.difficultyLevel = null, this.mechanicsType = null, this.forceType = null, this.isUnilateral = null, this.isBodyweight = null, this.difficultyDelta = null}): _nameI18n = nameI18n,_descriptionI18n = descriptionI18n,_tipsI18n = tipsI18n;
  factory _ExerciseVariantModel.fromJson(Map<String, dynamic> json) => _$ExerciseVariantModelFromJson(json);

@override@JsonKey() final  String? id;
 final  Map<String, String>? _nameI18n;
@override@JsonKey()@MapConverter() Map<String, String>? get nameI18n {
  final value = _nameI18n;
  if (value == null) return null;
  if (_nameI18n is EqualUnmodifiableMapView) return _nameI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, String>? _descriptionI18n;
@override@JsonKey()@MapConverter() Map<String, String>? get descriptionI18n {
  final value = _descriptionI18n;
  if (value == null) return null;
  if (_descriptionI18n is EqualUnmodifiableMapView) return _descriptionI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, String>? _tipsI18n;
@override@JsonKey()@MapConverter() Map<String, String>? get tipsI18n {
  final value = _tipsI18n;
  if (value == null) return null;
  if (_tipsI18n is EqualUnmodifiableMapView) return _tipsI18n;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  String? difficultyLevel;
@override@JsonKey() final  String? mechanicsType;
@override@JsonKey() final  String? forceType;
@override@JsonKey() final  bool? isUnilateral;
@override@JsonKey() final  bool? isBodyweight;
@override@JsonKey() final  int? difficultyDelta;

/// Create a copy of ExerciseVariantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseVariantModelCopyWith<_ExerciseVariantModel> get copyWith => __$ExerciseVariantModelCopyWithImpl<_ExerciseVariantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseVariantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseVariantModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._nameI18n, _nameI18n)&&const DeepCollectionEquality().equals(other._descriptionI18n, _descriptionI18n)&&const DeepCollectionEquality().equals(other._tipsI18n, _tipsI18n)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.mechanicsType, mechanicsType) || other.mechanicsType == mechanicsType)&&(identical(other.forceType, forceType) || other.forceType == forceType)&&(identical(other.isUnilateral, isUnilateral) || other.isUnilateral == isUnilateral)&&(identical(other.isBodyweight, isBodyweight) || other.isBodyweight == isBodyweight)&&(identical(other.difficultyDelta, difficultyDelta) || other.difficultyDelta == difficultyDelta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_nameI18n),const DeepCollectionEquality().hash(_descriptionI18n),const DeepCollectionEquality().hash(_tipsI18n),difficultyLevel,mechanicsType,forceType,isUnilateral,isBodyweight,difficultyDelta);

@override
String toString() {
  return 'ExerciseVariantModel(id: $id, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n, tipsI18n: $tipsI18n, difficultyLevel: $difficultyLevel, mechanicsType: $mechanicsType, forceType: $forceType, isUnilateral: $isUnilateral, isBodyweight: $isBodyweight, difficultyDelta: $difficultyDelta)';
}


}

/// @nodoc
abstract mixin class _$ExerciseVariantModelCopyWith<$Res> implements $ExerciseVariantModelCopyWith<$Res> {
  factory _$ExerciseVariantModelCopyWith(_ExerciseVariantModel value, $Res Function(_ExerciseVariantModel) _then) = __$ExerciseVariantModelCopyWithImpl;
@override @useResult
$Res call({
 String? id,@MapConverter() Map<String, String>? nameI18n,@MapConverter() Map<String, String>? descriptionI18n,@MapConverter() Map<String, String>? tipsI18n, String? difficultyLevel, String? mechanicsType, String? forceType, bool? isUnilateral, bool? isBodyweight, int? difficultyDelta
});




}
/// @nodoc
class __$ExerciseVariantModelCopyWithImpl<$Res>
    implements _$ExerciseVariantModelCopyWith<$Res> {
  __$ExerciseVariantModelCopyWithImpl(this._self, this._then);

  final _ExerciseVariantModel _self;
  final $Res Function(_ExerciseVariantModel) _then;

/// Create a copy of ExerciseVariantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? nameI18n = freezed,Object? descriptionI18n = freezed,Object? tipsI18n = freezed,Object? difficultyLevel = freezed,Object? mechanicsType = freezed,Object? forceType = freezed,Object? isUnilateral = freezed,Object? isBodyweight = freezed,Object? difficultyDelta = freezed,}) {
  return _then(_ExerciseVariantModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,nameI18n: freezed == nameI18n ? _self._nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,descriptionI18n: freezed == descriptionI18n ? _self._descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,tipsI18n: freezed == tipsI18n ? _self._tipsI18n : tipsI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,difficultyLevel: freezed == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as String?,mechanicsType: freezed == mechanicsType ? _self.mechanicsType : mechanicsType // ignore: cast_nullable_to_non_nullable
as String?,forceType: freezed == forceType ? _self.forceType : forceType // ignore: cast_nullable_to_non_nullable
as String?,isUnilateral: freezed == isUnilateral ? _self.isUnilateral : isUnilateral // ignore: cast_nullable_to_non_nullable
as bool?,isBodyweight: freezed == isBodyweight ? _self.isBodyweight : isBodyweight // ignore: cast_nullable_to_non_nullable
as bool?,difficultyDelta: freezed == difficultyDelta ? _self.difficultyDelta : difficultyDelta // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
