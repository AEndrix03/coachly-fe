import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';

enum ExerciseTrackingType {
  weightReps,
  bodyweightReps,
  bodyweightAdditionalWeight,
  assistedBodyweight,
  time,
  distance,
  weightTime,
  perSide,
}

enum SetInputField { weight, reps, time, distance, rir, left, right }

class SetInputConfiguration {
  final ExerciseTrackingType trackingType;
  final List<SetInputField> fields;
  final String? weightUnit;
  final String? distanceUnit;
  final double weightStep;
  final int repsStep;
  final bool isUnilateral;
  final bool effortAvailable;

  const SetInputConfiguration({
    required this.trackingType,
    required this.fields,
    this.weightUnit,
    this.distanceUnit,
    this.weightStep = 2.5,
    this.repsStep = 1,
    this.isUnilateral = false,
    this.effortAvailable = true,
  });

  factory SetInputConfiguration.forExercise(ExerciseDetailModel exercise) {
    if (exercise.isUnilateral == true) {
      return const SetInputConfiguration(
        trackingType: ExerciseTrackingType.perSide,
        fields: [
          SetInputField.weight,
          SetInputField.left,
          SetInputField.right,
          SetInputField.rir,
        ],
        weightUnit: 'kg',
        isUnilateral: true,
      );
    }
    if (exercise.isBodyweight == true) {
      return const SetInputConfiguration(
        trackingType: ExerciseTrackingType.bodyweightReps,
        fields: [SetInputField.reps, SetInputField.rir],
      );
    }
    return const SetInputConfiguration(
      trackingType: ExerciseTrackingType.weightReps,
      fields: [SetInputField.weight, SetInputField.reps, SetInputField.rir],
      weightUnit: 'kg',
    );
  }

  bool shows(SetInputField field) => fields.contains(field);
}
