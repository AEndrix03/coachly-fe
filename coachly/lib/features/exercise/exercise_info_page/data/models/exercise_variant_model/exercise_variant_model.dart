import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_variant_model.freezed.dart';
part 'exercise_variant_model.g.dart';

@freezed
@JsonSerializable()
class ExerciseVariantModel with _$ExerciseVariantModel {
  final String title;
  final String subtitle;
  final String emphasis;
  final int iconCodePoint;

  const ExerciseVariantModel({
    required this.title,
    required this.subtitle,
    required this.emphasis,
    required this.iconCodePoint,
  });

  factory ExerciseVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseVariantModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseVariantModelToJson(this);
}
