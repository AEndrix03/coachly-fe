// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseDetailModel {

 String get id; Map<String, String> get nameI18n; Map<String, String> get descriptionI18n; Map<String, String> get tipsI18n; String get difficultyLevel; String get mechanicsType; String get forceType; bool get isUnilateral; bool get isBodyweight; ExerciseEnvironmentModel? get environment; List<ExerciseInstructionModel> get instructions; ExerciseMovementPatternModel? get movementPattern; List<ExerciseVariantModel> get variants; List<ExerciseMediaModel> get media; List<ExerciseCategoryModel> get categories; List<ExerciseSafetyModel> get safety; List<ExerciseSafetyContraindicationModel> get safetyContraindications; List<ExerciseMuscleModel> get muscles; List<ExerciseEquipmentModel> get equipments; List<TagModel> get tags;
/// Create a copy of ExerciseDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseDetailModelCopyWith<ExerciseDetailModel> get copyWith => _$ExerciseDetailModelCopyWithImpl<ExerciseDetailModel>(this as ExerciseDetailModel, _$identity);

  /// Serializes this ExerciseDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseDetailModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.nameI18n, nameI18n)&&const DeepCollectionEquality().equals(other.descriptionI18n, descriptionI18n)&&const DeepCollectionEquality().equals(other.tipsI18n, tipsI18n)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.mechanicsType, mechanicsType) || other.mechanicsType == mechanicsType)&&(identical(other.forceType, forceType) || other.forceType == forceType)&&(identical(other.isUnilateral, isUnilateral) || other.isUnilateral == isUnilateral)&&(identical(other.isBodyweight, isBodyweight) || other.isBodyweight == isBodyweight)&&(identical(other.environment, environment) || other.environment == environment)&&const DeepCollectionEquality().equals(other.instructions, instructions)&&(identical(other.movementPattern, movementPattern) || other.movementPattern == movementPattern)&&const DeepCollectionEquality().equals(other.variants, variants)&&const DeepCollectionEquality().equals(other.media, media)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.safety, safety)&&const DeepCollectionEquality().equals(other.safetyContraindications, safetyContraindications)&&const DeepCollectionEquality().equals(other.muscles, muscles)&&const DeepCollectionEquality().equals(other.equipments, equipments)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,const DeepCollectionEquality().hash(nameI18n),const DeepCollectionEquality().hash(descriptionI18n),const DeepCollectionEquality().hash(tipsI18n),difficultyLevel,mechanicsType,forceType,isUnilateral,isBodyweight,environment,const DeepCollectionEquality().hash(instructions),movementPattern,const DeepCollectionEquality().hash(variants),const DeepCollectionEquality().hash(media),const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(safety),const DeepCollectionEquality().hash(safetyContraindications),const DeepCollectionEquality().hash(muscles),const DeepCollectionEquality().hash(equipments),const DeepCollectionEquality().hash(tags)]);

