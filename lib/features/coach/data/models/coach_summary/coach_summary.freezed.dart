// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoachSummary {

 String get id; String get displayName; String get handle; String? get avatarUrl; String get accentColorHex; List<String> get specialties; double get rating; int get activeClients; int get avgResponseHours; double get retentionRate; bool get isVerified; bool get acceptingClients; String? get priceRangeLabel; String get modalityLabel;
/// Create a copy of CoachSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachSummaryCopyWith<CoachSummary> get copyWith => _$CoachSummaryCopyWithImpl<CoachSummary>(this as CoachSummary, _$identity);

  /// Serializes this CoachSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.accentColorHex, accentColorHex) || other.accentColorHex == accentColorHex)&&const DeepCollectionEquality().equals(other.specialties, specialties)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.activeClients, activeClients) || other.activeClients == activeClients)&&(identical(other.avgResponseHours, avgResponseHours) || other.avgResponseHours == avgResponseHours)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.acceptingClients, acceptingClients) || other.acceptingClients == acceptingClients)&&(identical(other.priceRangeLabel, priceRangeLabel) || other.priceRangeLabel == priceRangeLabel)&&(identical(other.modalityLabel, modalityLabel) || other.modalityLabel == modalityLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,handle,avatarUrl,accentColorHex,const DeepCollectionEquality().hash(specialties),rating,activeClients,avgResponseHours,retentionRate,isVerified,acceptingClients,priceRangeLabel,modalityLabel);

@override
String toString() {
  return 'CoachSummary(id: $id, displayName: $displayName, handle: $handle, avatarUrl: $avatarUrl, accentColorHex: $accentColorHex, specialties: $specialties, rating: $rating, activeClients: $activeClients, avgResponseHours: $avgResponseHours, retentionRate: $retentionRate, isVerified: $isVerified, acceptingClients: $acceptingClients, priceRangeLabel: $priceRangeLabel, modalityLabel: $modalityLabel)';
}


}

