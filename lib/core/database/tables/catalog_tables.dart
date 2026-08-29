import 'package:drift/drift.dart';

/// Catalogo esercizi: dati di riferimento, scritti da Coachly, sostituibili.
///
/// **Lo schema è modellato dalle clausole `WHERE`, non dalla normalizzazione
/// del backend** (`docs/development/04-data-layer.md`). Il backend ha una
/// ventina di tabelle per il catalogo e il JSON di dettaglio espone 44 campi:
/// la app ne filtra otto. Quegli otto sono colonne indicizzate; il resto vive
/// nel blob `payload`, che si legge solo aprendo il dettaglio di un esercizio.
///
/// Conseguenza voluta: se il backend aggiunge un campo al JSON, finisce nel
/// blob e la app continua a funzionare. Con lo schema rispecchiato sarebbe una
/// migrazione.
@DataClassName('CatalogExerciseRow')
class CatalogExercises extends Table {
  TextColumn get id => text()();

  TextColumn get code => text().withDefault(const Constant(''))();

  // ── Colonne su cui si filtra ────────────────────────────────────────────
  // Il bug che questo schema chiude: la cache Hive persisteva tre campi e il
  // filtro ne interrogava nove, quindi qualsiasi filtro diverso dal testo
  // restituiva zero risultati.
  TextColumn get difficultyLevel => text().nullable()();

  TextColumn get mechanicsType => text().nullable()();

  TextColumn get forceType => text().nullable()();

  BoolColumn get unilateral => boolean().withDefault(const Constant(false))();

  BoolColumn get bodyweight => boolean().withDefault(const Constant(false))();

  TextColumn get exerciseKind => text().nullable()();

  TextColumn get catalogStatus => text().nullable()();

  /// Il payload JSON completo del dettaglio, così come arriva dal backend.
  ///
  /// `null` finché il dettaglio non è stato scaricato: il catalogo si popola
  /// con i riepiloghi e i dettagli restano pigri, uno per volta.
  TextColumn get payload => text().nullable()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Testi localizzati, per qualsiasi entità.
///
/// Tabella normalizzata e non colonne per lingua: aggiungere una lingua deve
/// essere un delta di dati, non una migrazione di schema
/// (`docs/development/13-i18n.md`).
@DataClassName('LocalizedTextRow')
class LocalizedTexts extends Table {
  /// `catalog_exercise`, `custom_exercise`, `muscle`, `equipment`…
  TextColumn get entityType => text()();

  TextColumn get entityId => text()();

  /// `name`, `description`, `tips`…
  TextColumn get field => text()();

  TextColumn get locale => text()();

  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {entityType, entityId, field, locale};
}

/// Muscoli coinvolti. Tabella ponte perché il filtro è per appartenenza, e un
/// blob JSON non si indicizza.
@DataClassName('ExerciseMuscleRow')
class ExerciseMuscles extends Table {
  TextColumn get exerciseId => text()();

  TextColumn get muscleId => text()();

  TextColumn get muscleCode => text().withDefault(const Constant(''))();

  /// `primary`, `secondary`, `stabilizer`.
  TextColumn get involvement => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {exerciseId, muscleId};
}

/// Attrezzi richiesti. Tabella ponte per lo stesso motivo dei muscoli.
@DataClassName('ExerciseEquipmentRow')
class ExerciseEquipments extends Table {
  TextColumn get exerciseId => text()();

  TextColumn get equipmentId => text()();

  TextColumn get equipmentCode => text().withDefault(const Constant(''))();

  BoolColumn get required => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {exerciseId, equipmentId};
}

/// Categorie dell'esercizio. Tabella ponte per lo stesso motivo di muscoli e
/// attrezzi: il filtro è per appartenenza.
@DataClassName('ExerciseCategoryRow')
class ExerciseCategories extends Table {
  TextColumn get exerciseId => text()();

  TextColumn get categoryId => text()();

  TextColumn get categoryCode => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {exerciseId, categoryId};
}

/// Versione del catalogo installato, per i delta.
@DataClassName('CatalogMetaRow')
class CatalogMeta extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();

  IntColumn get version => integer().withDefault(const Constant(0))();

  DateTimeColumn get appliedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
