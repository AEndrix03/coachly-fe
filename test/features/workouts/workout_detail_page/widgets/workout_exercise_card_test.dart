import 'package:coachly/features/workouts/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workouts/presentation/widgets/workout_exercise_card.dart';
import 'package:coachly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// `AppLocalizations.delegate` deve essere qui: i widget in questa pagina
/// stanno migrando a `context.l10n`, che a differenza di `context.tr` non ha
/// un fallback quando manca il delegate nello scope di `Localizations`.
const _delegates = <LocalizationsDelegate<Object?>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

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
        localizationsDelegates: _delegates,
        supportedLocales: AppLocalizations.supportedLocales,
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
    expect(find.text('Working sets'), findsNothing);

    // La scheda si apre dalla riga, non dal nome: toccare il nome apre il
    // dettaglio dell'esercizio, ed e' una destinazione diversa.
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Working sets'), findsOneWidget);
    expect(find.text('Control the eccentric.'), findsOneWidget);
    expect(
      tester.widget<SizeTransition>(find.byType(SizeTransition)).axis,
      Axis.vertical,
    );

    await tester.tap(find.text('Exercise details'));
    expect(detailOpened, isTrue);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Working sets'), findsNothing);
  });

  testWidgets('remains readable at 150 percent text scale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: _delegates,
        supportedLocales: AppLocalizations.supportedLocales,
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

  testWidgets('shows a skeleton instead of an unresolved exercise ID', (
    tester,
  ) async {
    const unresolved = WorkoutExerciseViewData(
      instanceId: 'entry-loading',
      exerciseId: '11111111-1111-4111-8111-111111111111',
      name: 'Exercise',
      isNameLoading: true,
      prescription: ExercisePrescriptionViewData(),
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: _delegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: WorkoutExerciseCard(
            exercise: unresolved,
            indexLabel: '01',
            onOpenDetail: () {},
          ),
        ),
      ),
    );

    expect(find.text(unresolved.exerciseId), findsNothing);
    expect(find.text('01'), findsOneWidget);
  });
}
