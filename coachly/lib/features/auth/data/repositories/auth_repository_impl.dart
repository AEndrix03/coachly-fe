import 'package:coachly/core/error/either.dart';
import 'package:coachly/core/error/failures.dart';
import 'package:coachly/features/auth/data/dto/login_request_dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';
import 'package:coachly/features/auth/data/repositories/auth_repository.dart';
import 'package:coachly/features/auth/data/services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<Either<Failure, LoginResponseDto>> login(
    LoginRequestDto loginRequest,
  ) async {
    try {
      final loginResponse = await authService.login(loginRequest);
      return Right(loginResponse);
    } on Exception catch (e) {
      // In a real app, you would have more specific exception handling
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponseDto>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final loginResponse = await authService.refreshToken(refreshToken);
      return Right(loginResponse);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
