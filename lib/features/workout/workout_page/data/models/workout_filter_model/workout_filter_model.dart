import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_filter_model.freezed.dart';
part 'workout_filter_model.g.dart';

enum WorkoutSortBy { name, date, duration, difficulty }

@freezed
@JsonSerializable()
class WorkoutFilterModel with _$WorkoutFilterModel {
  @override
  final WorkoutSortBy sortBy;
  @override
  final bool ascending;
  @override
  final String? searchQuery;
  @override
  final List<String>? coachIds;

  const WorkoutFilterModel({
    this.sortBy = WorkoutSortBy.date,
    this.ascending = false,
    this.searchQuery,
    this.coachIds,
  });

  factory WorkoutFilterModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutFilterModelToJson(this);
}
