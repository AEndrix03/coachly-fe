import 'dart:math';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/sync/sync_queue.dart';
import 'package:coachly/core/database/tables/user_tables.dart';
import 'package:coachly/core/time/clock.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'outbox_dao.g.dart';

/// Gli stati reali della coda: **quattro**, e nessuno di piu'.
///
/// Non esistono `conflict` o `rejected`: il client e' l'autore e il server non
/// corregge (`docs/development/05-sync-and-offline.md`).
enum OutboxStatus {
  pending('pending'),
  sending('sending'),
  sent('sent'),
  failedPermanent('failed_permanent');

  const OutboxStatus(this.value);

  final String value;

  static OutboxStatus fromValue(String? value) {
    return OutboxStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OutboxStatus.pending,
    );
  }

  bool get isTerminal =>
      this == OutboxStatus.sent || this == OutboxStatus.failedPermanent;
}

/// La coda di caricamento verso il backend: append-only, client-authored.
///
/// Un `failedPermanent` non cancella mai il dato locale: il fallimento riguarda
/// la telemetria, non l'utente.
@DriftAccessor(tables: [Outbox])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.db, {required Clock clock, Random? random})
    : _clock = clock,
      _random = random ?? Random();

  /// Backoff esponenziale con jitter, 5s -> 15min
  /// (`docs/development/05-sync-and-offline.md`).
  static const Duration retryBaseDelay = Duration(seconds: 5);
  static const Duration retryMaxDelay = Duration(minutes: 15);

  final Clock _clock;
  final Random _random;

  /// Accoda una riga. **Va chiamata nella stessa transazione del dato**: se il
  /// dato entrasse senza la sua riga di outbox, l'allenamento resterebbe sul
  /// dispositivo e non salirebbe mai.
  Future<void> enqueue({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    String? secondaryPayload,
  }) {
    final now = _clock.nowUtc();
    return into(outbox).insert(
      OutboxCompanion.insert(
        id: id,
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        payload: payload,
        secondaryPayload: Value(secondaryPayload),
        status: Value(OutboxStatus.pending.value),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// FIFO: l'ordine di creazione e' l'ordine di invio.
  Future<List<OutboxRow>> pendingOrdered({String? entityType}) {
    final query = select(outbox)
      ..where(
        (row) => row.status.isIn([
          OutboxStatus.pending.value,
          OutboxStatus.sending.value,
        ]),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.createdAt),
        (row) => OrderingTerm.asc(row.id),
      ]);
    if (entityType != null) {
      query.where((row) => row.entityType.equals(entityType));
    }
    return query.get();
  }

  Stream<List<OutboxRow>> watchPending() {
    final query = select(outbox)
      ..where(
        (row) => row.status.isIn([
          OutboxStatus.pending.value,
          OutboxStatus.sending.value,
        ]),
      )
      ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]);
    return query.watch();
  }

  Future<OutboxRow?> getById(String id) {
    return (select(
      outbox,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<OutboxRow?> getByEntityId(String entityId) {
    final query = select(outbox)
      ..where((row) => row.entityId.equals(entityId))
      ..orderBy([(row) => OrderingTerm.asc(row.createdAt)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  /// L'istante piu' vicino in cui vale la pena ritentare, se esiste.
  Future<DateTime?> earliestNextAttemptAt() async {
    final rows = await pendingOrdered();
    DateTime? earliest;
    for (final row in rows) {
      final next = row.nextAttemptAt;
      if (next == null) {
        continue;
      }
      if (earliest == null || next.isBefore(earliest)) {
        earliest = next;
      }
    }
    return earliest;
  }

  Future<void> markSending(String id) => _write(id, OutboxStatus.sending);

  Future<void> markSent(String id) => _write(id, OutboxStatus.sent);

  /// Fallimento transitorio: la riga torna `pending` con il prossimo tentativo
  /// gia' calcolato.
  Future<DateTime> markFailed(String id, {required String error}) async {
    final row = await getById(id);
    final attempts = (row?.attempts ?? 0) + 1;
    final nextAttemptAt = nextAttemptFor(attempts);
    await (update(outbox)..where((table) => table.id.equals(id))).write(
      OutboxCompanion(
        status: Value(OutboxStatus.pending.value),
        attempts: Value(attempts),
        nextAttemptAt: Value(nextAttemptAt),
        lastError: Value(error),
        updatedAt: Value(_clock.nowUtc()),
      ),
    );
    return nextAttemptAt;
  }

  /// 4xx non recuperabile: si logga, non si ritenta, **non si perde il dato**.
  Future<void> markFailedPermanent(String id, {required String error}) async {
    final row = await getById(id);
    await (update(outbox)..where((table) => table.id.equals(id))).write(
      OutboxCompanion(
        status: Value(OutboxStatus.failedPermanent.value),
        attempts: Value((row?.attempts ?? 0) + 1),
        nextAttemptAt: const Value(null),
        lastError: Value(error),
        updatedAt: Value(_clock.nowUtc()),
      ),
    );
  }

  /// Pota le righe confermate dal server: sono l'unica cosa che si puo' buttare.
  Future<int> pruneSent() {
    return (delete(
      outbox,
    )..where((row) => row.status.equals(OutboxStatus.sent.value))).go();
  }

  /// Esponenziale con jitter fino al 20%, saturato a [retryMaxDelay].
  DateTime nextAttemptFor(int attempts) {
    final bounded = attempts < 1 ? 1 : attempts;
    final baseSeconds = retryBaseDelay.inSeconds * pow(2, bounded - 1);
    final clampedSeconds = min(baseSeconds.toInt(), retryMaxDelay.inSeconds);
    final jitterMillis = (clampedSeconds * 1000 * (_random.nextDouble() * 0.2))
        .round();
    return _clock.nowUtc().add(
      Duration(seconds: clampedSeconds, milliseconds: jitterMillis),
    );
  }

  Future<void> _write(String id, OutboxStatus status) async {
    await (update(outbox)..where((table) => table.id.equals(id))).write(
      OutboxCompanion(
        status: Value(status.value),
        updatedAt: Value(_clock.nowUtc()),
        nextAttemptAt: status == OutboxStatus.sent
            ? const Value(null)
            : const Value.absent(),
        lastError: status == OutboxStatus.sent
            ? const Value(null)
            : const Value.absent(),
      ),
    );
  }
}

/// `keepAlive`: la coda vive quanto il database.
final outboxDaoProvider = Provider<OutboxDao>(
  (ref) => OutboxDao(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

/// Implementazione di [SyncQueue] sopra l'outbox.
///
/// La dipendenza punta verso il basso: e' la feature a conoscere `core/sync`,
/// non il contrario (`docs/development/01-principles.md`).
class OutboxSyncQueue implements SyncQueue {
  const OutboxSyncQueue(this._dao);

  final OutboxDao _dao;

  @override
  Future<int> pendingCount() async => (await _dao.pendingOrdered()).length;
}
