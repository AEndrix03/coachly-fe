import 'package:coachly/design_system/theme/exercise_theme.dart';
import '../support/exercise_detail_mock_fixture.dart';
import 'package:coachly/features/exercises/presentation/pages/exercise_info_page.dart';
import 'package:coachly/features/workouts/presentation/widgets/workout_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'a11y_fixtures.dart';
import 'a11y_harness.dart';

/// `docs/development/14-accessibility.md`: il testo deve superare il rapporto
/// di contrasto minimo.
///
/// Il tema è scuro e ad alta densità di testo secondario: è esattamente la
/// combinazione in cui il contrasto si perde senza che nessuno se ne accorga
/// guardando lo schermo di un telefono nuovo al chiuso.
void main() {
  testWidgets('la struttura della scheda supera il contrasto minimo', (
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

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  testWidgets('la pagina esercizio supera il contrasto minimo', (tester) async {
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

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
