// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_filter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseFilterModel {

 String? get scope; String? get textFilter; String? get langFilter; String? get difficultyLevel; String? get mechanicsType; String? get forceType; bool? get isUnilateral; bool? get isBodyweight; List<String>? get categoryIds; List<String>? get muscleIds;
/// Create a copy of ExerciseFilterModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseFilterModelCopyWith<ExerciseFilterModel> get copyWith => _$ExerciseFilterModelCopyWithImpl<ExerciseFilterModel>(this as ExerciseFilterModel, _$identity);

  /// Serializes this ExerciseFilterModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseFilterModel&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.textFilter, textFilter) || other.textFilter == textFilter)&&(identical(other.langFilter, langFilter) || other.langFilter == langFilter)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.mechanicsType, mechanicsType) || other.mechanicsType == mechanicsType)&&(identical(other.forceType, forceType) || other.forceType == forceType)&&(identical(other.isUnilateral, isUnilateral) || other.isUnilateral == isUnilateral)&&(identical(other.isBodyweight, isBodyweight) || other.isBodyweight == isBodyweight)&&const DeepCollectionEquality().equals(other.categoryIds, categoryIds)&&const DeepCollectionEquality().equals(other.muscleIds, muscleIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scope,textFilter,langFilter,difficultyLevel,mechanicsType,forceType,isUnilateral,isBodyweight,const DeepCollectionEquality().hash(categoryIds),const DeepCollectionEquality().hash(muscleIds));

@override
String toString() {
  return 'ExerciseFilterModel(scope: $scope, textFilter: $textFilter, langFilter: $langFilter, difficultyLevel: $difficultyLevel, mechanicsType: $mechanicsType, forceType: $forceType, isUnilateral: $isUnilateral, isBodyweight: $isBodyweight, categoryIds: $categoryIds, muscleIds: $muscleIds)';
}


}

