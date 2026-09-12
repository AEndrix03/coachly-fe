import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/result/api_response_result.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/catalog_sync/data/local/catalog_meta_dao.dart';
import 'package:coachly/features/catalog_sync/data/services/catalog_delta_service.dart';
import 'package:coachly/features/exercises/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercises/data/repositories/exercise_info_page_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catalogSyncRepositoryProvider = Provider<CatalogSyncRepository>((ref) {
  return CatalogSyncRepository(
    deltaService: ref.watch(catalogDeltaServiceProvider),
    metaDao: ref.watch(catalogMetaDaoProvider),
    exerciseRepository: ref.watch(exerciseInfoPageRepositoryProvider),
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
/// **Il guadagno sta nel caso normale**, che è «non è cambiato niente»: si
/// confronta un intero invece di scaricare il catalogo
/// (`docs/development/06-networking.md`, dove il delta è descritto come «una
/// volta per sessione, spesso vuota»). Prima il catalogo veniva riscaricato
/// per intero a ogni ritorno in foreground.
class CatalogSyncRepository {
  CatalogSyncRepository({
    required CatalogDeltaService deltaService,
    required CatalogMetaDao metaDao,
    required IExerciseInfoPageRepository exerciseRepository,
    AppLogger logger = const ConsoleAppLogger(),
  }) : _deltaService = deltaService,
       _metaDao = metaDao,
       _exerciseRepository = exerciseRepository,
       _logger = logger;

  final CatalogDeltaService _deltaService;
  final CatalogMetaDao _metaDao;
  final IExerciseInfoPageRepository _exerciseRepository;
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
        if (value == localVersion && localVersion != 0) {
          return const Ok(CatalogSyncOutcome.alreadyCurrent);
        }

        final refreshed = await _exerciseRepository.refreshFromRemoteResult();
        if (refreshed is Err) {
          return Err(refreshed.failureOrNull!);
        }

        // La versione si scrive **solo dopo** un aggiornamento riuscito.
        // Scriverla prima farebbe credere alla app di avere un catalogo che
        // non ha, e il disallineamento non si correggerebbe mai da solo.
        await _metaDao.setVersion(value);
        return const Ok(CatalogSyncOutcome.updated);
    }
  }
}
