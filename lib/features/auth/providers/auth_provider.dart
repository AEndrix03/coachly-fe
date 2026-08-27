import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/models/auth_state/auth_state.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/auth_service_impl.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_session_hive_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

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

  Future<void> login() async {
    state = const AsyncData(AuthState(isLoading: true));
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.login();

    state = AsyncData(
      result.fold(
        (failure) => _unauthenticated.copyWith(errorMessage: failure.message),
        _authenticatedStateFromTokens,
      ),
    );
  }

  /// Numero di allenamenti registrati e non ancora inviati al backend.
  ///
  /// Il logout cancella il database locale: quei dati sono l'unica copia
  /// esistente di ciò che l'utente ha registrato in palestra, spesso offline.
  /// Vedi `docs/development/24-security-and-privacy.md`.
  Future<int> pendingSyncCount() async {
    try {
      final jobs = await ref
          .read(workoutSessionHiveServiceProvider)
          .getPendingJobsOrdered();
      return jobs.length;
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
    await LocalDatabaseService().clearAll();
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
      isTokenValid: accessToken != null && JwtValidator.isTokenValid(accessToken),
      isOfflineMode: true,
      tokens: LoginResponseDto.fromTokens(
        accessToken: accessToken ?? '',
        refreshToken: refreshToken,
      ),
    );
  }
}