/// @nodoc
abstract mixin class $CoachSummaryCopyWith<$Res>  {
  factory $CoachSummaryCopyWith(CoachSummary value, $Res Function(CoachSummary) _then) = _$CoachSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String handle, String? avatarUrl, String accentColorHex, List<String> specialties, double rating, int activeClients, int avgResponseHours, double retentionRate, bool isVerified, bool acceptingClients, String? priceRangeLabel, String modalityLabel
});




}
/// @nodoc
class _$CoachSummaryCopyWithImpl<$Res>
    implements $CoachSummaryCopyWith<$Res> {
  _$CoachSummaryCopyWithImpl(this._self, this._then);

  final CoachSummary _self;
  final $Res Function(CoachSummary) _then;

/// Create a copy of CoachSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? handle = null,Object? avatarUrl = freezed,Object? accentColorHex = null,Object? specialties = null,Object? rating = null,Object? activeClients = null,Object? avgResponseHours = null,Object? retentionRate = null,Object? isVerified = null,Object? acceptingClients = null,Object? priceRangeLabel = freezed,Object? modalityLabel = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,accentColorHex: null == accentColorHex ? _self.accentColorHex : accentColorHex // ignore: cast_nullable_to_non_nullable
as String,specialties: null == specialties ? _self.specialties : specialties // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,activeClients: null == activeClients ? _self.activeClients : activeClients // ignore: cast_nullable_to_non_nullable
as int,avgResponseHours: null == avgResponseHours ? _self.avgResponseHours : avgResponseHours // ignore: cast_nullable_to_non_nullable
as int,retentionRate: null == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as double,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,acceptingClients: null == acceptingClients ? _self.acceptingClients : acceptingClients // ignore: cast_nullable_to_non_nullable
as bool,priceRangeLabel: freezed == priceRangeLabel ? _self.priceRangeLabel : priceRangeLabel // ignore: cast_nullable_to_non_nullable
as String?,modalityLabel: null == modalityLabel ? _self.modalityLabel : modalityLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachSummary].
extension CoachSummaryPatterns on CoachSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachSummary value)  $default,){
final _that = this;
switch (_that) {
case _CoachSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CoachSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String handle,  String? avatarUrl,  String accentColorHex,  List<String> specialties,  double rating,  int activeClients,  int avgResponseHours,  double retentionRate,  bool isVerified,  bool acceptingClients,  String? priceRangeLabel,  String modalityLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachSummary() when $default != null:
return $default(_that.id,_that.displayName,_that.handle,_that.avatarUrl,_that.accentColorHex,_that.specialties,_that.rating,_that.activeClients,_that.avgResponseHours,_that.retentionRate,_that.isVerified,_that.acceptingClients,_that.priceRangeLabel,_that.modalityLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String handle,  String? avatarUrl,  String accentColorHex,  List<String> specialties,  double rating,  int activeClients,  int avgResponseHours,  double retentionRate,  bool isVerified,  bool acceptingClients,  String? priceRangeLabel,  String modalityLabel)  $default,) {final _that = this;
switch (_that) {
case _CoachSummary():
return $default(_that.id,_that.displayName,_that.handle,_that.avatarUrl,_that.accentColorHex,_that.specialties,_that.rating,_that.activeClients,_that.avgResponseHours,_that.retentionRate,_that.isVerified,_that.acceptingClients,_that.priceRangeLabel,_that.modalityLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String handle,  String? avatarUrl,  String accentColorHex,  List<String> specialties,  double rating,  int activeClients,  int avgResponseHours,  double retentionRate,  bool isVerified,  bool acceptingClients,  String? priceRangeLabel,  String modalityLabel)?  $default,) {final _that = this;
switch (_that) {
case _CoachSummary() when $default != null:
return $default(_that.id,_that.displayName,_that.handle,_that.avatarUrl,_that.accentColorHex,_that.specialties,_that.rating,_that.activeClients,_that.avgResponseHours,_that.retentionRate,_that.isVerified,_that.acceptingClients,_that.priceRangeLabel,_that.modalityLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoachSummary implements CoachSummary {
  const _CoachSummary({required this.id, required this.displayName, required this.handle, this.avatarUrl, required this.accentColorHex, final  List<String> specialties = const <String>[], required this.rating, required this.activeClients, required this.avgResponseHours, required this.retentionRate, required this.isVerified, required this.acceptingClients, this.priceRangeLabel, required this.modalityLabel}): _specialties = specialties;
  factory _CoachSummary.fromJson(Map<String, dynamic> json) => _$CoachSummaryFromJson(json);

@override final  String id;
@override final  String displayName;
@override final  String handle;
@override final  String? avatarUrl;
@override final  String accentColorHex;
 final  List<String> _specialties;
@override@JsonKey() List<String> get specialties {
  if (_specialties is EqualUnmodifiableListView) return _specialties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specialties);
}

@override final  double rating;
@override final  int activeClients;
@override final  int avgResponseHours;
@override final  double retentionRate;
@override final  bool isVerified;
@override final  bool acceptingClients;
@override final  String? priceRangeLabel;
@override final  String modalityLabel;

/// Create a copy of CoachSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachSummaryCopyWith<_CoachSummary> get copyWith => __$CoachSummaryCopyWithImpl<_CoachSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.accentColorHex, accentColorHex) || other.accentColorHex == accentColorHex)&&const DeepCollectionEquality().equals(other._specialties, _specialties)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.activeClients, activeClients) || other.activeClients == activeClients)&&(identical(other.avgResponseHours, avgResponseHours) || other.avgResponseHours == avgResponseHours)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.acceptingClients, acceptingClients) || other.acceptingClients == acceptingClients)&&(identical(other.priceRangeLabel, priceRangeLabel) || other.priceRangeLabel == priceRangeLabel)&&(identical(other.modalityLabel, modalityLabel) || other.modalityLabel == modalityLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,handle,avatarUrl,accentColorHex,const DeepCollectionEquality().hash(_specialties),rating,activeClients,avgResponseHours,retentionRate,isVerified,acceptingClients,priceRangeLabel,modalityLabel);

@override
String toString() {
  return 'CoachSummary(id: $id, displayName: $displayName, handle: $handle, avatarUrl: $avatarUrl, accentColorHex: $accentColorHex, specialties: $specialties, rating: $rating, activeClients: $activeClients, avgResponseHours: $avgResponseHours, retentionRate: $retentionRate, isVerified: $isVerified, acceptingClients: $acceptingClients, priceRangeLabel: $priceRangeLabel, modalityLabel: $modalityLabel)';
}


}

/// @nodoc
abstract mixin class _$CoachSummaryCopyWith<$Res> implements $CoachSummaryCopyWith<$Res> {
  factory _$CoachSummaryCopyWith(_CoachSummary value, $Res Function(_CoachSummary) _then) = __$CoachSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String handle, String? avatarUrl, String accentColorHex, List<String> specialties, double rating, int activeClients, int avgResponseHours, double retentionRate, bool isVerified, bool acceptingClients, String? priceRangeLabel, String modalityLabel
});




}
/// @nodoc
class __$CoachSummaryCopyWithImpl<$Res>
    implements _$CoachSummaryCopyWith<$Res> {
  __$CoachSummaryCopyWithImpl(this._self, this._then);

  final _CoachSummary _self;
  final $Res Function(_CoachSummary) _then;

/// Create a copy of CoachSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? handle = null,Object? avatarUrl = freezed,Object? accentColorHex = null,Object? specialties = null,Object? rating = null,Object? activeClients = null,Object? avgResponseHours = null,Object? retentionRate = null,Object? isVerified = null,Object? acceptingClients = null,Object? priceRangeLabel = freezed,Object? modalityLabel = null,}) {
  return _then(_CoachSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,accentColorHex: null == accentColorHex ? _self.accentColorHex : accentColorHex // ignore: cast_nullable_to_non_nullable
as String,specialties: null == specialties ? _self._specialties : specialties // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,activeClients: null == activeClients ? _self.activeClients : activeClients // ignore: cast_nullable_to_non_nullable
as int,avgResponseHours: null == avgResponseHours ? _self.avgResponseHours : avgResponseHours // ignore: cast_nullable_to_non_nullable
as int,retentionRate: null == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as double,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,acceptingClients: null == acceptingClients ? _self.acceptingClients : acceptingClients // ignore: cast_nullable_to_non_nullable
as bool,priceRangeLabel: freezed == priceRangeLabel ? _self.priceRangeLabel : priceRangeLabel // ignore: cast_nullable_to_non_nullable
as String?,modalityLabel: null == modalityLabel ? _self.modalityLabel : modalityLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
