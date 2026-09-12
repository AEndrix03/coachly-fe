/// Un delta del catalogo, così come lo manda il backend.
///
/// Le righe non vengono interpretate qui: sono mappe grezze che il data layer
/// travasa nelle tabelle locali. Il client non ha una classe per ognuna delle
/// ventidue tabelle del backend, e non deve averla: lo schema locale è
/// modellato dalle clausole `WHERE` della app, non dalla normalizzazione del
/// backend (`docs/development/04-data-layer.md`).
final class CatalogDelta {
  const CatalogDelta({
    required this.since,
    required this.version,
    required this.complete,
    required this.tables,
  });

  /// Watermark da cui il delta è stato chiesto.
  final int since;

  /// Nuovo watermark: applicato questo delta, si riparte da qui.
  ///
  /// Non è il massimo che si vede nelle righe: quando il backend tronca, è la
  /// soglia sotto la quale è garantito che non manchi nulla.
  final int version;

  /// `false` se il backend ha troncato e va richiamato con il nuovo [since].
  final bool complete;

  final Map<String, CatalogTableDelta> tables;

  bool get isEmpty => tables.isEmpty;

  static CatalogDelta fromJson(Map<String, dynamic> json) {
    final rawTables = json['tables'];
    return CatalogDelta(
      since: (json['since'] as num?)?.toInt() ?? 0,
      version: (json['version'] as num?)?.toInt() ?? 0,
      complete: json['complete'] as bool? ?? true,
      tables: rawTables is Map<String, dynamic>
          ? rawTables.map(
              (table, value) => MapEntry(
                table,
                CatalogTableDelta.fromJson(value as Map<String, dynamic>),
              ),
            )
          : const {},
    );
  }
}

/// Righe cambiate e chiavi sparite per una singola tabella.
final class CatalogTableDelta {
  const CatalogTableDelta({required this.upserted, required this.deleted});

  /// Righe intere, da sovrascrivere per chiave.
  final List<Map<String, dynamic>> upserted;

  /// Chiavi primarie delle righe sparite. Sono oggetti e non stringhe perché
  /// nove tabelle su ventidue hanno una chiave composta.
  final List<Map<String, dynamic>> deleted;

  static CatalogTableDelta fromJson(Map<String, dynamic> json) {
    return CatalogTableDelta(
      upserted: _rows(json['upserted']),
      deleted: _rows(json['deleted']),
    );
  }

  static List<Map<String, dynamic>> _rows(Object? raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().toList(growable: false);
  }
}
