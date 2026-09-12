import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/result/api_response_result.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/catalog_sync/data/local/catalog_meta_dao.dart';
import 'package:coachly/features/catalog_sync/data/services/catalog_delta_service.dart';
import 'package:coachly/features/catalog_sync/domain/catalog_delta.dart';
import 'package:coachly/features/exercises/data/local/exercise_catalog_dao.dart';
import 'package:coachly/features/exercises/domain/models/exercise_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catalogSyncRepositoryProvider = Provider<CatalogSyncRepository>((ref) {
  return CatalogSyncRepository(
    deltaService: ref.watch(catalogDeltaServiceProvider),
    metaDao: ref.watch(catalogMetaDaoProvider),
    catalogDao: ref.watch(exerciseCatalogDaoProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

/// Esito di un controllo del catalogo.
enum CatalogSyncOutcome {
  /// La versione locale coincide con quella del backend: nessun trasferimento.
  alreadyCurrent,

  /// Il catalogo è stato aggiornato.
  updated,

  /// Il controllo non è riuscito. Non è un errore per l'utente: il catalogo
  /// che ha sul dispositivo resta valido.
  skipped,
}

/// Tiene aggiornato il catalogo installato.
///
/// Due guadagni, in quest'ordine di importanza.
///
/// **Nel caso normale non si trasferisce niente.** «Non è cambiato niente» è
/// quasi sempre la risposta giusta, e costa il confronto di un intero
/// (`docs/development/06-networking.md`).
///
/// **Quando qualcosa cambia, viaggia solo quello.** Il backend versiona
/// l'esercizio per contenuto, quindi il delta contiene gli esercizi davvero
/// diversi — non quelli riscritti con gli stessi valori da un import.
class CatalogSyncRepository {
  CatalogSyncRepository({
    required CatalogDeltaService deltaService,
    required CatalogMetaDao metaDao,
    required ExerciseCatalogDao catalogDao,
    AppLogger logger = const ConsoleAppLogger(),
  }) : _deltaService = deltaService,
       _metaDao = metaDao,
       _catalogDao = catalogDao,
       _logger = logger;

  /// Quante pagine di delta si applicano al massimo in un giro.
  ///
  /// Il primo avvio su un catalogo grande richiede più pagine; il tetto
  /// impedisce che un backend che risponde sempre «incompleto» tenga la app a
  /// scaricare all'infinito.
  static const int maxPages = 20;

  final CatalogDeltaService _deltaService;
  final CatalogMetaDao _metaDao;
  final ExerciseCatalogDao _catalogDao;
  final AppLogger _logger;

  /// Aggiorna il catalogo solo se il backend ne ha una versione diversa.
  Future<Result<CatalogSyncOutcome, Failure>> syncIfNeeded() async {
    final remoteVersion = (await _deltaService.fetchVersion()).toResult();

    switch (remoteVersion) {
      case Err(:final failure):
        // Senza rete il catalogo locale resta quello buono: la app è
        // local-first e non dipende da questa chiamata per funzionare.
        _logger.info(
          'Catalog version check skipped.',
          context: {'failure': failure.runtimeType.toString()},
        );
        return const Ok(CatalogSyncOutcome.skipped);

      case Ok(:final value):
        final localVersion = await _metaDao.currentVersion();
        if (value == localVersion) {
          return const Ok(CatalogSyncOutcome.alreadyCurrent);
        }
        return _applyDeltaFrom(localVersion);
    }
  }

  /// Scarica e applica le pagine di delta a partire da [since].
  Future<Result<CatalogSyncOutcome, Failure>> _applyDeltaFrom(int since) async {
    var cursor = since;

    for (var page = 0; page < maxPages; page++) {
      final response = (await _deltaService.fetchDelta(
        since: cursor,
      )).toResult();

      switch (response) {
        case Err(:final failure):
          return Err(failure);

        case Ok(:final value):
          await _applyPage(value);

          // Il watermark si scrive **dopo** aver applicato la pagina, mai
          // prima: se l'applicazione si interrompe, al giro successivo si
          // riparte da dove si era rimasti invece di saltare le righe che non
          // sono state applicate.
          cursor = value.version;
          await _metaDao.setVersion(cursor);

          if (value.complete) {
            return const Ok(CatalogSyncOutcome.updated);
          }
      }
    }

    // Non è un errore: il catalogo locale è coerente fino a `cursor` e il giro
    // successivo riprende da lì.
    _logger.warn(
      'Catalog delta still incomplete after the page limit.',
      context: {'pages': maxPages, 'version': cursor},
    );
    return const Ok(CatalogSyncOutcome.updated);
  }

  Future<void> _applyPage(CatalogDelta delta) async {
    for (final change in delta.exercises) {
      if (change.id.isEmpty) continue;

      if (change.deleted) {
        await _catalogDao.removeExercise(change.id);
        continue;
      }

      await _catalogDao.upsertDetail(
        ExerciseDetailModel.fromJson(change.payload),
        sha: change.sha,
      );
    }
  }
}
