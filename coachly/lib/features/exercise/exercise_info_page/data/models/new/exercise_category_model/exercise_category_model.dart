import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_category_model.freezed.dart';
part 'exercise_category_model.g.dart';

@freezed
abstract class ExerciseCategoryModel with _$ExerciseCategoryModel {
  const factory ExerciseCategoryModel({
    @Default(null) String? id,
    @Default(null) String? code,
    @MapConverter() @Default(null) Map<String, String>? nameI18n,
    @MapConverter() @Default(null) Map<String, String>? descriptionI18n,
    @Default(null) int? categoryLevel,
    @Default(null) bool? isPrimary,
    @Default(null) List<ExerciseCategoryModel>? children,
  }) = _ExerciseCategoryModel;

  factory ExerciseCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseCategoryModelFromJson(json);
}
