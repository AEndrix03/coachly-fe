import 'package:coachly/core/network/interceptors/auth_interceptor_client.dart';
import 'package:coachly/features/auth/data/models/auth_state/auth_state.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';
import 'package:coachly/features/auth/data/services/auth_service_impl.dart';
import 'package:coachly/features/auth/data/services/token_manager.dart';
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
  return AuthServiceImpl(() => ref.read(authHttpClientProvider), tokenManager);
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
}

@riverpod
class Auth extends _$Auth {
  @override
  Future<AuthState> build() async {
    return const AuthState(
      isAuthenticated: true,
      isTokenValid: true,
      isOfflineMode: false,
    );
  }

  Future<void> login(String _email, String _password) async {
    state = const AsyncData(AuthState(isLoading: true));
    state = const AsyncData(
      AuthState(
        isAuthenticated: true,
        isTokenValid: true,
        isOfflineMode: false,
      ),
    );
  }

  Future<void> logout() async {
    state = const AsyncData(
      AuthState(
        isAuthenticated: true,
        isTokenValid: true,
        isOfflineMode: false,
      ),
    );
  }

  Future<void> forceReLogin() async {
    await logout();
  }
}
