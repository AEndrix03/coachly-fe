import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/workout_builder/widgets/workout_builder_widgets.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('structure exposes localized empty action', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('it'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: WorkoutDraftStructure(
            draft: const WorkoutDraft(localDraftId: 'draft', title: 'Test'),
            onEditExercise: (_) {},
            onReorder: (_, _, _) {},
            onRemove: (_) {},
            onAddExercise: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Aggiungi il primo esercizio'), findsOneWidget);
  });

  testWidgets('summary renders derived pluralized values', (tester) async {
    const exercise = WorkoutExerciseDraft(
      localId: 'a',
      exerciseId: 'a',
      name: 'Lat Pulldown',
    );
    const draft = WorkoutDraft(
      localDraftId: 'draft',
      title: 'Schiena',
      trainingGoal: 'Ipertrofia',
      sections: [
        WorkoutSectionDraft(
          id: 'implicit',
          position: 0,
          items: [WorkoutExerciseItemDraft(exercise)],
        ),
      ],
    );
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('it'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: WorkoutBuilderSummary(draft: draft)),
      ),
    );
    expect(find.text('Schiena'), findsOneWidget);
    expect(find.textContaining('1 esercizio'), findsOneWidget);
  });
}
