import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const exercise = WorkoutExerciseViewData(
    instanceId: 'entry-1',
    exerciseId: 'exercise-1',
    name: 'Incline Dumbbell Press',
    metadata: 'Upper chest · Dumbbell',
    prescription: ExercisePrescriptionViewData(
      note: 'Control the eccentric.',
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

  testWidgets('expands, collapses and opens exercise detail callback', (
    tester,
  ) async {
    var detailOpened = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorkoutExerciseCard(
            exercise: exercise,
            indexLabel: '01',
            onOpenDetail: () => detailOpened = true,
          ),
        ),
      ),
    );

    expect(find.text('3 × 6–10'), findsOneWidget);
    expect(find.text('RIR 1–2 · Rest 3:00'), findsOneWidget);
    expect(find.text('Exercise details'), findsNothing);

    await tester.tap(find.text('Incline Dumbbell Press'));
    await tester.pumpAndSettle();
    expect(find.text('Exercise details'), findsOneWidget);
    expect(find.text('Control the eccentric.'), findsOneWidget);
    expect(
      tester.widget<SizeTransition>(find.byType(SizeTransition)).axis,
      Axis.vertical,
    );

    await tester.tap(find.text('Exercise details'));
    expect(detailOpened, isTrue);

    await tester.tap(find.text('Incline Dumbbell Press'));
    await tester.pumpAndSettle();
    expect(find.text('Exercise details'), findsNothing);
  });

  testWidgets('remains readable at 150 percent text scale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: Scaffold(
            body: SizedBox(
              width: 360,
              child: WorkoutExerciseCard(
                exercise: exercise,
                indexLabel: '01',
                onOpenDetail: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Incline Dumbbell Press'), findsOneWidget);
  });
}
