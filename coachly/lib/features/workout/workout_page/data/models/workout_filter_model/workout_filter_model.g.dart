// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutFilterModel _$WorkoutFilterModelFromJson(Map<String, dynamic> json) =>
    WorkoutFilterModel(
      sortBy:
          $enumDecodeNullable(_$WorkoutSortByEnumMap, json['sortBy']) ??
          WorkoutSortBy.date,
      ascending: json['ascending'] as bool? ?? false,
      searchQuery: json['searchQuery'] as String?,
      coachIds: (json['coachIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WorkoutFilterModelToJson(WorkoutFilterModel instance) =>
    <String, dynamic>{
      'sortBy': _$WorkoutSortByEnumMap[instance.sortBy]!,
      'ascending': instance.ascending,
      'searchQuery': instance.searchQuery,
      'coachIds': instance.coachIds,
    };

const _$WorkoutSortByEnumMap = {
  WorkoutSortBy.name: 'name',
  WorkoutSortBy.date: 'date',
  WorkoutSortBy.duration: 'duration',
  WorkoutSortBy.difficulty: 'difficulty',
};
