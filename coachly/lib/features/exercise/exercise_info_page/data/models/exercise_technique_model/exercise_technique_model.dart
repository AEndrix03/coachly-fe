import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_technique_model.freezed.dart';
part 'exercise_technique_model.g.dart';

@freezed
@JsonSerializable()
class ExerciseTechniqueModel with _$ExerciseTechniqueModel {
  final String title;
  final String description;
  final int iconCodePoint;
  final List<int> iconGradient;

  const ExerciseTechniqueModel({
    required this.title,
    required this.description,
    required this.iconCodePoint,
    required this.iconGradient,
  });

  factory ExerciseTechniqueModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseTechniqueModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseTechniqueModelToJson(this);
}
