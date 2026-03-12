// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_media_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseMediaModel {

 String get id; String get mediaType; String get mediaUrl; String get thumbnailUrl; String get mediaPurpose; String get viewAngle; bool get isPrimary; bool get isPublic;
/// Create a copy of ExerciseMediaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseMediaModelCopyWith<ExerciseMediaModel> get copyWith => _$ExerciseMediaModelCopyWithImpl<ExerciseMediaModel>(this as ExerciseMediaModel, _$identity);

  /// Serializes this ExerciseMediaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.mediaPurpose, mediaPurpose) || other.mediaPurpose == mediaPurpose)&&(identical(other.viewAngle, viewAngle) || other.viewAngle == viewAngle)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaType,mediaUrl,thumbnailUrl,mediaPurpose,viewAngle,isPrimary,isPublic);

@override
String toString() {
  return 'ExerciseMediaModel(id: $id, mediaType: $mediaType, mediaUrl: $mediaUrl, thumbnailUrl: $thumbnailUrl, mediaPurpose: $mediaPurpose, viewAngle: $viewAngle, isPrimary: $isPrimary, isPublic: $isPublic)';
}


}

/// @nodoc
abstract mixin class $ExerciseMediaModelCopyWith<$Res>  {
  factory $ExerciseMediaModelCopyWith(ExerciseMediaModel value, $Res Function(ExerciseMediaModel) _then) = _$ExerciseMediaModelCopyWithImpl;
@useResult
$Res call({
 String id, String mediaType, String mediaUrl, String thumbnailUrl, String mediaPurpose, String viewAngle, bool isPrimary, bool isPublic
});




}
/// @nodoc
class _$ExerciseMediaModelCopyWithImpl<$Res>
    implements $ExerciseMediaModelCopyWith<$Res> {
  _$ExerciseMediaModelCopyWithImpl(this._self, this._then);

  final ExerciseMediaModel _self;
  final $Res Function(ExerciseMediaModel) _then;

/// Create a copy of ExerciseMediaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mediaType = null,Object? mediaUrl = null,Object? thumbnailUrl = null,Object? mediaPurpose = null,Object? viewAngle = null,Object? isPrimary = null,Object? isPublic = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,mediaPurpose: null == mediaPurpose ? _self.mediaPurpose : mediaPurpose // ignore: cast_nullable_to_non_nullable
as String,viewAngle: null == viewAngle ? _self.viewAngle : viewAngle // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseMediaModel].
extension ExerciseMediaModelPatterns on ExerciseMediaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseMediaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseMediaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseMediaModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseMediaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseMediaModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseMediaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String mediaType,  String mediaUrl,  String thumbnailUrl,  String mediaPurpose,  String viewAngle,  bool isPrimary,  bool isPublic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseMediaModel() when $default != null:
return $default(_that.id,_that.mediaType,_that.mediaUrl,_that.thumbnailUrl,_that.mediaPurpose,_that.viewAngle,_that.isPrimary,_that.isPublic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String mediaType,  String mediaUrl,  String thumbnailUrl,  String mediaPurpose,  String viewAngle,  bool isPrimary,  bool isPublic)  $default,) {final _that = this;
switch (_that) {
case _ExerciseMediaModel():
return $default(_that.id,_that.mediaType,_that.mediaUrl,_that.thumbnailUrl,_that.mediaPurpose,_that.viewAngle,_that.isPrimary,_that.isPublic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String mediaType,  String mediaUrl,  String thumbnailUrl,  String mediaPurpose,  String viewAngle,  bool isPrimary,  bool isPublic)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseMediaModel() when $default != null:
return $default(_that.id,_that.mediaType,_that.mediaUrl,_that.thumbnailUrl,_that.mediaPurpose,_that.viewAngle,_that.isPrimary,_that.isPublic);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseMediaModel implements ExerciseMediaModel {
  const _ExerciseMediaModel({required this.id, required this.mediaType, required this.mediaUrl, required this.thumbnailUrl, required this.mediaPurpose, required this.viewAngle, required this.isPrimary, required this.isPublic});
  factory _ExerciseMediaModel.fromJson(Map<String, dynamic> json) => _$ExerciseMediaModelFromJson(json);

@override final  String id;
@override final  String mediaType;
@override final  String mediaUrl;
@override final  String thumbnailUrl;
@override final  String mediaPurpose;
@override final  String viewAngle;
@override final  bool isPrimary;
@override final  bool isPublic;

/// Create a copy of ExerciseMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseMediaModelCopyWith<_ExerciseMediaModel> get copyWith => __$ExerciseMediaModelCopyWithImpl<_ExerciseMediaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseMediaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.mediaPurpose, mediaPurpose) || other.mediaPurpose == mediaPurpose)&&(identical(other.viewAngle, viewAngle) || other.viewAngle == viewAngle)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaType,mediaUrl,thumbnailUrl,mediaPurpose,viewAngle,isPrimary,isPublic);

@override
String toString() {
  return 'ExerciseMediaModel(id: $id, mediaType: $mediaType, mediaUrl: $mediaUrl, thumbnailUrl: $thumbnailUrl, mediaPurpose: $mediaPurpose, viewAngle: $viewAngle, isPrimary: $isPrimary, isPublic: $isPublic)';
}


}

/// @nodoc
abstract mixin class _$ExerciseMediaModelCopyWith<$Res> implements $ExerciseMediaModelCopyWith<$Res> {
  factory _$ExerciseMediaModelCopyWith(_ExerciseMediaModel value, $Res Function(_ExerciseMediaModel) _then) = __$ExerciseMediaModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String mediaType, String mediaUrl, String thumbnailUrl, String mediaPurpose, String viewAngle, bool isPrimary, bool isPublic
});




}
/// @nodoc
class __$ExerciseMediaModelCopyWithImpl<$Res>
    implements _$ExerciseMediaModelCopyWith<$Res> {
  __$ExerciseMediaModelCopyWithImpl(this._self, this._then);

  final _ExerciseMediaModel _self;
  final $Res Function(_ExerciseMediaModel) _then;

/// Create a copy of ExerciseMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mediaType = null,Object? mediaUrl = null,Object? thumbnailUrl = null,Object? mediaPurpose = null,Object? viewAngle = null,Object? isPrimary = null,Object? isPublic = null,}) {
  return _then(_ExerciseMediaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,mediaPurpose: null == mediaPurpose ? _self.mediaPurpose : mediaPurpose // ignore: cast_nullable_to_non_nullable
as String,viewAngle: null == viewAngle ? _self.viewAngle : viewAngle // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
