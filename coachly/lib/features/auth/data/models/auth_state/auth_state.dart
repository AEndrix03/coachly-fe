import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(true) bool isTokenValid,
    @Default(false) bool isOfflineMode,
    @Default(false) bool isLoading,
    LoginResponseDto? tokens,
    String? errorMessage,
  }) = _AuthState;

  const AuthState._();

  bool get canAccessApp => isAuthenticated;

  bool get needsReLogin => isAuthenticated && !isTokenValid && !isOfflineMode;

  bool get isOnlineAuthenticated =>
      isAuthenticated && isTokenValid && !isOfflineMode;
}
