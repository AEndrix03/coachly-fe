import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(true) bool isTokenValid,
    @Default(false) bool isOfflineMode,

    /// Chi ha scelto di continuare senza rete e senza account.
    ///
    /// Non e' una sessione: non ci sono token, quindi nessuna chiamata
    /// autenticata puo' riuscire. Serve solo a lavorare sul database locale
    /// finche' non si accede davvero.
    @Default(false) bool isOfflineGuest,
    @Default(false) bool isLoading,
    LoginResponseDto? tokens,
    String? errorMessage,
  }) = _AuthState;

  const AuthState._();

  bool get canAccessApp =>
      isOfflineGuest || (isAuthenticated && (isTokenValid || isOfflineMode));

  bool get needsReLogin => isAuthenticated && !isTokenValid && !isOfflineMode;

  bool get isOnlineAuthenticated =>
      isAuthenticated && isTokenValid && !isOfflineMode;
}
