@Tags(['db'])
library;

import 'dart:io';

import 'package:coachly/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated_migrations/schema.dart';

/// La disciplina delle migrazioni di `docs/development/04-data-layer.md`,
/// resa verificabile.
///
/// Il documento la vuole attiva **dal primo giorno**, non da quando servirà:
/// ADR-005 dice che oggi non c'è nessun utente in produzione, quindi oggi un
/// errore di migrazione non costa nulla. È esattamente il momento giusto per
/// scoprire che il meccanismo non funziona.
void main() {
  late int currentVersion;

  setUpAll(() async {
    final db = AppDatabase(NativeDatabase.memory());
    currentVersion = db.schemaVersion;
    await db.close();
  });

  test('ogni schemaVersion ha il suo snapshot esportato', () {
    final snapshot = File('drift_schemas/drift_schema_v$currentVersion.json');
    expect(
      snapshot.existsSync(),
      isTrue,
      reason:
          'Manca ${snapshot.path}. Dopo ogni cambio di schema:\n'
          '  dart run drift_dev schema dump lib/core/database/app_database.dart drift_schemas/\n'
          '  dart run drift_dev schema generate drift_schemas/ test/core/database/generated_migrations/',
    );
  });

  test('lo schema dichiarato coincide con lo snapshot esportato', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    // Confronta il risultato di `onCreate` con lo snapshot: intercetta la
    // colonna aggiunta senza esportare, che è il modo normale in cui questa
    // disciplina si perde.
    await verifier.migrateAndValidate(db, currentVersion);
  });

  test('ogni versione precedente migra fino a quella corrente', () async {
    final verifier = SchemaVerifier(GeneratedHelper());

    for (final from in GeneratedHelper.versions.where(
      (v) => v < currentVersion,
    )) {
      final connection = await verifier.startAt(from);
      final db = AppDatabase(connection);
      await verifier.migrateAndValidate(db, currentVersion);
      await db.close();
    }
  });
}
