import 'dart:async';

import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/connectivity_provider.dart';
import 'package:coachly/core/network/interceptors/auth_interceptor_client.dart';
import 'package:coachly/features/auth/data/dto/login_request_dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/models/auth_state/auth_state.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/auth_service_impl.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';
import 'package:coachly/features/auth/data/utils/jwt_validator.dart';
import 'package:coachly/features/auth/data/utils/sync_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
TokenManager tokenManager(Ref ref) => TokenManager();

@riverpod
SyncManager syncManager(Ref ref) => SyncManager();

@riverpod
AuthService authService(Ref ref) {
  final tokenManager = ref.watch(tokenManagerProvider);
  return AuthServiceImpl(() => ref.read(authHttpClientProvider), tokenManager);
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
}

@riverpod
class Auth extends _$Auth with WidgetsBindingObserver {
  Timer? _refreshTimer;

  @override
  Future<AuthState> build() async {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _stopRefreshTimer();
    });

    ref.listen(connectivityProvider, (previous, next) {
      final results = next.value ?? [];
      final isConnected =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
      if (isConnected && state.value?.isOfflineMode == true) {
        _syncAndRevalidate();
      }
    });

    return await _checkAuthStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    super.didChangeAppLifecycleState(lifecycleState);
    print('🔄 App lifecycle: $lifecycleState');

    if (lifecycleState == AppLifecycleState.resumed &&
        state.value?.isAuthenticated == true) {
      print('📱 App resumed - checking auth and refreshing if needed...');
      _checkAndRefreshOnResume();
    }
  }

  /// Check auth status and proactively refresh if token is expiring soon
  Future<void> _checkAndRefreshOnResume() async {
    final service = ref.read(authServiceProvider);
    final accessToken = await service.getAccessToken();
    final refreshToken = await service.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      state = AsyncValue.data(const AuthState(isAuthenticated: false));
      return;
    }

    final remainingTime = JwtValidator.getTokenRemainingTime(accessToken);
    final connectivityResults = ref.read(connectivityProvider).value ?? [];
    final hasInternet =
        connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);

    print('⏱️  Token remaining time: ${remainingTime?.inMinutes ?? 0} minutes');
    print('🌐 Has internet: $hasInternet');

    // If token expires in less than 10 minutes and we have internet, refresh proactively
    if (hasInternet && remainingTime != null && remainingTime.inMinutes < 10) {
      print('🔄 Token expiring soon - refreshing proactively...');
      final isRefreshValid = JwtValidator.isTokenValid(refreshToken);

      if (isRefreshValid) {
        try {
          final newTokens = await service.refreshToken(refreshToken);
          await service.saveTokens(
            newTokens.accessToken,
            newTokens.refreshToken,
          );
          _scheduleSmartRefresh(newTokens.accessToken);

          state = AsyncValue.data(
            AuthState(
              isAuthenticated: true,
              isTokenValid: true,
              isOfflineMode: false,
              tokens: newTokens,
            ),
          );
          print('✅ Token refreshed successfully on resume');
          return;
        } catch (e) {
          print('❌ Failed to refresh on resume: $e');
          // Fall through to normal check
        }
      }
    }

    // Otherwise just do normal check
    state = AsyncValue.data(await _checkAuthStatus());
  }

  Future<AuthState> _checkAuthStatus() async {
    print('🔍 Checking auth status...');
    final service = ref.read(authServiceProvider);
    final accessToken = await service.getAccessToken();
    final refreshToken = await service.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      print('❌ No tokens found');
      return const AuthState(isAuthenticated: false);
    }

    print('🔑 Tokens found - validating...');
    final isAccessValid = JwtValidator.isTokenValid(accessToken);
    final isRefreshValid = JwtValidator.isTokenValid(refreshToken);
    final connectivityResults = ref.read(connectivityProvider).value ?? [];
    final hasInternet =
        connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);

    print(
      '✓ Access valid: $isAccessValid, Refresh valid: $isRefreshValid, Internet: $hasInternet',
    );

    if (isAccessValid) {
      print('✅ Access token valid - scheduling refresh');
      _scheduleSmartRefresh(accessToken);
      return AuthState(
        isAuthenticated: true,
        isTokenValid: true,
        isOfflineMode: false,
        tokens: LoginResponseDto(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      );
    }

    if (!isAccessValid && !isRefreshValid) {
      if (hasInternet) {
        await service.clearTokens();
        return const AuthState(
          isAuthenticated: false,
          errorMessage: 'Sessione scaduta. Effettua nuovamente il login.',
        );
      } else {
        return AuthState(
          isAuthenticated: true,
          isTokenValid: false,
          isOfflineMode: true,
          tokens: LoginResponseDto(
            accessToken: accessToken,
            refreshToken: refreshToken,
          ),
          errorMessage: 'Modalità offline. Token scaduto.',
        );
      }
    }

    if (hasInternet && isRefreshValid) {
      try {
        print('🔄 Attempting to refresh token...');
        final newTokens = await service.refreshToken(refreshToken);
        await service.saveTokens(newTokens.accessToken, newTokens.refreshToken);
        _scheduleSmartRefresh(newTokens.accessToken);
        print('✅ Token refreshed successfully');
        return AuthState(
          isAuthenticated: true,
          isTokenValid: true,
          isOfflineMode: false,
          tokens: newTokens,
        );
      } catch (e) {
        if (e is NetworkFailure) {
          return AuthState(
            isAuthenticated: true,
            isTokenValid: false,
            isOfflineMode: true,
            tokens: LoginResponseDto(
              accessToken: accessToken,
              refreshToken: refreshToken,
            ),
          );
        }
        await service.clearTokens();
        return AuthState(
          isAuthenticated: false,
          errorMessage: e is Failure ? e.message : 'Errore durante il refresh.',
        );
      }
    }

    return AuthState(
      isAuthenticated: true,
      isTokenValid: false,
      isOfflineMode: true,
      tokens: LoginResponseDto(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  void _scheduleSmartRefresh(String accessToken) {
    _stopRefreshTimer();
    final remaining = JwtValidator.getTokenRemainingTime(accessToken);
    if (remaining == null) {
      print('⚠️  Cannot schedule refresh - token has no expiration');
      return;
    }

    print('⏱️  Token expires in ${remaining.inMinutes} minutes');
    final refreshAt = remaining - const Duration(minutes: 5);
    if (refreshAt.isNegative) {
      print('⚠️  Token already expiring - checking immediately');
      _checkAuthStatus();
      return;
    }

    print('⏰ Scheduling refresh in ${refreshAt.inMinutes} minutes');
    _refreshTimer = Timer(refreshAt, () {
      print('⏰ Timer triggered - refreshing token...');
      _checkAuthStatus();
    });
  }

  void _stopRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> login(String email, String password) async {
    state = AsyncData(
      state.value?.copyWith(isLoading: true) ??
          const AuthState(isLoading: true),
    );

    final service = ref.read(authServiceProvider);
    final loginRequest = LoginRequestDto(email: email, password: password);

    try {
      final loginResponse = await service.login(loginRequest);
      await service.saveTokens(
        loginResponse.accessToken,
        loginResponse.refreshToken,
      );

      _scheduleSmartRefresh(loginResponse.accessToken);

      state = AsyncData(
        AuthState(
          isAuthenticated: true,
          isTokenValid: true,
          isOfflineMode: false,
          tokens: loginResponse,
        ),
      );
    } catch (e, st) {
      final errorMsg = e is Failure ? e.message : 'Errore durante il login.';
      state = AsyncData(
        AuthState(isAuthenticated: false, errorMessage: errorMsg),
      );
    }
  }

  Future<void> logout() async {
    final service = ref.read(authServiceProvider);
    await service.clearTokens();
    _stopRefreshTimer();
    state = const AsyncData(AuthState(isAuthenticated: false));
  }

  Future<void> _syncAndRevalidate() async {
    final syncManager = ref.read(syncManagerProvider);
    final hasPending = await syncManager.hasPendingOperations();

    if (hasPending) {
      // TODO: Implementare logica di sync batch
    }

    await _checkAuthStatus();
  }

  Future<void> forceReLogin() async {
    final service = ref.read(authServiceProvider);
    await service.clearTokens();
    state = const AsyncData(
      AuthState(
        isAuthenticated: false,
        errorMessage: 'Sessione scaduta. Effettua nuovamente il login.',
      ),
    );
  }
}
