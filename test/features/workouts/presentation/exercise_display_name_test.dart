import 'dart:io';

import 'package:coachly/features/workouts/domain/workout_detail_view_data.dart';
import 'package:coachly/features/workouts/presentation/widgets/exercise_display_name.dart';
import 'package:coachly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Un id non è un nome.
///
/// Il difetto era visibile a occhio nudo — nelle schede comparivano stringhe
/// tipo `a3f1c9e2-…` al posto del nome — e aveva **tre livelli**, scoperti uno
/// per volta perché ogni correzione lasciava il sintomo in piedi:
///
/// 1. in `presentation/`, sette `?? …id` come testo di ripiego;
/// 2. in `application/`, la pagina di modifica e il builder che scrivevano
///    l'id nel campo `name` della bozza;
/// 3. nei **modelli**, dove `_sanitizeWorkoutExercise` metteva l'id dentro
///    `nameI18n` in deserializzazione.
///
/// Il terzo era il vero: da lì l'id *era* un nome a tutti gli effetti, e
/// nessun controllo a valle poteva distinguerlo da uno vero. Un ripiego
/// sbagliato in fondo alla catena rende inutili tutte le guardie sopra.
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
    String Function(BuildContext context) build,
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
            result = build(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return result;
  }

  testWidgets('la voce assente dalla mappa non mostra l\'id', (tester) async {
    // Il caso reale: la bozza ha una voce che il view data non ha ancora.
    final name = await resolve(tester, (c) => exerciseDisplayName(c, null));
    expect(name, isNotEmpty);
    expect(name, isNot(contains('a3f1c9e2')));
  });

  testWidgets('il sentinella interno non arriva a schermo', (tester) async {
    // `'Exercise'` è la convenzione dell'adattatore per «non lo conosco». Era
    // tradotta in un widget su tre, quindi in italiano si leggeva «Exercise».
    final name = await resolve(
      tester,
      (c) => exerciseDisplayName(c, exercise(name: 'Exercise')),
    );
    expect(name, isNot('Exercise'));
    expect(name, isNotEmpty);
  });

  testWidgets('un nome vero passa intatto', (tester) async {
    final name = await resolve(
      tester,
      (c) => exerciseDisplayName(c, exercise(name: 'Squat con bilanciere')),
    );
    expect(name, 'Squat con bilanciere');
  });

  testWidgets('un esercizio senza id ha il suo messaggio', (tester) async {
    final name = await resolve(
      tester,
      (c) => exerciseDisplayName(c, exercise(name: '', isMissing: true)),
    );
    expect(name, isNotEmpty);
    expect(name, isNot(contains('a3f1c9e2')));
  });

  testWidgets('il nome vuoto di una bozza diventa un testo tradotto', (
    tester,
  ) async {
    // I modelli ora lasciano il nome **vuoto** quando non lo conoscono, invece
    // di riempirlo con l'id: è la presentazione a dire che manca.
    final name = await resolve(tester, (c) => exerciseNameOrPlaceholder(c, ''));
    expect(name, isNotEmpty);

    final kept = await resolve(
      tester,
      (c) => exerciseNameOrPlaceholder(c, 'Panca piana'),
    );
    expect(kept, 'Panca piana');
  });

  test('nessuno usa un id come nome, in tutto lib/', () {
    // La prima versione guardava solo `presentation/`, e ha lasciato passare
    // proprio i due livelli che contavano. Ora guarda tutto, e cerca due
    // gesti: l'id come ripiego di un nome, e l'id assegnato a un campo che una
    // persona legge.
    final offenders = <String>[];
    final fallback = RegExp(r'\?\?\s*(?:[A-Za-z_]\w*\.)*(?:exerciseId|id)\b');
    final readable = RegExp(r'\b(name|title|label|displayName|nameI18n)\b');
    final assignment = RegExp(
      r'(?:name|title|displayName)\s*:\s*[^,;]*?'
      r'(?:[A-Za-z_]\w*\.)*(?:exerciseId|\bid)\b\s*[,;]',
    );

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path.replaceAll(r'\', '/');
      if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) continue;
      final relative = path.substring(path.indexOf('lib/'));

      for (final line in entity.readAsLinesSync()) {
        if (line.trimLeft().startsWith('//')) continue;
        // `id: id ?? this.id` in un copyWith non c'entra: è un id che resta un
        // id. Il divieto riguarda i campi che una persona legge.
        if (RegExp(r'^\s*(id|exerciseId|instanceId)\s*:').hasMatch(line)) {
          continue;
        }
        final isFallback = fallback.hasMatch(line) && readable.hasMatch(line);
        if (isFallback || assignment.hasMatch(line)) {
          offenders.add('$relative: ${line.trim()}');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Un id usato come nome visibile: $offenders. '
          'Lascia il campo vuoto e usa `exerciseDisplayName` o '
          '`exerciseNameOrPlaceholder` in presentation '
          '(07-errors-and-feedback.md).',
    );
  });
}
