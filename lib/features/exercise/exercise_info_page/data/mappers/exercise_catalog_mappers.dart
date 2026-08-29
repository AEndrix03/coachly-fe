/// Conversioni fra il JSON del backend, le righe Drift e i modelli di dominio.
///
/// Vive in `data/`: i DTO non escono da qui
/// (`docs/development/01-principles.md`, § 4).
///
/// Il criterio dello schema è in `catalog_tables.dart`: gli otto campi su cui
/// si filtra sono colonne, i restanti trentasei del JSON di dettaglio restano
/// nel blob `payload`. Questi mapper sono l'unico posto che conosce quel
/// confine.
library;

import 'dart:convert';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:drift/drift.dart';

/// Valore di `LocalizedTexts.entityType` per il catalogo Coachly.
const String catalogExerciseEntityType = 'catalog_exercise';

/// Campi localizzati che finiscono in `LocalizedTexts`.
const String localizedNameField = 'name';
const String localizedDescriptionField = 'description';
const String localizedTipsField = 'tips';

/// Riepilogo di lista → riga di catalogo.
///
/// Persiste **tutti** i campi filtrabili, non tre. Era esattamente l'omissione
/// che faceva tornare zero risultati a qualsiasi filtro diverso dal testo.
/// `payload` è volutamente assente: un riepilogo non deve cancellare un
/// dettaglio già scaricato.
CatalogExercisesCompanion summaryToRow(
  ExerciseModel exercise, {
  required DateTime updatedAt,
}) {
  return CatalogExercisesCompanion.insert(
    id: exercise.id!,
    difficultyLevel: Value(exercise.difficultyLevel),
    mechanicsType: Value(exercise.mechanicsType),
    forceType: Value(exercise.forceType),
    unilateral: _boolValue(exercise.isUnilateral),
    bodyweight: _boolValue(exercise.isBodyweight),
    updatedAt: updatedAt,
  );
}

/// Dettaglio completo → riga di catalogo, blob incluso.
CatalogExercisesCompanion detailToRow(
  ExerciseDetailModel exercise, {
  required DateTime updatedAt,
}) {
  return CatalogExercisesCompanion.insert(
    id: exercise.id!,
    difficultyLevel: Value(exercise.difficultyLevel),
    mechanicsType: Value(exercise.mechanicsType),
    forceType: Value(exercise.forceType),
    unilateral: _boolValue(exercise.isUnilateral),
    bodyweight: _boolValue(exercise.isBodyweight),
    payload: Value(jsonEncode(exercise.toJson())),
    updatedAt: updatedAt,
  );
}

/// Le mappe `*I18n` di un modello → righe di `LocalizedTexts`.
///
/// Una riga per lingua: aggiungere una lingua è un delta di dati, non una
/// migrazione di schema (`docs/development/13-i18n.md`).
List<LocalizedTextsCompanion> localizedTextRows({
  required String exerciseId,
  Map<String, String>? nameI18n,
  Map<String, String>? descriptionI18n,
  Map<String, String>? tipsI18n,
}) {
  return [
    ..._rowsForField(exerciseId, localizedNameField, nameI18n),
    ..._rowsForField(exerciseId, localizedDescriptionField, descriptionI18n),
    ..._rowsForField(exerciseId, localizedTipsField, tipsI18n),
  ];
}

/// Muscoli coinvolti → righe della tabella ponte.
///
/// Tabella ponte e non blob perché il filtro è per appartenenza, e un JSON non
/// si indicizza.
List<ExerciseMusclesCompanion> muscleRows(ExerciseDetailModel exercise) {
  final exerciseId = exercise.id;
  if (exerciseId == null || exerciseId.isEmpty) return const [];

  final rows = <String, ExerciseMusclesCompanion>{};
  for (final entry in exercise.muscles ?? const []) {
    final muscle = entry.muscle;
    if (muscle == null || muscle.id.isEmpty) continue;
    rows[muscle.id] = ExerciseMusclesCompanion.insert(
      exerciseId: exerciseId,
      muscleId: muscle.id,
      muscleCode: Value(muscle.code),
      involvement: Value(_involvementOf(entry.activationPercentage)),
    );
  }
  return rows.values.toList(growable: false);
}

