import 'package:coachly/features/auth/data/dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/models/login_response.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/auth_service_mock.dart';
import 'package:coachly/features/auth/providers/session_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

// 1. Provider for the AuthService (using the mock implementation)
@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthServiceMock();
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
  Future<LoginResponse?> build() async {
    // Initial state is null, no user logged in
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final loginRequest = LoginRequestDto(email: email, password: password);

    final result = await repo.login(loginRequest);

    state = await result.fold(
      (failure) async {
        return AsyncError(failure, StackTrace.current);
      },
      (loginResponse) async {
        // On success, save tokens to secure storage
        await ref
            .read(sessionNotifierProvider.notifier)
            .saveTokens(loginResponse.accessToken, loginResponse.refreshToken);
        return AsyncData(loginResponse);
      },
    );
  }

  Future<void> logout() async {
    await ref.read(sessionNotifierProvider.notifier).clearTokens();
    state = const AsyncData(null);
  }
}
