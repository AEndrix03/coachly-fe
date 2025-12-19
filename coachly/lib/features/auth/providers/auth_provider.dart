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
    print('Auth.build() called.');
    // Register the observer for app lifecycle events
    WidgetsBinding.instance.addObserver(this);
    // Clean up when the provider is disposed
    ref.onDispose(() {
      print('Auth.onDispose() called.');
      WidgetsBinding.instance.removeObserver(this);
      _stopRefreshTimer();
    });

    // Listen for connectivity changes to retry auth check if needed
    ref.listen(connectivityProvider, (previous, next) {
      print('Connectivity changed: $previous -> $next');
      // Use valueOrNull for safer access
      final isConnected = next.value != ConnectivityResult.none;
      if (isConnected && _networkErrorOccurred) {
        print(
            'Connection restored and network error occurred, retrying checkAuthStatus.');
        _networkErrorOccurred = false; // Reset flag before retrying
        checkAuthStatus();
      }
    });

    // Immediately check auth status when the provider is first created
    await checkAuthStatus();
    print('Auth.build() initial state value: ${state.value?.accessToken}');
    return state.value;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('AppLifecycleState changed: $state');
    // When the app is resumed, check the auth status if the user is logged in
    if (state == AppLifecycleState.resumed && this.state.value != null) {
      print('App resumed and user logged in, calling checkAuthStatus.');
      checkAuthStatus();
    }
  }

  void _startRefreshTimer() {
    _stopRefreshTimer(); // Ensure no multiple timers are running
    _refreshTimer = Timer.periodic(const Duration(hours: 6), (timer) {
      print('6-hour refresh timer triggered.');
      // Only refresh if there is a user session
      if (state.value != null) {
        checkAuthStatus();
      }
    });
    print('Refresh timer started for 6 hours.');
  }

  void _stopRefreshTimer() {
    print('Stopping refresh timer.');
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> login(String email, String password) async {
    print('Auth.login() called for email: $email');
    state = const AsyncLoading();
    final service = ref.read(authServiceProvider);
    final loginRequest = LoginRequestDto(email: email, password: password);

    try {
      final loginResponse = await service.login(loginRequest);
      print('Login successful. AccessToken: ${loginResponse.accessToken}');
      print('RefreshToken: ${loginResponse.refreshToken}');
      // On success, save tokens and update state
      await service.saveTokens(
        loginResponse.accessToken,
        loginResponse.refreshToken,
      );
      _networkErrorOccurred = false; // Reset flag on successful login
      state = AsyncData(loginResponse);
      _startRefreshTimer(); // Start the periodic refresh on successful login
      print('Auth.login() state updated. New state value: ${state.value?.accessToken}');
    } catch (e, st) {
      print('Auth.login() failed. Error: $e, Stack: $st');
      if (e is NetworkFailure) {
        _networkErrorOccurred = true;
      }
      state = AsyncError(e, st);
      print('Auth.login() state updated to AsyncError.');
    }
  }

  Future<void> logout() async {
    print('Auth.logout() called.');
    final service = ref.read(authServiceProvider);
    await service.clearTokens();
    _stopRefreshTimer(); // Stop the timer on logout
    state = const AsyncData(null);
    print('Auth.logout() state updated to AsyncData(null).');
  }

  Future<void> checkAuthStatus() async {
    print('Auth.checkAuthStatus() called.');
    final service = ref.read(authServiceProvider);
    final accessToken = await service.getAccessToken();
    final refreshToken = await service.getRefreshToken();
    print(
        'checkAuthStatus - Retrieved tokens. AccessToken: $accessToken, RefreshToken: $refreshToken');

    if (accessToken != null && refreshToken != null) {
      try {
        // Attempt to refresh the token to validate the session
        final loginResponse = await service.refreshToken(refreshToken);
        print(
            'checkAuthStatus - Refresh successful. New AccessToken: ${loginResponse.accessToken}');
        print(
            'checkAuthStatus - New RefreshToken: ${loginResponse.refreshToken}');
        await service.saveTokens(
          loginResponse.accessToken,
          loginResponse.refreshToken,
        );
        if (!ref.mounted) {
          print('checkAuthStatus - Provider not mounted, returning.');
          return;
        }
        _networkErrorOccurred = false; // Reset flag on success
        state = AsyncData(loginResponse);
        _startRefreshTimer(); // Restart timer on successful refresh
        print(
            'checkAuthStatus - State updated to AsyncData. New state value: ${state.value?.accessToken}');
      } catch (e, st) {
        print('checkAuthStatus - Refresh failed. Error: $e, Stack: $st');
        if (e is NetworkFailure) {
          _networkErrorOccurred = true;
          // If network failure, optimistically set state to "logged in" with existing tokens
          // This allows the user to enter the app even without connection if tokens exist.
          state = AsyncData(LoginResponseDto.fromTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          ));
          print(
              'checkAuthStatus - NetworkFailure. Optimistically setting state. New state value: ${state.value?.accessToken}');
        } else {
          // For any other error (e.g., invalid refresh token), log out.
          print(
              'checkAuthStatus - Non-network failure. Clearing tokens and logging out.');
          await service.clearTokens();
          if (!ref.mounted) {
            print('checkAuthStatus - Provider not mounted, returning.');
            return;
          }
          state = const AsyncData(null);
          print('checkAuthStatus - State updated to AsyncData(null).');
        }
      }
    } else {
      print('checkAuthStatus - No tokens found, setting state to AsyncData(null).');
      if (!ref.mounted) {
        print('checkAuthStatus - Provider not mounted, returning.');
        return;
      }
      state = const AsyncData(null);
      print('checkAuthStatus - State updated to AsyncData(null).');
    }
  }
}
