import 'package:coachly/core/error/either.dart';
import 'package:coachly/core/error/failures.dart';
import 'package:coachly/features/auth/data/dto/login_request_dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseDto>> login(LoginRequestDto loginRequest);

  Future<Either<Failure, LoginResponseDto>> refreshToken(String refreshToken);
}
