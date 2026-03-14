import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';

abstract class AuthService {
  Future<LoginResponseDto> login();

  Future<LoginResponseDto> refreshToken(String refreshToken);

  Future<void> saveTokens(
    String accessToken,
    String refreshToken, {
    String? idToken,
  });

  Future<void> clearTokens();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<String?> getIdToken();

  Future<void> endSession();
}
