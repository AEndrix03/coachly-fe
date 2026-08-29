import 'package:drift/drift.dart';

/// Dati scritti dall'utente: **insostituibili**.
///
/// Nascono sul dispositivo, spesso offline, e il backend li riceve senza
/// correggerli (`docs/development/05-sync-and-offline.md`). Se si perdono qui,
/// si perdono e basta.

/// Esercizi creati dall'utente.
///
/// Tabella separata dal catalogo, non un flag `isPersonal`: il catalogo viene
/// sostituito in blocco dai delta, questi no.
@DataClassName('CustomExerciseRow')
class CustomExercises extends Table {
  TextColumn get id => text()();

  TextColumn get difficultyLevel => text().nullable()();

  TextColumn get mechanicsType => text().nullable()();

  TextColumn get forceType => text().nullable()();

  BoolColumn get unilateral => boolean().withDefault(const Constant(false))();

  BoolColumn get bodyweight => boolean().withDefault(const Constant(false))();

  TextColumn get payload => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete: la riga resta finché la cancellazione non è salita.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Schede di allenamento.
///
/// `origin` distingue ciò che scrive l'utente da ciò che in futuro scriverà un
/// coach. Oggi è sempre `user`, ma il confine esiste già: quando arriveranno le
/// schede assegnate, l'autorità su quelle righe passerà al server **senza
/// toccare lo schema di queste** (`docs/development/04-data-layer.md`).
@DataClassName('WorkoutRow')
class Workouts extends Table {
  TextColumn get id => text()();

  /// Il vincolo è dichiarato solo come `customConstraint`: dichiararlo anche
  /// con `withDefault` farebbe vincere il custom e ignorare l'altro in
  /// silenzio.
  TextColumn get origin => text().customConstraint(
    "CHECK (origin IN ('user','assigned')) NOT NULL DEFAULT 'user'",
  )();

  TextColumn get sourceProgramId => text().nullable()();

  TextColumn get goal => text().nullable()();

  IntColumn get durationMinutes => integer().withDefault(const Constant(0))();

  IntColumn get sessionsCount => integer().withDefault(const Constant(0))();

  RealColumn get progress => real().withDefault(const Constant(0))();

  BoolColumn get active => boolean().withDefault(const Constant(true))();

  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  /// La scheda ha modifiche locali non ancora salite.
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  /// Il payload completo della scheda, come arriva da `/workouts/user`.
  TextColumn get payload => text().nullable()();

  DateTimeColumn get lastUsed => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Snapshot del comando di scrittura strutturato di una scheda.
///
/// Serve a ricostruire il comando da inviare senza rifare il mapping da capo.
@DataClassName('WorkoutSnapshotRow')
class WorkoutSnapshots extends Table {
  TextColumn get workoutId => text()();

  TextColumn get commandJson => text()();

  DateTimeColumn get sourceUpdatedAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {workoutId};
}

/// Bozza di un allenamento in corso, per sopravvivere a una chiusura della app.
@DataClassName('ActiveWorkoutDraftRow')
class ActiveWorkoutDrafts extends Table {
  TextColumn get workoutId => text()();

  TextColumn get payload => text()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {workoutId};
}

/// Sessioni di allenamento.
@DataClassName('SessionRow')
class Sessions extends Table {
  TextColumn get id => text()();

  TextColumn get workoutId => text()();

  TextColumn get status => text().withDefault(const Constant('open'))();

  TextColumn get payload => text().nullable()();

  DateTimeColumn get startedAt => dateTime().nullable()();

  DateTimeColumn get completedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Coda di caricamento verso il backend.
///
/// **Append-only e client-authored**: non esistono stati `conflict` o
/// `rejected`, perché il client è l'autore e il server non corregge
/// (`docs/development/05-sync-and-offline.md`). Un `failedPermanent` non
/// cancella mai il dato locale: il fallimento riguarda la telemetria, non
/// l'utente.
@DataClassName('OutboxRow')
class Outbox extends Table {
  TextColumn get id => text()();

  /// `session`, `workout`, `custom_exercise`…
  TextColumn get entityType => text()();

  TextColumn get entityId => text()();

  /// `create`, `update`, `delete`.
  TextColumn get operation => text()();

  /// Il payload che viaggia sul filo: qui **sì** che il modello coincide con
  /// il contratto dell'API, perché è quello che si invia.
  TextColumn get payload => text()();

  /// Payload accessorio (es. il comando workout mergiato di una sessione).
  TextColumn get secondaryPayload => text().nullable()();

  TextColumn get status => text().withDefault(const Constant('pending'))();

  IntColumn get attempts => integer().withDefault(const Constant(0))();

  DateTimeColumn get nextAttemptAt => dateTime().nullable()();

  TextColumn get lastError => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