@override
String toString() {
  return 'ExerciseDetailModel(id: $id, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n, tipsI18n: $tipsI18n, difficultyLevel: $difficultyLevel, mechanicsType: $mechanicsType, forceType: $forceType, isUnilateral: $isUnilateral, isBodyweight: $isBodyweight, environment: $environment, instructions: $instructions, movementPattern: $movementPattern, variants: $variants, media: $media, categories: $categories, safety: $safety, safetyContraindications: $safetyContraindications, muscles: $muscles, equipments: $equipments, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $ExerciseDetailModelCopyWith<$Res>  {
  factory $ExerciseDetailModelCopyWith(ExerciseDetailModel value, $Res Function(ExerciseDetailModel) _then) = _$ExerciseDetailModelCopyWithImpl;
@useResult
$Res call({
 String id, Map<String, String> nameI18n, Map<String, String> descriptionI18n, Map<String, String> tipsI18n, String difficultyLevel, String mechanicsType, String forceType, bool isUnilateral, bool isBodyweight, ExerciseEnvironmentModel? environment, List<ExerciseInstructionModel> instructions, ExerciseMovementPatternModel? movementPattern, List<ExerciseVariantModel> variants, List<ExerciseMediaModel> media, List<ExerciseCategoryModel> categories, List<ExerciseSafetyModel> safety, List<ExerciseSafetyContraindicationModel> safetyContraindications, List<ExerciseMuscleModel> muscles, List<ExerciseEquipmentModel> equipments, List<TagModel> tags
});


$ExerciseEnvironmentModelCopyWith<$Res>? get environment;$ExerciseMovementPatternModelCopyWith<$Res>? get movementPattern;

}
/// @nodoc
class _$ExerciseDetailModelCopyWithImpl<$Res>
    implements $ExerciseDetailModelCopyWith<$Res> {
  _$ExerciseDetailModelCopyWithImpl(this._self, this._then);

  final ExerciseDetailModel _self;
  final $Res Function(ExerciseDetailModel) _then;

/// Create a copy of ExerciseDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameI18n = null,Object? descriptionI18n = null,Object? tipsI18n = null,Object? difficultyLevel = null,Object? mechanicsType = null,Object? forceType = null,Object? isUnilateral = null,Object? isBodyweight = null,Object? environment = freezed,Object? instructions = null,Object? movementPattern = freezed,Object? variants = null,Object? media = null,Object? categories = null,Object? safety = null,Object? safetyContraindications = null,Object? muscles = null,Object? equipments = null,Object? tags = null,}) {
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
as bool,environment: freezed == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as ExerciseEnvironmentModel?,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<ExerciseInstructionModel>,movementPattern: freezed == movementPattern ? _self.movementPattern : movementPattern // ignore: cast_nullable_to_non_nullable
as ExerciseMovementPatternModel?,variants: null == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<ExerciseVariantModel>,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<ExerciseMediaModel>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<ExerciseCategoryModel>,safety: null == safety ? _self.safety : safety // ignore: cast_nullable_to_non_nullable
as List<ExerciseSafetyModel>,safetyContraindications: null == safetyContraindications ? _self.safetyContraindications : safetyContraindications // ignore: cast_nullable_to_non_nullable
as List<ExerciseSafetyContraindicationModel>,muscles: null == muscles ? _self.muscles : muscles // ignore: cast_nullable_to_non_nullable
as List<ExerciseMuscleModel>,equipments: null == equipments ? _self.equipments : equipments // ignore: cast_nullable_to_non_nullable
as List<ExerciseEquipmentModel>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagModel>,
  ));
}
/// Create a copy of ExerciseDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseEnvironmentModelCopyWith<$Res>? get environment {
    if (_self.environment == null) {
    return null;
  }

  return $ExerciseEnvironmentModelCopyWith<$Res>(_self.environment!, (value) {
    return _then(_self.copyWith(environment: value));
  });
}/// Create a copy of ExerciseDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseMovementPatternModelCopyWith<$Res>? get movementPattern {
    if (_self.movementPattern == null) {
    return null;
  }

  return $ExerciseMovementPatternModelCopyWith<$Res>(_self.movementPattern!, (value) {
    return _then(_self.copyWith(movementPattern: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExerciseDetailModel].
extension ExerciseDetailModelPatterns on ExerciseDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  Map<String, String> tipsI18n,  String difficultyLevel,  String mechanicsType,  String forceType,  bool isUnilateral,  bool isBodyweight,  ExerciseEnvironmentModel? environment,  List<ExerciseInstructionModel> instructions,  ExerciseMovementPatternModel? movementPattern,  List<ExerciseVariantModel> variants,  List<ExerciseMediaModel> media,  List<ExerciseCategoryModel> categories,  List<ExerciseSafetyModel> safety,  List<ExerciseSafetyContraindicationModel> safetyContraindications,  List<ExerciseMuscleModel> muscles,  List<ExerciseEquipmentModel> equipments,  List<TagModel> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseDetailModel() when $default != null:
return $default(_that.id,_that.nameI18n,_that.descriptionI18n,_that.tipsI18n,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight,_that.environment,_that.instructions,_that.movementPattern,_that.variants,_that.media,_that.categories,_that.safety,_that.safetyContraindications,_that.muscles,_that.equipments,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  Map<String, String> tipsI18n,  String difficultyLevel,  String mechanicsType,  String forceType,  bool isUnilateral,  bool isBodyweight,  ExerciseEnvironmentModel? environment,  List<ExerciseInstructionModel> instructions,  ExerciseMovementPatternModel? movementPattern,  List<ExerciseVariantModel> variants,  List<ExerciseMediaModel> media,  List<ExerciseCategoryModel> categories,  List<ExerciseSafetyModel> safety,  List<ExerciseSafetyContraindicationModel> safetyContraindications,  List<ExerciseMuscleModel> muscles,  List<ExerciseEquipmentModel> equipments,  List<TagModel> tags)  $default,) {final _that = this;
switch (_that) {
case _ExerciseDetailModel():
return $default(_that.id,_that.nameI18n,_that.descriptionI18n,_that.tipsI18n,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight,_that.environment,_that.instructions,_that.movementPattern,_that.variants,_that.media,_that.categories,_that.safety,_that.safetyContraindications,_that.muscles,_that.equipments,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  Map<String, String> tipsI18n,  String difficultyLevel,  String mechanicsType,  String forceType,  bool isUnilateral,  bool isBodyweight,  ExerciseEnvironmentModel? environment,  List<ExerciseInstructionModel> instructions,  ExerciseMovementPatternModel? movementPattern,  List<ExerciseVariantModel> variants,  List<ExerciseMediaModel> media,  List<ExerciseCategoryModel> categories,  List<ExerciseSafetyModel> safety,  List<ExerciseSafetyContraindicationModel> safetyContraindications,  List<ExerciseMuscleModel> muscles,  List<ExerciseEquipmentModel> equipments,  List<TagModel> tags)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseDetailModel() when $default != null:
return $default(_that.id,_that.nameI18n,_that.descriptionI18n,_that.tipsI18n,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight,_that.environment,_that.instructions,_that.movementPattern,_that.variants,_that.media,_that.categories,_that.safety,_that.safetyContraindications,_that.muscles,_that.equipments,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseDetailModel implements ExerciseDetailModel {
  const _ExerciseDetailModel({required this.id, required final  Map<String, String> nameI18n, required final  Map<String, String> descriptionI18n, required final  Map<String, String> tipsI18n, required this.difficultyLevel, required this.mechanicsType, required this.forceType, required this.isUnilateral, required this.isBodyweight, this.environment, final  List<ExerciseInstructionModel> instructions = const [], this.movementPattern, final  List<ExerciseVariantModel> variants = const [], final  List<ExerciseMediaModel> media = const [], final  List<ExerciseCategoryModel> categories = const [], final  List<ExerciseSafetyModel> safety = const [], final  List<ExerciseSafetyContraindicationModel> safetyContraindications = const [], final  List<ExerciseMuscleModel> muscles = const [], final  List<ExerciseEquipmentModel> equipments = const [], final  List<TagModel> tags = const []}): _nameI18n = nameI18n,_descriptionI18n = descriptionI18n,_tipsI18n = tipsI18n,_instructions = instructions,_variants = variants,_media = media,_categories = categories,_safety = safety,_safetyContraindications = safetyContraindications,_muscles = muscles,_equipments = equipments,_tags = tags;
  factory _ExerciseDetailModel.fromJson(Map<String, dynamic> json) => _$ExerciseDetailModelFromJson(json);

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
@override final  ExerciseEnvironmentModel? environment;
 final  List<ExerciseInstructionModel> _instructions;
@override@JsonKey() List<ExerciseInstructionModel> get instructions {
  if (_instructions is EqualUnmodifiableListView) return _instructions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructions);
}

@override final  ExerciseMovementPatternModel? movementPattern;
 final  List<ExerciseVariantModel> _variants;
@override@JsonKey() List<ExerciseVariantModel> get variants {
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variants);
}

 final  List<ExerciseMediaModel> _media;
@override@JsonKey() List<ExerciseMediaModel> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

 final  List<ExerciseCategoryModel> _categories;
@override@JsonKey() List<ExerciseCategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<ExerciseSafetyModel> _safety;
@override@JsonKey() List<ExerciseSafetyModel> get safety {
  if (_safety is EqualUnmodifiableListView) return _safety;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_safety);
}

 final  List<ExerciseSafetyContraindicationModel> _safetyContraindications;
@override@JsonKey() List<ExerciseSafetyContraindicationModel> get safetyContraindications {
  if (_safetyContraindications is EqualUnmodifiableListView) return _safetyContraindications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_safetyContraindications);
}

 final  List<ExerciseMuscleModel> _muscles;
@override@JsonKey() List<ExerciseMuscleModel> get muscles {
  if (_muscles is EqualUnmodifiableListView) return _muscles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_muscles);
}

 final  List<ExerciseEquipmentModel> _equipments;
@override@JsonKey() List<ExerciseEquipmentModel> get equipments {
  if (_equipments is EqualUnmodifiableListView) return _equipments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_equipments);
}

 final  List<TagModel> _tags;
