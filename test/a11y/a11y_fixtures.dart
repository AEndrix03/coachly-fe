import 'package:coachly/features/workouts/domain/workout_detail_view_data.dart';

/// Una scheda realistica: due sezioni, un superset, note e prescrizioni.
///
/// I test di accessibilità devono girare su qualcosa che assomigli a un
/// allenamento vero, non su un caso minimo: gli overflow e i target piccoli
/// nascono quando il contenuto è lungo.
const a11yExercise = WorkoutExerciseViewData(
  instanceId: 'press',
  exerciseId: 'press-id',
  name: 'Incline Dumbbell Press',
  metadata: 'Upper chest · Dumbbell',
  prescription: ExercisePrescriptionViewData(
    note: 'Control the eccentric and stop at chest level.',
    blocks: [
      PrescriptionBlockViewData(
        type: PrescriptionBlockType.standard,
        sets: 3,
        repsMin: 6,
        repsMax: 10,
        intensity: IntensityTarget(
          type: IntensityTargetType.rir,
          min: 1,
          max: 2,
        ),
        restSeconds: 180,
      ),
    ],
  ),
);

WorkoutDetailViewData a11yWorkout() => WorkoutDetailViewData(
  id: 'a11y',
  title: 'Schiena & Petto',
  estimatedDuration: const Duration(minutes: 64),
  sections: [
    WorkoutSectionViewData(
      id: 'main',
      title: 'Main Work',
      kind: WorkoutSectionKind.main,
      position: 0,
      blocks: [
        WorkoutExerciseBlockViewData(a11yExercise),
        WorkoutExerciseBlockViewData(
          const WorkoutExerciseViewData(
            instanceId: 'row',
            exerciseId: 'row-id',
            name: 'Chest Supported Row',
            metadata: 'Mid back · Machine',
            prescription: ExercisePrescriptionViewData(
              blocks: [
                PrescriptionBlockViewData(
                  type: PrescriptionBlockType.standard,
                  sets: 4,
                  repsMin: 8,
                  repsMax: 12,
                  restSeconds: 120,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ],
);
