import 'dart:io';

import 'package:coachly/features/workouts/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workouts/presentation/widgets/exercise_display_name.dart';
import 'package:coachly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Un id non è un nome.
///
/// Il difetto era visibile a occhio nudo: nella modifica strutturale di una
/// scheda comparivano stringhe tipo `a3f1c9e2-…` al posto del nome
/// dell'esercizio. La causa non era la traduzione mancante ma un
/// **disallineamento fra due sorgenti**: il widget scorre le voci della bozza
/// (`workoutEditDraftProvider`) e cerca i nomi in una mappa costruita dal
/// view data della scheda salvata. Una voce appena aggiunta esiste nella prima
/// e non nella seconda, quindi il `??` scattava — e il ripiego era l'id.
///
/// Il ripiego sbagliato è il vero difetto: un dato mancante è normale in una
/// app local-first, mostrare un id all'utente non lo è mai.
void main() {
  const prescription = ExercisePrescriptionViewData();

  WorkoutExerciseViewData exercise({
    required String name,
    bool isMissing = false,
  }) => WorkoutExerciseViewData(
    instanceId: 'entry-1',
    exerciseId: 'a3f1c9e2-7b44-4d21-9f0e-15c8ab77d301',
    name: name,
    isMissing: isMissing,
    prescription: prescription,
  );

  Future<String> resolve(
    WidgetTester tester,
    WorkoutExerciseViewData? data,
  ) async {
    late String result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('it'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            result = exerciseDisplayName(context, data);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return result;
  }

  testWidgets('la voce assente dalla mappa non mostra l\'id', (tester) async {
    // Il caso reale: la bozza ha una voce che il view data non ha ancora.
    final name = await resolve(tester, null);
    expect(name, isNotEmpty);
    expect(name, isNot(contains('a3f1c9e2')));
  });

  testWidgets('il sentinella interno non arriva a schermo', (tester) async {
    // `'Exercise'` è la convenzione dell'adattatore per «non lo conosco». Era
    // tradotta in un widget su tre, quindi in italiano si leggeva «Exercise».
    final name = await resolve(tester, exercise(name: 'Exercise'));
    expect(name, isNot('Exercise'));
    expect(name, isNotEmpty);
  });

  testWidgets('un nome vero passa intatto', (tester) async {
    final name = await resolve(tester, exercise(name: 'Squat con bilanciere'));
    expect(name, 'Squat con bilanciere');
  });

  testWidgets('un esercizio senza id ha il suo messaggio', (tester) async {
    final name = await resolve(tester, exercise(name: '', isMissing: true));
    expect(name, isNotEmpty);
    expect(name, isNot(contains('a3f1c9e2')));
  });

  test('nessun widget usa un id come testo di ripiego', () {
    // La regressione da impedire è precisamente quella che c'era: tre `??`
    // che finivano sull'id. Cercare il gesto, non il sintomo.
    final offenders = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path.replaceAll(r'\', '/');
      if (!path.contains('/presentation/')) continue;
      final source = entity.readAsStringSync();
      for (final match in RegExp(
        r'\?\?\s*[\w\.]*\b(exerciseId|\w+\.id)\b',
      ).allMatches(source)) {
        offenders.add(
          '${path.substring(path.indexOf('lib/'))}: '
          '${match.group(0)}',
        );
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Un id usato come testo di ripiego: $offenders.\n'
          'Usa `exerciseDisplayName`, o un testo tradotto che dica che il '
          'dato manca (07-errors-and-feedback.md).',
    );
  });
}
