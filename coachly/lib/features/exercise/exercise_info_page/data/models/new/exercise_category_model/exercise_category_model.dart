import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_category_model.freezed.dart';
part 'exercise_category_model.g.dart';

@freezed
abstract class ExerciseCategoryModel with _$ExerciseCategoryModel {
  const factory ExerciseCategoryModel({
    required String id,
    required String code,
    required Map<String, String> nameI18n,
    required Map<String, String> descriptionI18n,
    required int categoryLevel,
    bool? isPrimary,
    @Default([]) List<ExerciseCategoryModel> children,
  }) = _ExerciseCategoryModel;

  factory ExerciseCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseCategoryModelFromJson(json);
}
