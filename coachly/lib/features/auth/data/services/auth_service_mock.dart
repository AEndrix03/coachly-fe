import 'package:coachly/features/auth/data/dto/login_request_dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';

class AuthServiceMock implements AuthService {
  // Mock storage for tokens
  String? _mockAccessToken;
  String? _mockRefreshToken;

  @override
  Future<LoginResponseDto> login(LoginRequestDto loginRequest) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock a successful login
    if (loginRequest.email.isNotEmpty && loginRequest.password.isNotEmpty) {
      _mockAccessToken = 'mock_access_token_jwt_string';
      _mockRefreshToken = 'mock_refresh_token_jwt_string';
      return const LoginResponseDto(
        accessToken: 'mock_access_token_jwt_string', // Mocked encrypted key
        refreshToken: 'mock_refresh_token_jwt_string',
        firstName: 'Mario',
        lastName: 'Rossi',
      );
    } else {
      // Simulate an error
      throw Exception('Invalid email or password');
    }
  }

  @override
  Future<LoginResponseDto> refreshToken(String refreshToken) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));

    if (refreshToken == _mockRefreshToken) {
      // Return new tokens
      _mockAccessToken = 'new_mock_access_token_jwt_string';
      _mockRefreshToken = 'new_mock_refresh_token_jwt_string';
      return const LoginResponseDto(
        accessToken: 'new_mock_access_token_jwt_string',
        refreshToken: 'new_mock_refresh_token_jwt_string',
        firstName: 'Mario',
        lastName: 'Rossi',
      );
    } else {
      throw Exception('Invalid refresh token');
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    _mockAccessToken = accessToken;
    _mockRefreshToken = refreshToken;
    print('Mock: Saving tokens: $accessToken, $refreshToken');
  }

  @override
  Future<void> clearTokens() async {
    _mockAccessToken = null;
    _mockRefreshToken = null;
    print('Mock: Clearing tokens');
  }

  @override
  Future<String?> getAccessToken() async {
    return _mockAccessToken;
  }

  @override
  Future<String?> getRefreshToken() async {
    return _mockRefreshToken;
  }
}
