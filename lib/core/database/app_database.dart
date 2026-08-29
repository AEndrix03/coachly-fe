import 'package:coachly/core/database/tables/catalog_tables.dart';
import 'package:coachly/core/database/tables/user_tables.dart';
import 'package:coachly/core/database/tables/voice_tables.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

/// Il database locale di Coachly.
///
/// Vedi `docs/development/04-data-layer.md`. Tre classi di dati con regole
/// diverse convivono qui:
///
/// - **catalogo** (`CatalogExercises`, `ExerciseMuscles`, …): scritto da
///   Coachly, sostituibile in blocco, perderlo non è un danno;
/// - **dati utente** (`Workouts`, `Sessions`, `Outbox`, `CustomExercises`,
///   `VoiceAliases`): nascono sul dispositivo, spesso offline, e sono
///   **insostituibili**;
/// - **dati assegnati** (`Workouts` con `origin = 'assigned'`): oggi vuoti, il
///   confine esiste già per quando arriveranno le schede dei coach.
@DriftDatabase(
  tables: [
    // Catalogo
    CatalogExercises,
    LocalizedTexts,
    ExerciseMuscles,
    ExerciseEquipments,
    ExerciseCategories,
    CatalogMeta,
    // Dati utente
    CustomExercises,
    Workouts,
    WorkoutSnapshots,
    ActiveWorkoutDrafts,
    Sessions,
    Outbox,
    // Voce
    VoiceAliases,
    VoiceResolutionLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'coachly'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await into(
        catalogMeta,
      ).insert(CatalogMetaCompanion.insert(id: const Value(0)));
    },
    onUpgrade: (m, from, to) async {
      // Nessun utente in produzione (ADR-005): le migrazioni si scrivono
      // comunque, perche' la disciplina va attivata dal primo giorno e non
      // quando servira'.
      if (from < 2) {
        await m.createTable(exerciseCategories);
      }
    },
    beforeOpen: (details) async {
      // I vincoli `CHECK` e le foreign key non sono attivi per default in
      // SQLite: senza questo, il vincolo su `Workouts.origin` sarebbe
      // decorativo.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Cancella tutti i dati locali mantenendo lo schema.
  ///
  /// Usato dal logout e dalla modalità `cold`
  /// (`docs/development/17-config-and-flags.md`).
  Future<void> wipe() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
      await into(
        catalogMeta,
      ).insert(CatalogMetaCompanion.insert(id: const Value(0)));
    });
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
