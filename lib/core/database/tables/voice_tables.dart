import 'package:drift/drift.dart';

/// Alias vocali imparati dall'utente.
///
/// Ogni conferma manuale dopo un `needsConfirmation` produce un alias che alza
/// la confidenza per quella persona: è l'apprendimento più economico
/// disponibile e non richiede nessun modello (`docs/development/23-voice.md`).
///
/// Sono **dati utente**: locali, e sincronizzati come tutto il resto.
@DataClassName('VoiceAliasRow')
class VoiceAliases extends Table {
  /// Testo pronunciato, già normalizzato.
  TextColumn get phrase => text()();

  TextColumn get exerciseId => text()();

  IntColumn get hits => integer().withDefault(const Constant(1))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get lastUsedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {phrase};
}

/// Log di risoluzione vocale, per la calibrazione delle soglie.
///
/// Restano **locali** e si sincronizzano solo con consenso esplicito, perché
/// contengono trascrizioni di parlato registrato in un luogo pubblico, dove
/// possono comparire terzi (`docs/development/24-security-and-privacy.md`).
/// Il testo grezzo pre-normalizzazione non si conserva.
///
/// Si potano dopo 90 giorni.
@DataClassName('VoiceResolutionLogRow')
class VoiceResolutionLogs extends Table {
  TextColumn get id => text()();

  /// Testo **normalizzato**, mai quello grezzo.
  TextColumn get normalizedText => text()();

  /// Candidati e punteggi, come JSON.
  TextColumn get candidates => text().nullable()();

  TextColumn get outcome => text()();

  TextColumn get chosenExerciseId => text().nullable()();

  /// L'esercizio che l'utente ha scelto correggendo la proposta.
  TextColumn get correctedExerciseId => text().nullable()();

  RealColumn get confidence => real().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
