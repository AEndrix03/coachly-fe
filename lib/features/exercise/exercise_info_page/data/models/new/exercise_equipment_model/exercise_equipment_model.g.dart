// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_equipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseEquipmentModel _$ExerciseEquipmentModelFromJson(
  Map<String, dynamic> json,
) => _ExerciseEquipmentModel(
  equipment: EquipmentModel.fromJson(json['equipment'] as Map<String, dynamic>),
  isRequired: json['required'] as bool? ?? false,
  isPrimary: json['primary'] as bool? ?? false,
  quantityNeeded: (json['quantityNeeded'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ExerciseEquipmentModelToJson(
  _ExerciseEquipmentModel instance,
) => <String, dynamic>{
  'equipment': instance.equipment,
  'required': instance.isRequired,
  'primary': instance.isPrimary,
  'quantityNeeded': instance.quantityNeeded,
};
