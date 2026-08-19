import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workout/workout_detail_page/presentation/mock/workout_detail_mock_factory.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Input for the presentation projection.  Resolution of a missing exercise
/// name remains asynchronous and external to this provider; all layout-facing
/// data is then produced in one immutable snapshot.
class WorkoutDetailViewRequest {
  final WorkoutModel workout;
  final Locale locale;
  final Map<String, String> resolvedExerciseNames;
  final Set<String> resolvingExerciseIds;

  const WorkoutDetailViewRequest({
    required this.workout,
    required this.locale,
    this.resolvedExerciseNames = const {},
    this.resolvingExerciseIds = const {},
  });

  @override
  bool operator ==(Object other) =>
      other is WorkoutDetailViewRequest &&
      other.workout == workout &&
      other.locale == locale &&
      _mapEquals(other.resolvedExerciseNames, resolvedExerciseNames) &&
      _setEquals(other.resolvingExerciseIds, resolvingExerciseIds);

  @override
  int get hashCode => Object.hash(
    workout,
    locale,
    Object.hashAllUnordered(
      resolvedExerciseNames.entries.map(
        (entry) => Object.hash(entry.key, entry.value),
      ),
    ),
    Object.hashAllUnordered(resolvingExerciseIds),
  );
}

final workoutDetailViewDataProvider = Provider.autoDispose
    .family<WorkoutDetailViewData, WorkoutDetailViewRequest>((ref, request) {
      final viewData = WorkoutDetailAdapter.fromWorkout(
        request.workout,
        request.locale,
        request.resolvedExerciseNames,
        request.resolvingExerciseIds,
      );
      const useFixture = bool.fromEnvironment('WORKOUT_DETAIL_MOCK_STRUCTURE');
      return useFixture
          ? WorkoutDetailMockFactory.withPresentationStructure(
              viewData,
              request.locale,
            )
          : viewData;
    });

bool _mapEquals(Map<String, String> first, Map<String, String> second) {
  return identical(first, second) ||
      first.length == second.length &&
          first.entries.every((entry) => second[entry.key] == entry.value);
}

bool _setEquals(Set<String> first, Set<String> second) =>
    identical(first, second) ||
    first.length == second.length && first.containsAll(second);
