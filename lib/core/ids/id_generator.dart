import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Unica sorgente di identificatori del client.
///
/// Vedi `docs/development/05-sync-and-offline.md`: ogni riga di outbox ha un
/// id UUID v4 generato dal client che viaggia come `Idempotency-Key`. Gli id
/// non si generano mai a mano.
abstract interface class IdGenerator {
  /// Nuovo identificatore di entità (UUID v4).
  String newId();

  /// Nuova chiave di idempotenza per una richiesta di sync.
  String newIdempotencyKey();
}

/// Implementazione di produzione, basata sul pacchetto `uuid` già in pubspec.
class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator([this._uuid = const Uuid()]);

  final Uuid _uuid;

  @override
  String newId() => _uuid.v4();

  @override
  String newIdempotencyKey() => _uuid.v4();
}

/// Implementazione deterministica per i test: id prevedibili e ordinati.
///
/// `SequentialIdGenerator(prefix: 'job')` produce `job-1`, `job-2`, …
class SequentialIdGenerator implements IdGenerator {
  SequentialIdGenerator({this.prefix = 'id', this.idempotencyPrefix = 'idem'});

  final String prefix;
  final String idempotencyPrefix;

  int _idCount = 0;
  int _keyCount = 0;

  /// Numero di id emessi finora.
  int get issuedIds => _idCount;

  /// Numero di chiavi di idempotenza emesse finora.
  int get issuedIdempotencyKeys => _keyCount;

  @override
  String newId() => '$prefix-${++_idCount}';

  @override
  String newIdempotencyKey() => '$idempotencyPrefix-${++_keyCount}';
}

/// `keepAlive`: generatore senza stato condiviso, vive quanto il container.
final idGeneratorProvider = Provider<IdGenerator>(
  (ref) => const UuidIdGenerator(),
);
