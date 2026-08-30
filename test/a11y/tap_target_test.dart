import 'package:coachly/design_system/theme/exercise_theme.dart';
import '../support/exercise_detail_mock_fixture.dart';
import 'package:coachly/features/exercises/presentation/pages/exercise_info_page.dart';
import 'package:coachly/features/workouts/presentation/widgets/workout_detail_content.dart';
import 'package:coachly/features/workouts/presentation/widgets/workout_exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'a11y_fixtures.dart';
import 'a11y_harness.dart';

/// `docs/development/14-accessibility.md`: ogni target interattivo è almeno
/// 48×48 dp. Non è una preferenza estetica — è la dimensione sotto la quale
/// un pollice sudato in palestra sbaglia bersaglio.
void main() {
  testWidgets('la struttura della scheda rispetta i target Android', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpScreen(
      tester,
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: WorkoutStructure(
          workout: a11yWorkout(),
          onOpenExercise: (_) {},
          onAddExercise: () {},
        ),
      ),
    );

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    handle.dispose();
  });

  testWidgets('la scheda esercizio rispetta i target anche espansa', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpScreen(
      tester,
      SingleChildScrollView(
        child: WorkoutExerciseCard(
          exercise: a11yExercise,
          indexLabel: '01',
          onOpenDetail: () {},
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    handle.dispose();
  });

  testWidgets('la pagina esercizio rispetta i target Android', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpScreen(
      tester,
      Theme(
        data: exerciseDetailTheme(ThemeData.dark()),
        child: ExerciseOverviewContent(
          data: latPulldownExerciseFixture,
          onAdd: () {},
        ),
      ),
    );

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    handle.dispose();
  });
}