@override@JsonKey() List<TagModel> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of ExerciseDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseDetailModelCopyWith<_ExerciseDetailModel> get copyWith => __$ExerciseDetailModelCopyWithImpl<_ExerciseDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseDetailModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._nameI18n, _nameI18n)&&const DeepCollectionEquality().equals(other._descriptionI18n, _descriptionI18n)&&const DeepCollectionEquality().equals(other._tipsI18n, _tipsI18n)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.mechanicsType, mechanicsType) || other.mechanicsType == mechanicsType)&&(identical(other.forceType, forceType) || other.forceType == forceType)&&(identical(other.isUnilateral, isUnilateral) || other.isUnilateral == isUnilateral)&&(identical(other.isBodyweight, isBodyweight) || other.isBodyweight == isBodyweight)&&(identical(other.environment, environment) || other.environment == environment)&&const DeepCollectionEquality().equals(other._instructions, _instructions)&&(identical(other.movementPattern, movementPattern) || other.movementPattern == movementPattern)&&const DeepCollectionEquality().equals(other._variants, _variants)&&const DeepCollectionEquality().equals(other._media, _media)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._safety, _safety)&&const DeepCollectionEquality().equals(other._safetyContraindications, _safetyContraindications)&&const DeepCollectionEquality().equals(other._muscles, _muscles)&&const DeepCollectionEquality().equals(other._equipments, _equipments)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,const DeepCollectionEquality().hash(_nameI18n),const DeepCollectionEquality().hash(_descriptionI18n),const DeepCollectionEquality().hash(_tipsI18n),difficultyLevel,mechanicsType,forceType,isUnilateral,isBodyweight,environment,const DeepCollectionEquality().hash(_instructions),movementPattern,const DeepCollectionEquality().hash(_variants),const DeepCollectionEquality().hash(_media),const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_safety),const DeepCollectionEquality().hash(_safetyContraindications),const DeepCollectionEquality().hash(_muscles),const DeepCollectionEquality().hash(_equipments),const DeepCollectionEquality().hash(_tags)]);

