import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Ogni rotta dichiarata deve avere un ingresso.
///
/// Il sottosistema vocale e due schermate intere — `WorkoutOrganizePage` e
/// `UserSettingsPage` — sono vissute per mesi complete, tradotte e
/// irraggiungibili. Nessun lint le vedeva: compilavano, e una rotta dichiarata
/// nel router *sembra* una rotta viva.
///
/// Questo test chiude quel buco. Non verifica che la app funzioni: verifica che
/// esista almeno un punto del codice che nomina ogni rotta, oltre alla
/// dichiarazione stessa.
///
/// **Limiti, dichiarati perché il risultato non valga più di quanto vale.**
/// È un'analisi testuale: vede `context.go('/x')` e i percorsi costruiti da
/// una funzione solo se il segmento compare come stringa da qualche parte. Non
/// prova che l'ingresso sia raggiungibile dall'utente — un pulsante dietro un
/// flag spento lo soddisfa. Il falso positivo che evita è quello che conta:
/// una rotta che *nessuno* nomina.
void main() {
  final router = File('lib/app/router/app_router.dart').readAsStringSync();

  /// Rotte legittimamente senza ingresso nel codice, con il motivo.
  ///
  /// Una voce qui è una dichiarazione, non una scusa: se non sai perché una
  /// rotta ci sta, non ci sta.
  const declaredWithoutEntry = <String, String>{
    '/loading': 'initialLocation del router',
    '/login': 'destinazione del redirect quando manca la sessione',
    '/debug': 'si digita a mano, ed e\' spenta in release (18-observability)',
  };

  /// Le rotte dei tab: l'ingresso e' `goBranch` della navbar, non una stringa.
  final tabPaths = RegExp(r"path: '(/[a-z]+)'")
      .allMatches(File('lib/app/router/routes.dart').readAsStringSync())
      .map((m) => m.group(1)!)
      .toSet();

  String sourceOutsideRouter() {
    final buffer = StringBuffer();
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.endsWith('app_router.dart')) continue;
      buffer.writeln(entity.readAsStringSync());
    }
    return buffer.toString();
  }

  test('ogni rotta dichiarata ha almeno un ingresso nel codice', () {
    final source = sourceOutsideRouter();
    final paths = RegExp(
      r"path: '([^']+)'",
    ).allMatches(router).map((m) => m.group(1)!).toSet();

    expect(
      paths,
      isNotEmpty,
      reason: 'nessuna rotta trovata: regex da rivedere',
    );

    final orphans = <String>[];
    for (final path in paths) {
      if (declaredWithoutEntry.containsKey(path)) continue;
      if (tabPaths.contains(path)) continue;

      // Il segmento senza parametri: `workout/:id` si naviga come
      // `/workouts/workout/$id`, quindi si cerca `workout/`.
      final segment = path.split('/:').first.replaceFirst(RegExp(r'^/'), '');
      if (segment.isEmpty) continue;

      if (!source.contains(segment)) orphans.add(path);
    }

    expect(
      orphans,
      isEmpty,
      reason:
          'Rotte che nessuna riga di codice nomina: $orphans.\n'
          'O manca il punto di ingresso, o la schermata non serve piu\'. '
          'Se e\' voluto, aggiungila a `declaredWithoutEntry` con il motivo.',
    );
  });

  test('le eccezioni dichiarate esistono ancora fra le rotte', () {
    // `/debug` e' registrata come `path: DebugScreen.routePath`, quindi come
    // letterale vive nella schermata e non nel router: si cerca in tutto
    // `lib/`, non solo nel file delle rotte.
    final everything = router + sourceOutsideRouter();
    final stale = declaredWithoutEntry.keys
        .where((path) => !everything.contains("'$path'"))
        .toList();

    // Impedisce che la lista sopravviva alle rotte che giustificava.
    expect(stale, isEmpty, reason: 'eccezioni orfane: $stale');
  });
}
