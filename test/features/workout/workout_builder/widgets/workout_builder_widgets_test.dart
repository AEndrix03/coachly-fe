import 'package:coachly/features/workout/workout_builder/domain/workout_draft.dart';
import 'package:coachly/features/workout/workout_builder/widgets/workout_builder_widgets.dart';
import 'package:coachly/l10n/app_localizations.dart';
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
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: WorkoutDraftStructure(
            draft: const WorkoutDraft(localDraftId: 'draft', title: 'Test'),
            onEditExercise: (_) {},
            onEditBlock: (_) {},
            onUpdateExercise: (_) {},
            onUpdateBlock: (_) {},
            onOpenExercise: (_) {},
            onReorder: (_, _, _) {},
            onReorderSections: (_, _) {},
            onRemove: (_) {},
            onRemoveExercise: (_) {},
            onDuplicate: (_) {},
            onMove: (_) {},
            onAddExercise: (_) {},
            onAddSection: () {},
            onCreateBlock: () {},
          ),
        ),
      ),
    );
    expect(find.text('Costruisci la sessione'), findsOneWidget);
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
          AppLocalizations.delegate,
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

  testWidgets('section sheet owns its controller and fits a compact viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('it'),
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showWorkoutSectionNameSheet(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Il foglio parte dai preset: il campo libero compare solo dopo
    // "Personalizza". Prima di quel tocco un TextField non esiste, ed e' il
    // comportamento voluto — la sezione ha un nome standard nel 90% dei casi.
    expect(find.byType(TextField), findsNothing);
    await tester.tap(find.text('Personalizza'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Principali');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aggiungi sezione'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aggiungi sezione'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Nuova sezione'), findsNothing);
  });
}