@override
String toString() {
  return 'ExerciseDetailModel(id: $id, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n, tipsI18n: $tipsI18n, difficultyLevel: $difficultyLevel, mechanicsType: $mechanicsType, forceType: $forceType, isUnilateral: $isUnilateral, isBodyweight: $isBodyweight, environment: $environment, instructions: $instructions, movementPattern: $movementPattern, variants: $variants, media: $media, categories: $categories, safety: $safety, safetyContraindications: $safetyContraindications, muscles: $muscles, equipments: $equipments, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$ExerciseDetailModelCopyWith<$Res> implements $ExerciseDetailModelCopyWith<$Res> {
  factory _$ExerciseDetailModelCopyWith(_ExerciseDetailModel value, $Res Function(_ExerciseDetailModel) _then) = __$ExerciseDetailModelCopyWithImpl;
@override @useResult
$Res call({
 String id, Map<String, String> nameI18n, Map<String, String> descriptionI18n, Map<String, String> tipsI18n, String difficultyLevel, String mechanicsType, String forceType, bool isUnilateral, bool isBodyweight, ExerciseEnvironmentModel? environment, List<ExerciseInstructionModel> instructions, ExerciseMovementPatternModel? movementPattern, List<ExerciseVariantModel> variants, List<ExerciseMediaModel> media, List<ExerciseCategoryModel> categories, List<ExerciseSafetyModel> safety, List<ExerciseSafetyContraindicationModel> safetyContraindications, List<ExerciseMuscleModel> muscles, List<ExerciseEquipmentModel> equipments, List<TagModel> tags
});


@override $ExerciseEnvironmentModelCopyWith<$Res>? get environment;@override $ExerciseMovementPatternModelCopyWith<$Res>? get movementPattern;

}
/// @nodoc
class __$ExerciseDetailModelCopyWithImpl<$Res>
    implements _$ExerciseDetailModelCopyWith<$Res> {
  __$ExerciseDetailModelCopyWithImpl(this._self, this._then);

  final _ExerciseDetailModel _self;
  final $Res Function(_ExerciseDetailModel) _then;

/// Create a copy of ExerciseDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameI18n = null,Object? descriptionI18n = null,Object? tipsI18n = null,Object? difficultyLevel = null,Object? mechanicsType = null,Object? forceType = null,Object? isUnilateral = null,Object? isBodyweight = null,Object? environment = freezed,Object? instructions = null,Object? movementPattern = freezed,Object? variants = null,Object? media = null,Object? categories = null,Object? safety = null,Object? safetyContraindications = null,Object? muscles = null,Object? equipments = null,Object? tags = null,}) {
  return _then(_ExerciseDetailModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nameI18n: null == nameI18n ? _self._nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self._descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,tipsI18n: null == tipsI18n ? _self._tipsI18n : tipsI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,difficultyLevel: null == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as String,mechanicsType: null == mechanicsType ? _self.mechanicsType : mechanicsType // ignore: cast_nullable_to_non_nullable
as String,forceType: null == forceType ? _self.forceType : forceType // ignore: cast_nullable_to_non_nullable
as String,isUnilateral: null == isUnilateral ? _self.isUnilateral : isUnilateral // ignore: cast_nullable_to_non_nullable
as bool,isBodyweight: null == isBodyweight ? _self.isBodyweight : isBodyweight // ignore: cast_nullable_to_non_nullable
as bool,environment: freezed == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as ExerciseEnvironmentModel?,instructions: null == instructions ? _self._instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<ExerciseInstructionModel>,movementPattern: freezed == movementPattern ? _self.movementPattern : movementPattern // ignore: cast_nullable_to_non_nullable
as ExerciseMovementPatternModel?,variants: null == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<ExerciseVariantModel>,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<ExerciseMediaModel>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<ExerciseCategoryModel>,safety: null == safety ? _self._safety : safety // ignore: cast_nullable_to_non_nullable
as List<ExerciseSafetyModel>,safetyContraindications: null == safetyContraindications ? _self._safetyContraindications : safetyContraindications // ignore: cast_nullable_to_non_nullable
as List<ExerciseSafetyContraindicationModel>,muscles: null == muscles ? _self._muscles : muscles // ignore: cast_nullable_to_non_nullable
as List<ExerciseMuscleModel>,equipments: null == equipments ? _self._equipments : equipments // ignore: cast_nullable_to_non_nullable
as List<ExerciseEquipmentModel>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagModel>,
  ));
}

/// Create a copy of ExerciseDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseEnvironmentModelCopyWith<$Res>? get environment {
    if (_self.environment == null) {
    return null;
  }

  return $ExerciseEnvironmentModelCopyWith<$Res>(_self.environment!, (value) {
    return _then(_self.copyWith(environment: value));
  });
}/// Create a copy of ExerciseDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseMovementPatternModelCopyWith<$Res>? get movementPattern {
    if (_self.movementPattern == null) {
    return null;
  }

  return $ExerciseMovementPatternModelCopyWith<$Res>(_self.movementPattern!, (value) {
    return _then(_self.copyWith(movementPattern: value));
  });
}
}

// dart format on
