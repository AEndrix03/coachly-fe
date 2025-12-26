// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TagModel {

 String get id; String get code; Map<String, String> get nameI18n; Map<String, String> get descriptionI18n; String get tagType;
/// Create a copy of TagModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagModelCopyWith<TagModel> get copyWith => _$TagModelCopyWithImpl<TagModel>(this as TagModel, _$identity);

  /// Serializes this TagModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.nameI18n, nameI18n)&&const DeepCollectionEquality().equals(other.descriptionI18n, descriptionI18n)&&(identical(other.tagType, tagType) || other.tagType == tagType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,const DeepCollectionEquality().hash(nameI18n),const DeepCollectionEquality().hash(descriptionI18n),tagType);

@override
String toString() {
  return 'TagModel(id: $id, code: $code, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n, tagType: $tagType)';
}


}

/// @nodoc
abstract mixin class $TagModelCopyWith<$Res>  {
  factory $TagModelCopyWith(TagModel value, $Res Function(TagModel) _then) = _$TagModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, Map<String, String> nameI18n, Map<String, String> descriptionI18n, String tagType
});




}
/// @nodoc
class _$TagModelCopyWithImpl<$Res>
    implements $TagModelCopyWith<$Res> {
  _$TagModelCopyWithImpl(this._self, this._then);

  final TagModel _self;
  final $Res Function(TagModel) _then;

/// Create a copy of TagModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? nameI18n = null,Object? descriptionI18n = null,Object? tagType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameI18n: null == nameI18n ? _self.nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self.descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,tagType: null == tagType ? _self.tagType : tagType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TagModel].
extension TagModelPatterns on TagModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagModel value)  $default,){
final _that = this;
switch (_that) {
case _TagModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagModel value)?  $default,){
final _that = this;
switch (_that) {
case _TagModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  String tagType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagModel() when $default != null:
return $default(_that.id,_that.code,_that.nameI18n,_that.descriptionI18n,_that.tagType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  String tagType)  $default,) {final _that = this;
switch (_that) {
case _TagModel():
return $default(_that.id,_that.code,_that.nameI18n,_that.descriptionI18n,_that.tagType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n,  String tagType)?  $default,) {final _that = this;
switch (_that) {
case _TagModel() when $default != null:
return $default(_that.id,_that.code,_that.nameI18n,_that.descriptionI18n,_that.tagType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TagModel implements TagModel {
  const _TagModel({required this.id, required this.code, required final  Map<String, String> nameI18n, required final  Map<String, String> descriptionI18n, required this.tagType}): _nameI18n = nameI18n,_descriptionI18n = descriptionI18n;
  factory _TagModel.fromJson(Map<String, dynamic> json) => _$TagModelFromJson(json);

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

@override final  String tagType;

/// Create a copy of TagModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagModelCopyWith<_TagModel> get copyWith => __$TagModelCopyWithImpl<_TagModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TagModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._nameI18n, _nameI18n)&&const DeepCollectionEquality().equals(other._descriptionI18n, _descriptionI18n)&&(identical(other.tagType, tagType) || other.tagType == tagType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,const DeepCollectionEquality().hash(_nameI18n),const DeepCollectionEquality().hash(_descriptionI18n),tagType);

@override
String toString() {
  return 'TagModel(id: $id, code: $code, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n, tagType: $tagType)';
}


}

/// @nodoc
abstract mixin class _$TagModelCopyWith<$Res> implements $TagModelCopyWith<$Res> {
  factory _$TagModelCopyWith(_TagModel value, $Res Function(_TagModel) _then) = __$TagModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, Map<String, String> nameI18n, Map<String, String> descriptionI18n, String tagType
});




}
/// @nodoc
class __$TagModelCopyWithImpl<$Res>
    implements _$TagModelCopyWith<$Res> {
  __$TagModelCopyWithImpl(this._self, this._then);

  final _TagModel _self;
  final $Res Function(_TagModel) _then;

/// Create a copy of TagModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? nameI18n = null,Object? descriptionI18n = null,Object? tagType = null,}) {
  return _then(_TagModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameI18n: null == nameI18n ? _self._nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self._descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,tagType: null == tagType ? _self.tagType : tagType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
