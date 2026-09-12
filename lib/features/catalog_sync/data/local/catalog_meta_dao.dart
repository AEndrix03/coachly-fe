import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/database/tables/catalog_tables.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'catalog_meta_dao.g.dart';

/// Versione del catalogo installato.
///
/// Una riga sola, con chiave fissa `0`: non è una tabella di dati, è un
/// contatore. La chiave costante evita che una scrittura sbagliata ne crei una
/// seconda e lasci la app con due verità su quale catalogo ha.
@DriftAccessor(tables: [CatalogMeta])
class CatalogMetaDao extends DatabaseAccessor<AppDatabase>
    with _$CatalogMetaDaoMixin {
  CatalogMetaDao(super.db, this._clock);

  static const int _singletonId = 0;

  final Clock _clock;

  /// Versione applicata localmente. `0` quando non è mai stato aggiornato.
  Future<int> currentVersion() async {
    final row = await (select(
      catalogMeta,
    )..where((table) => table.id.equals(_singletonId))).getSingleOrNull();
    return row?.version ?? 0;
  }

  /// Registra la versione applicata.
  Future<void> setVersion(int version) async {
    await into(catalogMeta).insertOnConflictUpdate(
      CatalogMetaCompanion.insert(
        id: const Value(_singletonId),
        version: Value(version),
        appliedAt: Value(_clock.nowUtc()),
      ),
    );
  }
}

/// `keepAlive`: il DAO vive quanto il database.
final catalogMetaDaoProvider = Provider<CatalogMetaDao>(
  (ref) => CatalogMetaDao(ref.watch(appDatabaseProvider), ref.watch(clockProvider)),
);
