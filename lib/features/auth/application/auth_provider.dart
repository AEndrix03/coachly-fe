import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/network/connectivity_provider.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/models/auth_state/auth_state.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/auth_service_impl.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';
import 'package:coachly/core/sync/sync_queue.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

enum AuthStatus { idle, loading, authenticated, failed }

extension AuthStatusProjection on AuthState {
  AuthStatus get status {
    if (isLoading) return AuthStatus.loading;
    if (canAccessApp) return AuthStatus.authenticated;
    if (errorMessage != null) return AuthStatus.failed;
    return AuthStatus.idle;
  }
}

/// Se l'accesso ha qualche possibilita' di riuscire.
///
/// L'accesso passa da un browser: senza rete non c'e' niente da tentare, e la
/// schermata offre invece l'ingresso offline. Finche' la connettivita' non ha
/// risposto si assume che ci sia, per non far lampeggiare la scorciatoia.
@riverpod
bool canSignIn(Ref ref) => ref.watch(isOnlineProvider).value ?? true;

@riverpod
TokenManager tokenManager(Ref ref) => TokenManager();

@riverpod
AuthService authService(Ref ref) {
  final tokenManager = ref.watch(tokenManagerProvider);
  return AuthServiceImpl(tokenManager);
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
}

@riverpod
class Auth extends _$Auth {
  // Default unauthenticated state — isTokenValid must be false (field defaults to true).
  static const _unauthenticated = AuthState(
    isAuthenticated: false,
    isTokenValid: false,
    isOfflineMode: false,
  );

  @override
  Future<AuthState> build() async {
    return _restoreSession();
  }

  /// Tempo minimo in cui la schermata resta in attesa: il logo animato e'
  /// l'indicatore di caricamento, e un accesso istantaneo sarebbe un lampo
  /// che l'occhio legge come un errore.
  static const _minimumLoading = Duration(milliseconds: 300);

  /// Dopo un esito positivo il logo completa il giro prima che il router
  /// cambi pagina: il feedback di successo e' il marchio che si ferma.
  static const _successHold = Duration(milliseconds: 500);

  Future<void> login() async {
    state = const AsyncData(AuthState(isLoading: true));
    final repository = ref.read(authRepositoryProvider);
    final stopwatch = Stopwatch()..start();
    final result = await repository.login();

    final remaining = _minimumLoading - stopwatch.elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }

    final next = result.fold((failure) {
      if (failure is CancelledFailure) return _unauthenticated;

      ref
          .read(appLoggerProvider)
          .warn('Accesso non completato', error: failure);
      return _unauthenticated.copyWith(errorMessage: 'auth_failed');
    }, _authenticatedStateFromTokens);

    if (next.canAccessApp) {
      await Future<void>.delayed(_successHold);
    }
    state = AsyncData(next);
  }

  /// Entra nella app senza account, con la sola memoria locale.
  ///
  /// Offerto quando il dispositivo non ha rete: l'accesso passa da un browser
  /// e senza rete non puo' riuscire. Non crea nessuna sessione, quindi al
  /// ritorno della rete l'accesso vero resta da fare.
  void continueOffline() {
    ref.read(appLoggerProvider).info('Ingresso offline senza account');
    state = const AsyncData(
      AuthState(isTokenValid: false, isOfflineGuest: true),
    );
  }

  /// Numero di allenamenti registrati e non ancora inviati al backend.
  ///
  /// Il logout cancella il database locale: quei dati sono l'unica copia
  /// esistente di ciò che l'utente ha registrato in palestra, spesso offline.
  /// Vedi `docs/development/24-security-and-privacy.md`.
  Future<int> pendingSyncCount() async {
    try {
      return ref.read(syncQueueProvider).pendingCount();
    } catch (error) {
      ref
          .read(appLoggerProvider)
          .warn('Impossibile leggere la coda di sync', error: error);
      // In dubbio si assume che ci siano dati da perdere: meglio un avviso
      // di troppo che una cancellazione silenziosa.
      return 1;
    }
  }

  /// Chiude la sessione e cancella i dati locali.
  ///
  /// [force] deve essere `true` solo dopo che l'utente ha confermato
  /// esplicitamente di voler uscire pur avendo dati non sincronizzati.
  /// Senza conferma il logout viene rifiutato e ritorna `false`.
  Future<bool> logout({bool force = false}) async {
    if (!force && await pendingSyncCount() > 0) {
      ref
          .read(appLoggerProvider)
          .warn('Logout rifiutato: coda di sync non vuota');
      return false;
    }

    final authService = ref.read(authServiceProvider);
    await authService.endSession();
    await authService.clearTokens();
    await ref.read(appDatabaseProvider).wipe();
    state = const AsyncData(_unauthenticated);
    return true;
  }

  Future<AuthState> _restoreSession() async {
    final authService = ref.read(authServiceProvider);
    final accessToken = await authService.getAccessToken();
    final refreshToken = await authService.getRefreshToken();

    // Session policy:
    // - refresh token missing/invalid => force login
    // - refresh token valid => always refresh tokens and skip login
    if (refreshToken == null || refreshToken.isEmpty) {
      await authService.clearTokens();
      return _unauthenticated;
    }

    if (!JwtValidator.isTokenValid(refreshToken)) {
      await authService.clearTokens();
      return _unauthenticated;
    }

    if (accessToken != null && JwtValidator.isTokenValid(accessToken)) {
      return _authenticatedStateFromTokens(
        LoginResponseDto.fromTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      );
    }

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any(
      (result) => result != ConnectivityResult.none,
    );
    if (!isOnline) {
      return _offlineAuthenticatedState(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }

    final refreshResult = await ref
        .read(authRepositoryProvider)
        .refreshToken(refreshToken);

    // Online but Keycloak rejected (or failed to renew) the refresh token —
    // the session is definitively dead. Clear tokens and force re-login.
    if (refreshResult.isLeft) {
      await authService.clearTokens();
      return _unauthenticated;
    }

    return _authenticatedStateFromTokens(refreshResult.rightOrNull!);
  }

  AuthState _authenticatedStateFromTokens(LoginResponseDto tokens) {
    return AuthState(
      isAuthenticated: true,
      isTokenValid: JwtValidator.isTokenValid(tokens.accessToken),
      isOfflineMode: false,
      tokens: tokens,
    );
  }

  AuthState _offlineAuthenticatedState({
    required String? accessToken,
    required String refreshToken,
  }) {
    return AuthState(
      isAuthenticated: true,
      isTokenValid:
          accessToken != null && JwtValidator.isTokenValid(accessToken),
      isOfflineMode: true,
      tokens: LoginResponseDto.fromTokens(
        accessToken: accessToken ?? '',
        refreshToken: refreshToken,
      ),
    );
  }
}
