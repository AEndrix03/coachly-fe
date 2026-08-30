// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editable_exercise_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditableExerciseModel {

 String get id; String get exerciseId; int get number; String get name; List<String> get muscles; String get difficulty; String get sets; String get rest; String get weight; String get progress; String get notes; String get accentColorHex; List<ExerciseVariantModel> get variants;
/// Create a copy of EditableExerciseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditableExerciseModelCopyWith<EditableExerciseModel> get copyWith => _$EditableExerciseModelCopyWithImpl<EditableExerciseModel>(this as EditableExerciseModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditableExerciseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.muscles, muscles)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.sets, sets) || other.sets == sets)&&(identical(other.rest, rest) || other.rest == rest)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.accentColorHex, accentColorHex) || other.accentColorHex == accentColorHex)&&const DeepCollectionEquality().equals(other.variants, variants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,exerciseId,number,name,const DeepCollectionEquality().hash(muscles),difficulty,sets,rest,weight,progress,notes,accentColorHex,const DeepCollectionEquality().hash(variants));

@override
String toString() {
  return 'EditableExerciseModel(id: $id, exerciseId: $exerciseId, number: $number, name: $name, muscles: $muscles, difficulty: $difficulty, sets: $sets, rest: $rest, weight: $weight, progress: $progress, notes: $notes, accentColorHex: $accentColorHex, variants: $variants)';
}


}

/// @nodoc
abstract mixin class $EditableExerciseModelCopyWith<$Res>  {
  factory $EditableExerciseModelCopyWith(EditableExerciseModel value, $Res Function(EditableExerciseModel) _then) = _$EditableExerciseModelCopyWithImpl;
@useResult
$Res call({
 String id, String exerciseId, int number, String name, List<String> muscles, String difficulty, String sets, String rest, String weight, String progress, String notes, String accentColorHex, List<ExerciseVariantModel> variants
});




}
/// @nodoc
class _$EditableExerciseModelCopyWithImpl<$Res>
    implements $EditableExerciseModelCopyWith<$Res> {
  _$EditableExerciseModelCopyWithImpl(this._self, this._then);

  final EditableExerciseModel _self;
  final $Res Function(EditableExerciseModel) _then;

/// Create a copy of EditableExerciseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? exerciseId = null,Object? number = null,Object? name = null,Object? muscles = null,Object? difficulty = null,Object? sets = null,Object? rest = null,Object? weight = null,Object? progress = null,Object? notes = null,Object? accentColorHex = null,Object? variants = null,}) {
  return _then(EditableExerciseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,muscles: null == muscles ? _self.muscles : muscles // ignore: cast_nullable_to_non_nullable
as List<String>,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as String,rest: null == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,accentColorHex: null == accentColorHex ? _self.accentColorHex : accentColorHex // ignore: cast_nullable_to_non_nullable
as String,variants: null == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<ExerciseVariantModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [EditableExerciseModel].
extension EditableExerciseModelPatterns on EditableExerciseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
