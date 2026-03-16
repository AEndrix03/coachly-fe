import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/models/auth_state/auth_state.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/auth_service_impl.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';
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

  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.endSession();
    await authService.clearTokens();
    await LocalDatabaseService().clearAll();
    state = const AsyncData(_unauthenticated);
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

    return refreshResult.fold(
      (failure) => _offlineAuthenticatedState(
        accessToken: accessToken,
        refreshToken: refreshToken,
        errorMessage: failure.message,
      ),
      _authenticatedStateFromTokens,
    );
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
    String? errorMessage,
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
      errorMessage: errorMessage,
    );
  }
}
