import 'dart:async';

import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/connectivity_provider.dart';
import 'package:coachly/features/auth/data/dto/login_request_dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/auth_service_impl.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

// 0. Provider for TokenManager
@riverpod
TokenManager tokenManager(Ref ref) {
  return TokenManager();
}

// 1. Provider for the AuthService
@riverpod
AuthService authService(Ref ref) {
  // The dependency on AuthHttpClient is now resolved lazily within AuthServiceImpl
  // by passing the ref directly. This breaks the circular dependency.
  return AuthServiceImpl(ref, ref.watch(tokenManagerProvider));
}

// 2. Provider for the AuthRepository
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
}

// 3. The main Auth Notifier Provider
@riverpod
class Auth extends _$Auth with WidgetsBindingObserver {
  Timer? _refreshTimer;
  bool _networkErrorOccurred = false;

  @override
  Future<LoginResponseDto?> build() async {
    // Register the observer for app lifecycle events
    WidgetsBinding.instance.addObserver(this);
    // Clean up when the provider is disposed
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _stopRefreshTimer();
    });

    // Listen for connectivity changes to retry auth check if needed
    ref.listen(connectivityProvider, (previous, next) {
      // Use valueOrNull for safer access
      final isConnected = next.value != ConnectivityResult.none;
      if (isConnected && _networkErrorOccurred) {
        _networkErrorOccurred = false; // Reset flag before retrying
        checkAuthStatus();
      }
    });

    // Immediately check auth status when the provider is first created
    await checkAuthStatus();
    return state.value;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When the app is resumed, check the auth status if the user is logged in
    if (state == AppLifecycleState.resumed && this.state.value != null) {
      checkAuthStatus();
    }
  }

  void _startRefreshTimer() {
    _stopRefreshTimer(); // Ensure no multiple timers are running
    _refreshTimer = Timer.periodic(const Duration(hours: 6), (timer) {
      // Only refresh if there is a user session
      if (state.value != null) {
        checkAuthStatus();
      }
    });
  }

  void _stopRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final service = ref.read(authServiceProvider);
    final loginRequest = LoginRequestDto(email: email, password: password);

    try {
      final loginResponse = await service.login(loginRequest);
      // On success, save tokens and update state
      await service.saveTokens(
        loginResponse.accessToken,
        loginResponse.refreshToken,
      );
      _networkErrorOccurred = false; // Reset flag on successful login
      state = AsyncData(loginResponse);
      _startRefreshTimer(); // Start the periodic refresh on successful login
    } catch (e, st) {
      if (e is NetworkFailure) {
        _networkErrorOccurred = true;
      }
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    final service = ref.read(authServiceProvider);
    await service.clearTokens();
    _stopRefreshTimer(); // Stop the timer on logout
    state = const AsyncData(null);
  }

  Future<void> checkAuthStatus() async {
    final service = ref.read(authServiceProvider);
    final accessToken = await service.getAccessToken();
    final refreshToken = await service.getRefreshToken();

    if (accessToken != null && refreshToken != null) {
      try {
        // Attempt to refresh the token to validate the session
        final loginResponse = await service.refreshToken(refreshToken);
        await service.saveTokens(
          loginResponse.accessToken,
          loginResponse.refreshToken,
        );
        if (!ref.mounted) return;
        _networkErrorOccurred = false; // Reset flag on success
        state = AsyncData(loginResponse);
        _startRefreshTimer(); // Restart timer on successful refresh
      } catch (e, st) {
        // If refresh fails due to a network error, set a flag and do nothing.
        // The logic to retry on connection restoration will handle it.
        if (e is NetworkFailure) {
          _networkErrorOccurred = true;
        } else {
          // For any other error (e.g., invalid refresh token), log out.
          await service.clearTokens();
          if (!ref.mounted) return;
          state = const AsyncData(null);
        }
      }
    } else {
      if (!ref.mounted) return;
      state = const AsyncData(null);
    }
  }
}