/// Attrezzi richiesti → righe della tabella ponte.
List<ExerciseEquipmentsCompanion> equipmentRows(ExerciseDetailModel exercise) {
  final exerciseId = exercise.id;
  if (exerciseId == null || exerciseId.isEmpty) return const [];

  final rows = <String, ExerciseEquipmentsCompanion>{};
  for (final entry in exercise.equipments ?? const []) {
    final equipment = entry.equipment;
    if (equipment.id.isEmpty) continue;
    rows[equipment.id] = ExerciseEquipmentsCompanion.insert(
      exerciseId: exerciseId,
      equipmentId: equipment.id,
      equipmentCode: Value(equipment.code),
      required: Value(entry.isRequired),
    );
  }
  return rows.values.toList(growable: false);
}

/// Riga di catalogo + nomi localizzati → riepilogo di lista.
///
/// `isPersonal` è sempre falso: il catalogo contiene solo esercizi Coachly, gli
/// esercizi dell'utente stanno in `CustomExercises`, che è una tabella diversa
/// perché il catalogo si sostituisce in blocco e loro no.
ExerciseModel rowToSummary(
  CatalogExerciseRow row, {
  Map<String, String>? nameI18n,
}) {
  return ExerciseModel(
    id: row.id,
    nameI18n: (nameI18n == null || nameI18n.isEmpty) ? null : nameI18n,
    difficultyLevel: row.difficultyLevel,
    mechanicsType: row.mechanicsType,
    forceType: row.forceType,
    isUnilateral: row.unilateral,
    isBodyweight: row.bodyweight,
  );
}

/// Riga di catalogo → dettaglio, decodificando il blob.
///
/// `null` quando il dettaglio non è ancora stato scaricato **o** quando il blob
/// non è più leggibile: per il chiamante i due casi coincidono, è una cache
/// miss e si va in rete.
ExerciseDetailModel? rowToDetail(CatalogExerciseRow row) {
  final payload = row.payload;
  if (payload == null || payload.isEmpty) return null;

  try {
    final decoded = jsonDecode(payload);
    if (decoded is! Map<String, dynamic>) return null;
    return ExerciseDetailModel.fromJson(decoded);
  } on FormatException {
    return null;
  }
}

/// Un dettaglio già in memoria → il riepilogo corrispondente.
ExerciseModel detailToSummary(ExerciseDetailModel exercise) => ExerciseModel(
  id: exercise.id,
  createdBy: exercise.createdBy,
  isPersonal: exercise.isPersonal,
  nameI18n: exercise.nameI18n,
  difficultyLevel: exercise.difficultyLevel,
  mechanicsType: exercise.mechanicsType,
  forceType: exercise.forceType,
  isUnilateral: exercise.isUnilateral,
  isBodyweight: exercise.isBodyweight,
);

Iterable<LocalizedTextsCompanion> _rowsForField(
  String exerciseId,
  String field,
  Map<String, String>? values,
) sync* {
  if (values == null) return;
  for (final entry in values.entries) {
    if (entry.key.isEmpty) continue;
    yield LocalizedTextsCompanion.insert(
      entityType: catalogExerciseEntityType,
      entityId: exerciseId,
      field: field,
      locale: entry.key,
      value: entry.value,
    );
  }
}

/// `null` deve lasciare il default della colonna, non scriverci `false`.
Value<bool> _boolValue(bool? value) =>
    value == null ? const Value.absent() : Value(value);

/// Il backend espone una percentuale di attivazione; lo schema locale un
/// livello di coinvolgimento. La soglia sta qui e non in presentazione perché è
/// il formato della riga, non una formattazione.
String? _involvementOf(int? activationPercentage) {
  if (activationPercentage == null) return null;
  if (activationPercentage >= 60) return 'primary';
  if (activationPercentage >= 20) return 'secondary';
  return 'stabilizer';
}
