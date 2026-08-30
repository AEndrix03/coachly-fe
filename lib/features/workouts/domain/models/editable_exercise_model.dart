import 'dart:ui';

import 'package:coachly/features/exercises/data/models/new/exercise_variant_model/exercise_variant_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'editable_exercise_model.freezed.dart';
part 'editable_exercise_model.g.dart';

@freezed
@JsonSerializable()
class EditableExerciseModel with _$EditableExerciseModel {
  @override
  final String id;
  @override
  final String exerciseId;
  @override
  final int number;
  @override
  final String name;
  @override
  final List<String> muscles;
  @override
  final String difficulty;
  @override
  final String sets;
  @override
  final String rest;
  @override
  final String weight;
  @override
  final String progress;
  @override
  final String notes;
  @override
  final String accentColorHex;
  @override
  final List<ExerciseVariantModel> variants;

  const EditableExerciseModel({
    required this.id,
    required this.exerciseId,
    required this.number,
    required this.name,
    required this.muscles,
    required this.difficulty,
    required this.sets,
    required this.rest,
    required this.weight,
    required this.progress,
    required this.notes,
    required this.accentColorHex,
    required this.variants,
  });

  factory EditableExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$EditableExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditableExerciseModelToJson(this);

  Color get accentColor =>
      Color(int.parse(accentColorHex.replaceFirst('#', '0xff')));
}
