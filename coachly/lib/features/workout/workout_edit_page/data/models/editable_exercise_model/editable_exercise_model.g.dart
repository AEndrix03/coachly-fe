// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editable_exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditableExerciseModel _$EditableExerciseModelFromJson(
  Map<String, dynamic> json,
) => EditableExerciseModel(
  id: json['id'] as String,
  exerciseId: json['exerciseId'] as String,
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  muscle: json['muscle'] as String,
  difficulty: json['difficulty'] as String,
  sets: json['sets'] as String,
  rest: json['rest'] as String,
  weight: json['weight'] as String,
  progress: json['progress'] as String,
  notes: json['notes'] as String,
  accentColorHex: json['accentColorHex'] as String,
  hasVariants: json['hasVariants'] as bool,
);

Map<String, dynamic> _$EditableExerciseModelToJson(
  EditableExerciseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'exerciseId': instance.exerciseId,
  'number': instance.number,
  'name': instance.name,
  'muscle': instance.muscle,
  'difficulty': instance.difficulty,
  'sets': instance.sets,
  'rest': instance.rest,
  'weight': instance.weight,
  'progress': instance.progress,
  'notes': instance.notes,
  'accentColorHex': instance.accentColorHex,
  'hasVariants': instance.hasVariants,
};
