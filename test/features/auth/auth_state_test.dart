import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/models/auth_state/auth_state.dart';
import 'package:coachly/features/auth/application/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthState.status', () {
    test('espone idle nello stato iniziale', () {
      const state = AuthState(isAuthenticated: false, isTokenValid: false);

      expect(state.status, AuthStatus.idle);
    });

    test('espone loading durante il flusso di accesso', () {
      const state = AuthState(isLoading: true);

      expect(state.status, AuthStatus.loading);
    });

    test('espone authenticated quando la sessione puo accedere alla app', () {
      const state = AuthState(
        isAuthenticated: true,
        isTokenValid: true,
        tokens: LoginResponseDto(
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      );

      expect(state.status, AuthStatus.authenticated);
    });

    test('espone failed senza propagare il dettaglio alla presentazione', () {
      const state = AuthState(
        isAuthenticated: false,
        isTokenValid: false,
        errorMessage: 'diagnostica interna',
      );

      expect(state.status, AuthStatus.failed);
    });
  });
}
