import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'editable_exercise_model.freezed.dart';
part 'editable_exercise_model.g.dart';

@freezed
@JsonSerializable()
class EditableExerciseModel with _$EditableExerciseModel {
  final String id;
  final String exerciseId;
  final int number;
  final String name;
  final String muscle;
  final String difficulty;
  final String sets;
  final String rest;
  final String weight;
  final String progress;
  final String notes;
  final String accentColorHex;
  final bool hasVariants;

  const EditableExerciseModel({
    required this.id,
    required this.exerciseId,
    required this.number,
    required this.name,
    required this.muscle,
    required this.difficulty,
    required this.sets,
    required this.rest,
    required this.weight,
    required this.progress,
    required this.notes,
    required this.accentColorHex,
    required this.hasVariants,
  });

  factory EditableExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$EditableExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditableExerciseModelToJson(this);

  Color get accentColor =>
      Color(int.parse(accentColorHex.replaceFirst('#', '0xff')));
}
