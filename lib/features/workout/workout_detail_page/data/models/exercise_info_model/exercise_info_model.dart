import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_info_model.freezed.dart';
part 'exercise_info_model.g.dart';

@freezed
@JsonSerializable()
class ExerciseInfoModel with _$ExerciseInfoModel {
  final int number;
  final String name;
  final String muscle;
  final String difficulty;
  final String sets;
  final String rest;
  final String weight;
  final String progress;
  final String accentColorHex;

  const ExerciseInfoModel({
    required this.number,
    required this.name,
    required this.muscle,
    required this.difficulty,
    required this.sets,
    required this.rest,
    required this.weight,
    required this.progress,
    required this.accentColorHex,
  });

  factory ExerciseInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseInfoModelToJson(this);

  Color get accentColor =>
      Color(int.parse(accentColorHex.replaceFirst('#', '0xff')));
}
