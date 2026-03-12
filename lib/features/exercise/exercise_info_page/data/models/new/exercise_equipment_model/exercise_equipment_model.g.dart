// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_equipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseEquipmentModel _$ExerciseEquipmentModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseEquipmentModel(
  equipment: EquipmentModel.fromJson(json['equipment'] as Map<String, dynamic>),
  isRequired: json['isRequired'] as bool,
  isPrimary: json['isPrimary'] as bool,
  quantityNeeded: (json['quantityNeeded'] as num).toInt(),
);

Map<String, dynamic> _$ExerciseEquipmentModelToJson(
  _ExerciseEquipmentModel instance,
) => <String, dynamic>{
  'equipment': instance.equipment,
  'isRequired': instance.isRequired,
  'isPrimary': instance.isPrimary,
  'quantityNeeded': instance.quantityNeeded,
};
