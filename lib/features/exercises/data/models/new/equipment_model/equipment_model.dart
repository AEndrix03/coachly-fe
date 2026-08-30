import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment_model.freezed.dart';
part 'equipment_model.g.dart';

@freezed
abstract class EquipmentModel with _$EquipmentModel {
  const factory EquipmentModel({
    required String id,
    required String code,
    required Map<String, String> nameI18n,
    required Map<String, String> descriptionI18n,
  }) = _EquipmentModel;

  factory EquipmentModel.fromJson(Map<String, dynamic> json) =>
      _$EquipmentModelFromJson(json);
}
