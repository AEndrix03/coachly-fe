import 'package:freezed_annotation/freezed_annotation.dart';

part 'muscle_model.freezed.dart';
part 'muscle_model.g.dart';

@freezed
abstract class MuscleModel with _$MuscleModel {
  const factory MuscleModel({
    required String id,
    required String code,
    required Map<String, String> nameI18n,
    required Map<String, String> descriptionI18n,
  }) = _MuscleModel;

  factory MuscleModel.fromJson(Map<String, dynamic> json) =>
      _$MuscleModelFromJson(json);
}
