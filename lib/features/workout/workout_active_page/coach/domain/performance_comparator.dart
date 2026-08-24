import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_context.dart';
import 'package:coachly/features/workout/workout_active_page/domain/set_input_configuration.dart';

enum PerformanceComparability {
  comparable,
  differentExercise,
  differentTrackingSchema,
  differentEquipment,
  differentSetType,
  insufficientData,
}

class PerformanceComparator {
  const PerformanceComparator();

  PerformanceComparability compare({
    required ComparableSetPerformance? previous,
    required String? currentExerciseId,
    required ExerciseTrackingType? currentTrackingType,
    required String? currentEquipmentId,
    required String? currentSetType,
  }) {
    if (previous == null ||
        currentExerciseId == null ||
        currentTrackingType == null ||
        currentSetType == null) {
      return PerformanceComparability.insufficientData;
    }
    if (previous.exerciseId != currentExerciseId) {
      return PerformanceComparability.differentExercise;
    }
    if (previous.trackingType != currentTrackingType) {
      return PerformanceComparability.differentTrackingSchema;
    }
    if (previous.equipmentId != null &&
        currentEquipmentId != null &&
        previous.equipmentId != currentEquipmentId) {
      return PerformanceComparability.differentEquipment;
    }
    if (previous.setType != currentSetType) {
      return PerformanceComparability.differentSetType;
    }
    return PerformanceComparability.comparable;
  }
}
