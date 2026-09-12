/// Un delta del catalogo.
///
/// L'unità di cambiamento è **l'esercizio come lo consuma il client**, non la
/// riga di una tabella del backend: il payload che arriva qui è lo stesso che
/// servirebbe `GET /exercises/{id}/details`, e si salva così com'è.
final class CatalogDelta {
  const CatalogDelta({
    required this.since,
    required this.version,
    required this.complete,
    required this.exercises,
  });

  /// Watermark da cui il delta è stato chiesto.
  final int since;

  /// Nuovo watermark: applicato questo delta, si riparte da qui.
  final int version;

  /// `false` se il backend ha troncato e va richiamato con il nuovo [since].
  final bool complete;

  final List<CatalogExerciseChange> exercises;

  bool get isEmpty => exercises.isEmpty;

  static CatalogDelta fromJson(Map<String, dynamic> json) {
    final raw = json['exercises'];
    return CatalogDelta(
      since: (json['since'] as num?)?.toInt() ?? 0,
      version: (json['version'] as num?)?.toInt() ?? 0,
      complete: json['complete'] as bool? ?? true,
      exercises: raw is List
          ? raw
                .whereType<Map<String, dynamic>>()
                .map(CatalogExerciseChange.fromJson)
                .toList(growable: false)
          : const [],
    );
  }
}

/// Un esercizio cambiato.
final class CatalogExerciseChange {
  const CatalogExerciseChange({
    required this.id,
    required this.sha,
    required this.deleted,
    required this.payload,
  });

  final String id;

  /// Impronta del contenuto. Si conserva accanto all'esercizio: permette di
  /// verificare che il locale sia davvero ciò che il server crede che sia,
  /// senza riscaricare il payload per confrontarlo.
  final String sha;

  /// L'esercizio non fa più parte del catalogo. Il payload è l'ultimo noto e
  /// va ignorato: quello che conta è rimuoverlo dal locale.
  final bool deleted;

  /// Il dettaglio completo, già decodificato.
  final Map<String, dynamic> payload;

  static CatalogExerciseChange fromJson(Map<String, dynamic> json) {
    final payload = json['payload'];
    return CatalogExerciseChange(
      id: json['id'] as String? ?? '',
      sha: json['sha'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
      payload: payload is Map<String, dynamic> ? payload : const {},
    );
  }
}
