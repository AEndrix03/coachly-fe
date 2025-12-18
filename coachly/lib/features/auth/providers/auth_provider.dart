import 'package:coachly/core/network/auth_interceptor_client.dart';
import 'package:coachly/features/auth/data/dto/login_request_dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/auth_service_impl.dart';
import 'package:coachly/features/auth/data/services/auth_service_mock.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart'; // Import TokenManager
import 'package:coachly/features/auth/providers/session_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

// 0. Provider for TokenManager
@riverpod
TokenManager tokenManager(TokenManagerRef ref) {
  return TokenManager();
}

// 1. Provider for the AuthService
@riverpod
AuthService authService(AuthServiceRef ref) {
  const useMock = true; // Set to false to use the real implementation

  if (useMock) {
    return AuthServiceMock();
  } else {
    // AuthServiceImpl now requires AuthHttpClient and TokenManager
    // AuthHttpClient itself needs an AuthService. This creates a circular dependency.
    // We need to break this by deferring the creation of AuthHttpClient to
    // when authHttpClientProvider is called, and inject authServiceProvider into it.
    // For now, let's pass a dummy AuthHttpClient, but this will be fixed in auth_interceptor_client.dart
    // The correct approach is usually to make AuthHttpClient take a getter for AuthService
    // or to use a separate provider for AuthHttpClient that already has AuthServiceProvider.
    // For now, I'll pass a placeholder client.
    return AuthServiceImpl(ref.watch(authHttpClientProvider), ref.watch(tokenManagerProvider));
  }
}

// 2. Provider for the AuthRepository
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
}

// 3. The main Auth Notifier Provider
@riverpod
class Auth extends _$Auth {
  @override
  Future<LoginResponseDto?> build() async {
    // Initial state is null, no user logged in
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final service = ref.read(authServiceProvider); // Use authService directly
    final loginRequest = LoginRequestDto(email: email, password: password);

    try {
      final loginResponse = await service.login(loginRequest);
      // On success, save tokens via AuthService
      await service.saveTokens(loginResponse.accessToken, loginResponse.refreshToken);
      state = AsyncData(loginResponse);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    final service = ref.read(authServiceProvider);
    await service.clearTokens();
    state = const AsyncData(null);
  }

  Future<void> checkAuthStatus() async {
    final service = ref.read(authServiceProvider);
    final accessToken = await service.getAccessToken();
    if (accessToken != null) {
      // Potentially validate token or fetch user details
      // For now, just assume authenticated if token exists
      state = AsyncData(LoginResponseDto(
        accessToken: accessToken,
        refreshToken: await service.getRefreshToken() ?? '',
        firstName: '', // Placeholder
        lastName: '', // Placeholder
      ));
    } else {
      state = const AsyncData(null);
    }
  }
}
