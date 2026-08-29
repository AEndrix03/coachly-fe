/// Criteri di ricerca sul catalogo esercizi, espressi in termini di **colonne**.
///
/// Non è `ExerciseFilterModel`: quello è il filtro della presentazione, con
/// `langFilter` e `categoryIds` che il backend interroga. Questo è ciò che si
/// può tradurre in una `WHERE` sullo schema locale
/// (`docs/development/04-data-layer.md`).
///
/// Ogni campo qui dentro corrisponde a una colonna indicizzata di
/// `CatalogExercises` o a una tabella ponte. È il motivo per cui il bug della
/// cache Hive — tre campi persistiti, nove interrogati — non è più
/// esprimibile: se un campo non è qui, non si può filtrare.
class ExerciseCatalogQuery {
  const ExerciseCatalogQuery({
    this.textFilter,
    this.scope,
    this.difficultyLevel,
    this.mechanicsType,
    this.forceType,
    this.isUnilateral,
    this.isBodyweight,
    this.muscleIds = const [],
    this.equipmentIds = const [],
    this.excludedExerciseIds = const {},
  });

  /// Sottostringa cercata fra i nomi localizzati, in qualsiasi lingua.
  final String? textFilter;

  /// `default` | `mine` | `community`. Il catalogo contiene solo esercizi
  /// Coachly: `mine` non ha righe qui, gli esercizi dell'utente vivono in
  /// `CustomExercises`.
  final String? scope;

  final String? difficultyLevel;
  final String? mechanicsType;
  final String? forceType;
  final bool? isUnilateral;
  final bool? isBodyweight;

  /// Appartenenza: l'esercizio passa se coinvolge **almeno uno** di questi
  /// muscoli. Join su `ExerciseMuscles`, non scansione in Dart.
  final List<String> muscleIds;

  /// Appartenenza su `ExerciseEquipments`, stessa semantica dei muscoli.
  final List<String> equipmentIds;

  final Set<String> excludedExerciseIds;

  /// Vero quando la query non restringe nulla: la lista completa.
  bool get isUnfiltered =>
      (textFilter == null || textFilter!.trim().isEmpty) &&
      (scope == null || scope!.isEmpty) &&
      difficultyLevel == null &&
      mechanicsType == null &&
      forceType == null &&
      isUnilateral == null &&
      isBodyweight == null &&
      muscleIds.isEmpty &&
      equipmentIds.isEmpty &&
      excludedExerciseIds.isEmpty;
}
