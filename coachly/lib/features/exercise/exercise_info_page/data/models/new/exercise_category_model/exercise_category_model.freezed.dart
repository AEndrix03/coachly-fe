// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseCategoryModel {

 String get id; String get code; Map<String, String> get nameI18n; Map<String, String> get descriptionI18n; int get categoryLevel; bool? get isPrimary; List<ExerciseCategoryModel> get children;
/// Create a copy of ExerciseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCategoryModelCopyWith<ExerciseCategoryModel> get copyWith => _$ExerciseCategoryModelCopyWithImpl<ExerciseCategoryModel>(this as ExerciseCategoryModel, _$identity);

  /// Serializes this ExerciseCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.nameI18n, nameI18n)&&const DeepCollectionEquality().equals(other.descriptionI18n, descriptionI18n)&&(identical(other.categoryLevel, categoryLevel) || other.categoryLevel == categoryLevel)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,const DeepCollectionEquality().hash(nameI18n),const DeepCollectionEquality().hash(descriptionI18n),categoryLevel,isPrimary,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'ExerciseCategoryModel(id: $id, code: $code, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n, categoryLevel: $categoryLevel, isPrimary: $isPrimary, children: $children)';
}


}

/// @nodoc
abstract mixin class $ExerciseCategoryModelCopyWith<$Res>  {
  factory $ExerciseCategoryModelCopyWith(ExerciseCategoryModel value, $Res Function(ExerciseCategoryModel) _then) = _$ExerciseCategoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, Map<String, String> nameI18n, Map<String, String> descriptionI18n, int categoryLevel, bool? isPrimary, List<ExerciseCategoryModel> children
});




}
/// @nodoc
class _$ExerciseCategoryModelCopyWithImpl<$Res>
    implements $ExerciseCategoryModelCopyWith<$Res> {
  _$ExerciseCategoryModelCopyWithImpl(this._self, this._then);

  final ExerciseCategoryModel _self;
  final $Res Function(ExerciseCategoryModel) _then;

/// Create a copy of ExerciseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? nameI18n = null,Object? descriptionI18n = null,Object? categoryLevel = null,Object? isPrimary = freezed,Object? children = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameI18n: null == nameI18n ? _self.nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self.descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,categoryLevel: null == categoryLevel ? _self.categoryLevel : categoryLevel // ignore: cast_nullable_to_non_nullable
as int,isPrimary: freezed == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ExerciseCategoryModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseCategoryModel].
extension ExerciseCategoryModelPatterns on ExerciseCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  int categoryLevel,  bool? isPrimary,  List<ExerciseCategoryModel> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseCategoryModel() when $default != null:
return $default(_that.id,_that.code,_that.nameI18n,_that.descriptionI18n,_that.categoryLevel,_that.isPrimary,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  int categoryLevel,  bool? isPrimary,  List<ExerciseCategoryModel> children)  $default,) {final _that = this;
switch (_that) {
case _ExerciseCategoryModel():
return $default(_that.id,_that.code,_that.nameI18n,_that.descriptionI18n,_that.categoryLevel,_that.isPrimary,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  int categoryLevel,  bool? isPrimary,  List<ExerciseCategoryModel> children)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseCategoryModel() when $default != null:
return $default(_that.id,_that.code,_that.nameI18n,_that.descriptionI18n,_that.categoryLevel,_that.isPrimary,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseCategoryModel implements ExerciseCategoryModel {
  const _ExerciseCategoryModel({required this.id, required this.code, required final  Map<String, String> nameI18n, required final  Map<String, String> descriptionI18n, required this.categoryLevel, this.isPrimary, final  List<ExerciseCategoryModel> children = const []}): _nameI18n = nameI18n,_descriptionI18n = descriptionI18n,_children = children;
  factory _ExerciseCategoryModel.fromJson(Map<String, dynamic> json) => _$ExerciseCategoryModelFromJson(json);

@override final  String id;
@override final  String code;
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

@override final  int categoryLevel;
@override final  bool? isPrimary;
 final  List<ExerciseCategoryModel> _children;
@override@JsonKey() List<ExerciseCategoryModel> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of ExerciseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCategoryModelCopyWith<_ExerciseCategoryModel> get copyWith => __$ExerciseCategoryModelCopyWithImpl<_ExerciseCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._nameI18n, _nameI18n)&&const DeepCollectionEquality().equals(other._descriptionI18n, _descriptionI18n)&&(identical(other.categoryLevel, categoryLevel) || other.categoryLevel == categoryLevel)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,const DeepCollectionEquality().hash(_nameI18n),const DeepCollectionEquality().hash(_descriptionI18n),categoryLevel,isPrimary,const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'ExerciseCategoryModel(id: $id, code: $code, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n, categoryLevel: $categoryLevel, isPrimary: $isPrimary, children: $children)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCategoryModelCopyWith<$Res> implements $ExerciseCategoryModelCopyWith<$Res> {
  factory _$ExerciseCategoryModelCopyWith(_ExerciseCategoryModel value, $Res Function(_ExerciseCategoryModel) _then) = __$ExerciseCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, Map<String, String> nameI18n, Map<String, String> descriptionI18n, int categoryLevel, bool? isPrimary, List<ExerciseCategoryModel> children
});




}
/// @nodoc
class __$ExerciseCategoryModelCopyWithImpl<$Res>
    implements _$ExerciseCategoryModelCopyWith<$Res> {
  __$ExerciseCategoryModelCopyWithImpl(this._self, this._then);

  final _ExerciseCategoryModel _self;
  final $Res Function(_ExerciseCategoryModel) _then;

/// Create a copy of ExerciseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? nameI18n = null,Object? descriptionI18n = null,Object? categoryLevel = null,Object? isPrimary = freezed,Object? children = null,}) {
  return _then(_ExerciseCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameI18n: null == nameI18n ? _self._nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self._descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,categoryLevel: null == categoryLevel ? _self.categoryLevel : categoryLevel // ignore: cast_nullable_to_non_nullable
as int,isPrimary: freezed == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ExerciseCategoryModel>,
  ));
}


}

// dart format on
