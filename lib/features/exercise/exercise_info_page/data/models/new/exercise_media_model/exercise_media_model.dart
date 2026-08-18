// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_media_model.freezed.dart';
part 'exercise_media_model.g.dart';

@freezed
abstract class ExerciseMediaModel with _$ExerciseMediaModel {
  const factory ExerciseMediaModel({
    @Default('') String id,
    @Default('') String mediaType,
    @Default('') String mediaUrl,
    @Default('') String thumbnailUrl,
    @Default('') String mediaPurpose,
    @Default('') String viewAngle,
    @JsonKey(name: 'primary') @Default(false) bool isPrimary,
    @JsonKey(name: 'public') @Default(false) bool isPublic,
  }) = _ExerciseMediaModel;

  factory ExerciseMediaModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseMediaModelFromJson(json);
}
