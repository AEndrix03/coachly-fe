import 'package:freezed_annotation/freezed_annotation.dart';

part 'muscle_model.freezed.dart';
part 'muscle_model.g.dart';

@freezed
@JsonSerializable()
class MuscleModel with _$MuscleModel {
  final String name;
  final int activation;
  final int color;

  const MuscleModel({
    required this.name,
    required this.activation,
    required this.color,
  });

  factory MuscleModel.fromJson(Map<String, dynamic> json) =>
      _$MuscleModelFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleModelToJson(this);
}
