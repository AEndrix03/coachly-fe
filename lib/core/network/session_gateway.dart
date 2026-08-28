import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ciò che il layer di rete ha bisogno di sapere sulla sessione, espresso
/// **senza conoscere la feature auth**.
///
/// Inverte la dipendenza: prima `core/network/` importava
/// `features/auth/`, violando la dependency rule D5 di
/// `docs/development/01-principles.md`. Ora è la feature auth a dipendere da
/// questa interfaccia, e l'implementazione viene iniettata in `app/`.
abstract interface class SessionGateway {
  /// Token corrente, se esiste. Non ne garantisce la validità.
  Future<String?> accessToken();

  /// `true` se il token va rinnovato prima di usarlo.
  bool shouldRefresh(String accessToken);

  /// Rinnova la sessione. Ritorna `true` se ora esiste un token valido.
  ///
  /// L'implementazione deve essere **coalescente**: N chiamate concorrenti
  /// producono un solo rinnovo.
  Future<bool> refresh();

  /// La sessione è definitivamente morta: pulisce i token e riporta al login.
  Future<void> invalidateSession();
}

/// Va sovrascritto in `app/`: `core/` non può costruire l'implementazione,
/// perché vive nella feature auth.
final sessionGatewayProvider = Provider<SessionGateway>((ref) {
  throw UnimplementedError(
    'sessionGatewayProvider va sovrascritto nel ProviderScope della app. '
    'Vedi lib/app/bootstrap/provider_overrides.dart.',
  );
});