/// @nodoc
abstract mixin class $ExerciseFilterModelCopyWith<$Res>  {
  factory $ExerciseFilterModelCopyWith(ExerciseFilterModel value, $Res Function(ExerciseFilterModel) _then) = _$ExerciseFilterModelCopyWithImpl;
@useResult
$Res call({
 String? scope, String? textFilter, String? langFilter, String? difficultyLevel, String? mechanicsType, String? forceType, bool? isUnilateral, bool? isBodyweight, List<String>? categoryIds, List<String>? muscleIds
});




}
/// @nodoc
class _$ExerciseFilterModelCopyWithImpl<$Res>
    implements $ExerciseFilterModelCopyWith<$Res> {
  _$ExerciseFilterModelCopyWithImpl(this._self, this._then);

  final ExerciseFilterModel _self;
  final $Res Function(ExerciseFilterModel) _then;

/// Create a copy of ExerciseFilterModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scope = freezed,Object? textFilter = freezed,Object? langFilter = freezed,Object? difficultyLevel = freezed,Object? mechanicsType = freezed,Object? forceType = freezed,Object? isUnilateral = freezed,Object? isBodyweight = freezed,Object? categoryIds = freezed,Object? muscleIds = freezed,}) {
  return _then(_self.copyWith(
scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,textFilter: freezed == textFilter ? _self.textFilter : textFilter // ignore: cast_nullable_to_non_nullable
as String?,langFilter: freezed == langFilter ? _self.langFilter : langFilter // ignore: cast_nullable_to_non_nullable
as String?,difficultyLevel: freezed == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as String?,mechanicsType: freezed == mechanicsType ? _self.mechanicsType : mechanicsType // ignore: cast_nullable_to_non_nullable
as String?,forceType: freezed == forceType ? _self.forceType : forceType // ignore: cast_nullable_to_non_nullable
as String?,isUnilateral: freezed == isUnilateral ? _self.isUnilateral : isUnilateral // ignore: cast_nullable_to_non_nullable
as bool?,isBodyweight: freezed == isBodyweight ? _self.isBodyweight : isBodyweight // ignore: cast_nullable_to_non_nullable
as bool?,categoryIds: freezed == categoryIds ? _self.categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>?,muscleIds: freezed == muscleIds ? _self.muscleIds : muscleIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseFilterModel].
extension ExerciseFilterModelPatterns on ExerciseFilterModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseFilterModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseFilterModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseFilterModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseFilterModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseFilterModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseFilterModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? scope,  String? textFilter,  String? langFilter,  String? difficultyLevel,  String? mechanicsType,  String? forceType,  bool? isUnilateral,  bool? isBodyweight,  List<String>? categoryIds,  List<String>? muscleIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseFilterModel() when $default != null:
return $default(_that.scope,_that.textFilter,_that.langFilter,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight,_that.categoryIds,_that.muscleIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? scope,  String? textFilter,  String? langFilter,  String? difficultyLevel,  String? mechanicsType,  String? forceType,  bool? isUnilateral,  bool? isBodyweight,  List<String>? categoryIds,  List<String>? muscleIds)  $default,) {final _that = this;
switch (_that) {
case _ExerciseFilterModel():
return $default(_that.scope,_that.textFilter,_that.langFilter,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight,_that.categoryIds,_that.muscleIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? scope,  String? textFilter,  String? langFilter,  String? difficultyLevel,  String? mechanicsType,  String? forceType,  bool? isUnilateral,  bool? isBodyweight,  List<String>? categoryIds,  List<String>? muscleIds)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseFilterModel() when $default != null:
return $default(_that.scope,_that.textFilter,_that.langFilter,_that.difficultyLevel,_that.mechanicsType,_that.forceType,_that.isUnilateral,_that.isBodyweight,_that.categoryIds,_that.muscleIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseFilterModel implements ExerciseFilterModel {
  const _ExerciseFilterModel({this.scope = null, this.textFilter, this.langFilter, this.difficultyLevel, this.mechanicsType, this.forceType, this.isUnilateral, this.isBodyweight, final  List<String>? categoryIds, final  List<String>? muscleIds}): _categoryIds = categoryIds,_muscleIds = muscleIds;
  factory _ExerciseFilterModel.fromJson(Map<String, dynamic> json) => _$ExerciseFilterModelFromJson(json);

@override@JsonKey() final  String? scope;
@override final  String? textFilter;
@override final  String? langFilter;
@override final  String? difficultyLevel;
@override final  String? mechanicsType;
@override final  String? forceType;
@override final  bool? isUnilateral;
@override final  bool? isBodyweight;
 final  List<String>? _categoryIds;
@override List<String>? get categoryIds {
  final value = _categoryIds;
  if (value == null) return null;
  if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _muscleIds;
@override List<String>? get muscleIds {
  final value = _muscleIds;
  if (value == null) return null;
  if (_muscleIds is EqualUnmodifiableListView) return _muscleIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ExerciseFilterModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseFilterModelCopyWith<_ExerciseFilterModel> get copyWith => __$ExerciseFilterModelCopyWithImpl<_ExerciseFilterModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseFilterModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseFilterModel&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.textFilter, textFilter) || other.textFilter == textFilter)&&(identical(other.langFilter, langFilter) || other.langFilter == langFilter)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.mechanicsType, mechanicsType) || other.mechanicsType == mechanicsType)&&(identical(other.forceType, forceType) || other.forceType == forceType)&&(identical(other.isUnilateral, isUnilateral) || other.isUnilateral == isUnilateral)&&(identical(other.isBodyweight, isBodyweight) || other.isBodyweight == isBodyweight)&&const DeepCollectionEquality().equals(other._categoryIds, _categoryIds)&&const DeepCollectionEquality().equals(other._muscleIds, _muscleIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scope,textFilter,langFilter,difficultyLevel,mechanicsType,forceType,isUnilateral,isBodyweight,const DeepCollectionEquality().hash(_categoryIds),const DeepCollectionEquality().hash(_muscleIds));

@override
String toString() {
  return 'ExerciseFilterModel(scope: $scope, textFilter: $textFilter, langFilter: $langFilter, difficultyLevel: $difficultyLevel, mechanicsType: $mechanicsType, forceType: $forceType, isUnilateral: $isUnilateral, isBodyweight: $isBodyweight, categoryIds: $categoryIds, muscleIds: $muscleIds)';
}


}

/// @nodoc
abstract mixin class _$ExerciseFilterModelCopyWith<$Res> implements $ExerciseFilterModelCopyWith<$Res> {
  factory _$ExerciseFilterModelCopyWith(_ExerciseFilterModel value, $Res Function(_ExerciseFilterModel) _then) = __$ExerciseFilterModelCopyWithImpl;
@override @useResult
$Res call({
 String? scope, String? textFilter, String? langFilter, String? difficultyLevel, String? mechanicsType, String? forceType, bool? isUnilateral, bool? isBodyweight, List<String>? categoryIds, List<String>? muscleIds
});




}
/// @nodoc
class __$ExerciseFilterModelCopyWithImpl<$Res>
    implements _$ExerciseFilterModelCopyWith<$Res> {
  __$ExerciseFilterModelCopyWithImpl(this._self, this._then);

  final _ExerciseFilterModel _self;
  final $Res Function(_ExerciseFilterModel) _then;

/// Create a copy of ExerciseFilterModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scope = freezed,Object? textFilter = freezed,Object? langFilter = freezed,Object? difficultyLevel = freezed,Object? mechanicsType = freezed,Object? forceType = freezed,Object? isUnilateral = freezed,Object? isBodyweight = freezed,Object? categoryIds = freezed,Object? muscleIds = freezed,}) {
  return _then(_ExerciseFilterModel(
scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,textFilter: freezed == textFilter ? _self.textFilter : textFilter // ignore: cast_nullable_to_non_nullable
as String?,langFilter: freezed == langFilter ? _self.langFilter : langFilter // ignore: cast_nullable_to_non_nullable
as String?,difficultyLevel: freezed == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as String?,mechanicsType: freezed == mechanicsType ? _self.mechanicsType : mechanicsType // ignore: cast_nullable_to_non_nullable
as String?,forceType: freezed == forceType ? _self.forceType : forceType // ignore: cast_nullable_to_non_nullable
as String?,isUnilateral: freezed == isUnilateral ? _self.isUnilateral : isUnilateral // ignore: cast_nullable_to_non_nullable
as bool?,isBodyweight: freezed == isBodyweight ? _self.isBodyweight : isBodyweight // ignore: cast_nullable_to_non_nullable
as bool?,categoryIds: freezed == categoryIds ? _self._categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>?,muscleIds: freezed == muscleIds ? _self._muscleIds : muscleIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
