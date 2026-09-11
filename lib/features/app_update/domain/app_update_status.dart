import 'package:coachly/features/app_update/domain/app_version.dart';

/// Esito del confronto fra la versione installata e le soglie del backend.
enum AppUpdateStatus {
  /// Versione sopra entrambe le soglie, oppure soglie non note.
  upToDate,

  /// Sotto la versione consigliata: avviso ignorabile.
  updateRecommended,

  /// Sotto la versione minima: la app non prosegue.
  updateRequired,
}

/// Soglie pubblicate dal backend.
///
/// Sono dati di configurazione, non di dominio dell'utente: nascono da
/// `GET /app/requirements` e non sopravvivono in outbox.
final class AppRequirements {
  const AppRequirements({
    required this.minSupportedVersion,
    required this.recommendedVersion,
    this.message = '',
  });

  final String minSupportedVersion;
  final String recommendedVersion;

  /// Testo straordinario deciso dal backend. Vuoto nel caso normale, e in quel
  /// caso la schermata usa la stringa tradotta del client
  /// (`docs/development/13-i18n.md`): il backend non conosce la lingua.
  final String message;

  /// Confronta [installed] con le soglie.
  ///
  /// **Regola di sicurezza:** qualunque valore non interpretabile — soglia
  /// malformata o versione installata malformata — vale [AppUpdateStatus.upToDate].
  /// Una configurazione sbagliata lato server deve poter rompere al massimo
  /// l'avviso, mai l'accesso alla app: gli utenti hanno i loro dati solo sul
  /// dispositivo (`01-principles.md`), chiuderli fuori per un typo in una
  /// variabile d'ambiente e' il danno peggiore dei due.
  AppUpdateStatus statusFor(String installed) {
    final current = AppVersion.tryParse(installed);
    if (current == null) return AppUpdateStatus.upToDate;

    final minimum = AppVersion.tryParse(minSupportedVersion);
    if (minimum != null && current < minimum) {
      return AppUpdateStatus.updateRequired;
    }

    final recommended = AppVersion.tryParse(recommendedVersion);
    if (recommended != null && current < recommended) {
      return AppUpdateStatus.updateRecommended;
    }

    return AppUpdateStatus.upToDate;
  }
}
