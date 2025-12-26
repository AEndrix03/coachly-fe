import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_media_model.freezed.dart';
part 'exercise_media_model.g.dart';

@freezed
abstract class ExerciseMediaModel with _$ExerciseMediaModel {
  const factory ExerciseMediaModel({
    required String id,
    required String mediaType,
    required String mediaUrl,
    required String thumbnailUrl,
    required String mediaPurpose,
    required String viewAngle,
    required bool isPrimary,
    required bool isPublic,
  }) = _ExerciseMediaModel;

  factory ExerciseMediaModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseMediaModelFromJson(json);
}
