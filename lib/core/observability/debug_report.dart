import 'package:coachly/core/config/app_config.dart';
import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/flags/feature_flags.dart';
import 'package:coachly/core/sync/sync_queue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tutto ciò che serve per capire cosa sta facendo la app su un dispositivo
/// che non è il tuo.
///
/// `docs/development/05-sync-and-offline.md` elenca esattamente queste voci:
/// righe in outbox per stato con l'ultimo errore, `catalog_version` e data
/// dell'ultimo delta, `schemaVersion` del DB, `CACHE_MODE` e l'intera
/// `AppConfig` attiva.
class DebugReport {
  const DebugReport({
    required this.config,
    required this.flags,
    required this.schemaVersion,
    required this.catalogVersion,
    required this.catalogAppliedAt,
    required this.sync,
  });

  final Map<String, Object> config;
  final Map<String, bool> flags;
  final int schemaVersion;
  final int? catalogVersion;
  final DateTime? catalogAppliedAt;
  final SyncQueueDiagnostics sync;
}

/// `autoDispose`: la fotografia vale finché la schermata è aperta.
final debugReportProvider = FutureProvider.autoDispose<DebugReport>((
  ref,
) async {
  final db = ref.watch(appDatabaseProvider);
  final meta = await db.select(db.catalogMeta).getSingleOrNull();

  return DebugReport(
    config: AppConfig.debugSnapshot,
    flags: FeatureFlags.snapshot,
    schemaVersion: db.schemaVersion,
    catalogVersion: meta?.version,
    catalogAppliedAt: meta?.appliedAt,
    sync: await ref.watch(syncQueueProvider).diagnostics(),
  );
});
