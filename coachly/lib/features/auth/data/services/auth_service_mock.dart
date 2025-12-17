import 'package:coachly/features/auth/data/dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/models/login_response.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';

class AuthServiceMock implements AuthService {
  @override
  Future<LoginResponse> login(LoginRequestDto loginRequest) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock a successful login
    if (loginRequest.email.isNotEmpty && loginRequest.password.isNotEmpty) {
      return const LoginResponse(
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
}
