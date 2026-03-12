// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EquipmentModel {

 String get id; String get code; Map<String, String> get nameI18n; Map<String, String> get descriptionI18n;
/// Create a copy of EquipmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EquipmentModelCopyWith<EquipmentModel> get copyWith => _$EquipmentModelCopyWithImpl<EquipmentModel>(this as EquipmentModel, _$identity);

  /// Serializes this EquipmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EquipmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.nameI18n, nameI18n)&&const DeepCollectionEquality().equals(other.descriptionI18n, descriptionI18n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,const DeepCollectionEquality().hash(nameI18n),const DeepCollectionEquality().hash(descriptionI18n));

@override
String toString() {
  return 'EquipmentModel(id: $id, code: $code, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n)';
}


}

/// @nodoc
abstract mixin class $EquipmentModelCopyWith<$Res>  {
  factory $EquipmentModelCopyWith(EquipmentModel value, $Res Function(EquipmentModel) _then) = _$EquipmentModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, Map<String, String> nameI18n, Map<String, String> descriptionI18n
});




}
/// @nodoc
class _$EquipmentModelCopyWithImpl<$Res>
    implements $EquipmentModelCopyWith<$Res> {
  _$EquipmentModelCopyWithImpl(this._self, this._then);

  final EquipmentModel _self;
  final $Res Function(EquipmentModel) _then;

/// Create a copy of EquipmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? nameI18n = null,Object? descriptionI18n = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameI18n: null == nameI18n ? _self.nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self.descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [EquipmentModel].
extension EquipmentModelPatterns on EquipmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EquipmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EquipmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EquipmentModel value)  $default,){
final _that = this;
switch (_that) {
case _EquipmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EquipmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _EquipmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EquipmentModel() when $default != null:
return $default(_that.id,_that.code,_that.nameI18n,_that.descriptionI18n);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n)  $default,) {final _that = this;
switch (_that) {
case _EquipmentModel():
return $default(_that.id,_that.code,_that.nameI18n,_that.descriptionI18n);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  Map<String, String> nameI18n,  Map<String, String> descriptionI18n)?  $default,) {final _that = this;
switch (_that) {
case _EquipmentModel() when $default != null:
return $default(_that.id,_that.code,_that.nameI18n,_that.descriptionI18n);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EquipmentModel implements EquipmentModel {
  const _EquipmentModel({required this.id, required this.code, required final  Map<String, String> nameI18n, required final  Map<String, String> descriptionI18n}): _nameI18n = nameI18n,_descriptionI18n = descriptionI18n;
  factory _EquipmentModel.fromJson(Map<String, dynamic> json) => _$EquipmentModelFromJson(json);

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


/// Create a copy of EquipmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EquipmentModelCopyWith<_EquipmentModel> get copyWith => __$EquipmentModelCopyWithImpl<_EquipmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EquipmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EquipmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._nameI18n, _nameI18n)&&const DeepCollectionEquality().equals(other._descriptionI18n, _descriptionI18n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,const DeepCollectionEquality().hash(_nameI18n),const DeepCollectionEquality().hash(_descriptionI18n));

@override
String toString() {
  return 'EquipmentModel(id: $id, code: $code, nameI18n: $nameI18n, descriptionI18n: $descriptionI18n)';
}


}

/// @nodoc
abstract mixin class _$EquipmentModelCopyWith<$Res> implements $EquipmentModelCopyWith<$Res> {
  factory _$EquipmentModelCopyWith(_EquipmentModel value, $Res Function(_EquipmentModel) _then) = __$EquipmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, Map<String, String> nameI18n, Map<String, String> descriptionI18n
});




}
/// @nodoc
class __$EquipmentModelCopyWithImpl<$Res>
    implements _$EquipmentModelCopyWith<$Res> {
  __$EquipmentModelCopyWithImpl(this._self, this._then);

  final _EquipmentModel _self;
  final $Res Function(_EquipmentModel) _then;

/// Create a copy of EquipmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? nameI18n = null,Object? descriptionI18n = null,}) {
  return _then(_EquipmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameI18n: null == nameI18n ? _self._nameI18n : nameI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,descriptionI18n: null == descriptionI18n ? _self._descriptionI18n : descriptionI18n // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
