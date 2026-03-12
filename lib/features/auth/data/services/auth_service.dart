import 'package:coachly/features/auth/data/dto/login_request_dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';

abstract class AuthService {
  Future<LoginResponseDto> login(LoginRequestDto loginRequest);

  Future<LoginResponseDto> refreshToken(String refreshToken);

  Future<void> saveTokens(String accessToken, String refreshToken);

  Future<void> clearTokens();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();
}
