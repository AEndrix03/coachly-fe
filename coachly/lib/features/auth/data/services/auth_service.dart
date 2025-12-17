import '../dto/login_request_dto.dart';
import '../models/login_response.dart';

abstract class AuthService {
  Future<LoginResponse> login(LoginRequestDto loginRequest);
}
