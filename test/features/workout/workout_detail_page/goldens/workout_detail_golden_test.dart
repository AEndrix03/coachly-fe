@Tags(['golden'])
library;

import 'package:coachly/features/workout/workout_detail_page/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workout/workout_detail_page/widgets/workout_detail_content.dart';
import 'package:coachly/l10n/app_localizations.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Workout Detail simple golden', (tester) async {
    await _pump(tester, _simpleWorkout());
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('workout_detail_simple.png'),
    );
  });

  testWidgets('Workout Detail expanded exercise golden', (tester) async {
    await _pump(tester, _simpleWorkout());
    // Toccare il nome apre il dettaglio dell'esercizio: la scheda si espande
    // dal chevron. Con il tap sul nome questo golden registrava lo stato
    // collassato, byte per byte identico a quello "simple".
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded).first);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('workout_detail_expanded.png'),
    );
  });

  testWidgets('Workout Detail superset golden', (tester) async {
    await _pump(tester, _groupWorkout());
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('workout_detail_superset.png'),
    );
  });

  testWidgets('Workout Detail empty golden', (tester) async {
    await _pump(
      tester,
      const WorkoutDetailViewData(
        id: 'empty',
        title: 'Empty workout',
        sections: [],
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('workout_detail_empty.png'),
    );
  });
}

Future<void> _pump(WidgetTester tester, WorkoutDetailViewData workout) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: CoachlyAthleteTheme.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: CoachlyAthleteTheme.primary,
          brightness: Brightness.dark,
          surface: CoachlyAthleteTheme.surface,
        ),
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: WorkoutStructure(
            workout: workout,
            onOpenExercise: (_) {},
            onAddExercise: () {},
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

WorkoutDetailViewData _simpleWorkout() => WorkoutDetailViewData(
  id: 'simple',
  title: 'Schiena & Petto',
  estimatedDuration: const Duration(minutes: 64),
  sections: [
    WorkoutSectionViewData(
      id: 'main',
      title: 'Main Work',
      kind: WorkoutSectionKind.main,
      position: 0,
      blocks: [
        WorkoutExerciseBlockViewData(
          const WorkoutExerciseViewData(
            instanceId: 'press',
            exerciseId: 'press-id',
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
          ),
        ),
        WorkoutExerciseBlockViewData(
          const WorkoutExerciseViewData(
            instanceId: 'row',
            exerciseId: 'row-id',
            name: 'Chest Supported Row',
            metadata: 'Back · Machine',
            prescription: ExercisePrescriptionViewData(
              blocks: [
                PrescriptionBlockViewData(
                  type: PrescriptionBlockType.standard,
                  sets: 3,
                  repsMin: 8,
                  repsMax: 12,
                  intensity: IntensityTarget(
                    type: IntensityTargetType.rir,
                    min: 2,
                  ),
                  restSeconds: 150,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ],
);

WorkoutDetailViewData _groupWorkout() => WorkoutDetailViewData(
  id: 'group',
  title: 'Schiena & Petto',
  sections: [
    WorkoutSectionViewData(
      id: 'accessories',
      title: 'Accessories',
      kind: WorkoutSectionKind.accessory,
      position: 0,
      blocks: [
        WorkoutGroupBlockViewData(
          id: 'superset-a',
          type: WorkoutGroupType.superset,
          rounds: 3,
          restAfterRoundSeconds: 120,
          exercises: const [
            WorkoutExerciseViewData(
              instanceId: 'fly',
              exerciseId: 'fly-id',
              name: 'Cable Fly',
              prescription: ExercisePrescriptionViewData(
                blocks: [
                  PrescriptionBlockViewData(
                    type: PrescriptionBlockType.standard,
                    sets: 3,
                    repsMin: 10,
                    repsMax: 15,
                    restSeconds: 0,
                  ),
                ],
              ),
            ),
            WorkoutExerciseViewData(
              instanceId: 'pulldown',
              exerciseId: 'pulldown-id',
              name: 'Lat Pulldown',
              prescription: ExercisePrescriptionViewData(
                blocks: [
                  PrescriptionBlockViewData(
                    type: PrescriptionBlockType.standard,
                    sets: 3,
                    repsMin: 8,
                    repsMax: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
