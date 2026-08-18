// ignore_for_file: invalid_annotation_target

import 'package:coachly/features/exercise/exercise_info_page/data/models/new/equipment_model/equipment_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_equipment_model.freezed.dart';
part 'exercise_equipment_model.g.dart';

@freezed
abstract class ExerciseEquipmentModel with _$ExerciseEquipmentModel {
  const factory ExerciseEquipmentModel({
    required EquipmentModel equipment,
    @JsonKey(name: 'required') @Default(false) bool isRequired,
    @JsonKey(name: 'primary') @Default(false) bool isPrimary,
    @Default(0) int quantityNeeded,
  }) = _ExerciseEquipmentModel;

  factory ExerciseEquipmentModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseEquipmentModelFromJson(json);
}
