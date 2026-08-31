import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// La regola sulle 800 righe di `docs/development/02-project-structure.md`,
/// resa verificabile.
///
/// Il documento la enuncia dal primo giorno e cita tre file come esempi di
/// dove «questa architettura non esiste ancora». Nessuno la controllava,
/// quindi non ha mai fermato niente: i tre esempi sono diventati tredici, e
/// due di quei tre sono cresciuti nel frattempo.
///
/// Il debito non si azzera con un test — quello va fatto a mano, un file per
/// volta, ed è lavoro di design, non di taglio. Ma un debito **elencato** ha
/// una proprietà che un debito diffuso non ha: non può crescere di nascosto.
/// Un file nuovo oltre soglia fallisce; un file in elenco che peggiora non
/// fallisce, ma la sua riga dice di quanto.
///
/// Non è estetica. Un file lungo è il segnale più affidabile che un widget ha
/// assorbito logica che appartiene a un controller.
void main() {
  const limit = 800;

  /// I file oltre soglia oggi, con il numero di righe al momento in cui la
  /// regola è diventata verificabile.
  ///
  /// Una voce qui è una dichiarazione, non un permesso: dice «lo sappiamo, e
  /// sappiamo perché». Togliere una riga da questo elenco è il modo in cui il
  /// debito si chiude.
  const declared = <String, int>{
    // La schermata dell'allenamento: 46 classi in un file. È quella che
    // cambia più spesso, quindi è quella dove la divisione serve di più.
    'lib/features/active_workout/presentation/widgets/adaptive_workout_workspace.dart':
        3909,
    'lib/features/workouts/presentation/widgets/workout_builder_widgets.dart':
        2449,
    // Ponte verso gli ARB: è una mappa, non logica. Sparisce con l'ultimo
    // chiamante di `AppStrings` (ADR-002).
    'lib/shared/i18n/app_strings.dart': 2063,
    'lib/shared/i18n/arb_bridge.dart': 936,
    'lib/features/exercises/presentation/pages/exercise_info_page.dart': 1523,
    'lib/features/workouts/presentation/pages/create_workout_flow.dart': 1471,
    'lib/features/workouts/presentation/widgets/exercise_picker_sheet.dart':
        1436,
    'lib/features/exercises/presentation/pages/coachly_concept_guide_page.dart':
        1237,
    'lib/features/active_workout/application/active_workout_provider.dart':
        1215,
    'lib/features/workouts/presentation/widgets/today_home_widgets.dart': 1116,
    'lib/features/workouts/presentation/widgets/workout_structural_edit.dart':
        920,
    'lib/features/workouts/presentation/pages/add_exercise_page.dart': 865,
    'lib/features/workouts/domain/workout_detail_view_data.dart': 820,
  };

  Map<String, int> measure() {
    final sizes = <String, int>{};
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path.replaceAll(r'\', '/');
      // Codice generato: non si divide a mano.
      if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) continue;
      if (path.contains('lib/l10n/')) continue;
      sizes[path.substring(path.indexOf('lib/'))] = entity
          .readAsLinesSync()
          .length;
    }
    return sizes;
  }

  test('nessun file nuovo oltre le 800 righe', () {
    final offenders = <String>[];
    measure().forEach((path, lines) {
      if (lines <= limit || declared.containsKey(path)) return;
      offenders.add('$path ($lines righe)');
    });

    expect(
      offenders,
      isEmpty,
      reason:
          'File oltre le $limit righe non dichiarati: $offenders.\n'
          'Quasi sempre significa che un widget ha assorbito logica che '
          'appartiene a un controller (02-project-structure.md). Se la '
          'lunghezza è davvero giustificata, aggiungilo a `declared` con il '
          'motivo.',
    );
  });

  test('le voci dichiarate esistono ancora', () {
    final sizes = measure();
    final stale = <String>[];
    declared.forEach((path, _) {
      final lines = sizes[path];
      if (lines == null) {
        stale.add('$path — non esiste più');
      } else if (lines <= limit) {
        stale.add('$path — ora è $lines righe, sotto soglia');
      }
    });

    // Impedisce che l'elenco sopravviva al debito che descriveva: un file
    // diviso deve uscire da qui, altrimenti la prossima crescita è di nuovo
    // invisibile.
    expect(stale, isEmpty, reason: 'voci da rimuovere da `declared`: $stale');
  });
}
