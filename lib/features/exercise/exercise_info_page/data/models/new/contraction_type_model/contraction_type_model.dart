import 'package:freezed_annotation/freezed_annotation.dart';

part 'contraction_type_model.freezed.dart';
part 'contraction_type_model.g.dart';

@freezed
abstract class ContractionTypeModel with _$ContractionTypeModel {
  const factory ContractionTypeModel({
    required String id,
    required String code,
    required Map<String, String> nameI18n,
    required Map<String, String> descriptionI18n,
  }) = _ContractionTypeModel;

  factory ContractionTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ContractionTypeModelFromJson(json);
}
