import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/models/auth_state/auth_state.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/auth_service_impl.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';
import 'package:coachly/features/auth/data/utils/sync_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
TokenManager tokenManager(Ref ref) => TokenManager();

@riverpod
SyncManager syncManager(Ref ref) => SyncManager();

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
        (failure) => AuthState(
          isAuthenticated: false,
          isTokenValid: false,
          isOfflineMode: false,
          errorMessage: failure.message,
        ),
        _authenticatedStateFromTokens,
      ),
    );
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider).endSession();
    await ref.read(authServiceProvider).clearTokens();
    state = const AsyncData(
      AuthState(
        isAuthenticated: false,
        isTokenValid: false,
        isOfflineMode: false,
      ),
    );
  }

  Future<void> forceReLogin() async {
    await logout();
  }

  Future<AuthState> _restoreSession() async {
    final authService = ref.read(authServiceProvider);
    final accessToken = await authService.getAccessToken();
    final refreshToken = await authService.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      await authService.clearTokens();
      return const AuthState(
        isAuthenticated: false,
        isTokenValid: false,
        isOfflineMode: false,
      );
    }

    if (JwtValidator.isTokenValid(accessToken)) {
      return _authenticatedStateFromTokens(
        LoginResponseDto.fromTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      );
    }

    if (!JwtValidator.isTokenValid(refreshToken)) {
      await authService.clearTokens();
      return const AuthState(
        isAuthenticated: false,
        isTokenValid: false,
        isOfflineMode: false,
      );
    }

    final refreshResult = await ref
        .read(authRepositoryProvider)
        .refreshToken(refreshToken);

    return refreshResult.fold(
      (failure) async {
        await authService.clearTokens();
        return AuthState(
          isAuthenticated: false,
          isTokenValid: false,
          isOfflineMode: false,
          errorMessage: failure.message,
        );
      },
      (tokens) async {
        return _authenticatedStateFromTokens(tokens);
      },
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
}
