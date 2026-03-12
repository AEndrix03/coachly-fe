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
  muscles: (json['muscles'] as List<dynamic>).map((e) => e as String).toList(),
  difficulty: json['difficulty'] as String,
  sets: json['sets'] as String,
  rest: json['rest'] as String,
  weight: json['weight'] as String,
  progress: json['progress'] as String,
  notes: json['notes'] as String,
  accentColorHex: json['accentColorHex'] as String,
  variants: (json['variants'] as List<dynamic>)
      .map((e) => ExerciseVariantModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EditableExerciseModelToJson(
  EditableExerciseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'exerciseId': instance.exerciseId,
  'number': instance.number,
  'name': instance.name,
  'muscles': instance.muscles,
  'difficulty': instance.difficulty,
  'sets': instance.sets,
  'rest': instance.rest,
  'weight': instance.weight,
  'progress': instance.progress,
  'notes': instance.notes,
  'accentColorHex': instance.accentColorHex,
  'variants': instance.variants,
};
