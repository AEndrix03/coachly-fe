import 'package:coachly/core/error/either.dart';
import 'package:coachly/core/error/failures.dart';
import 'package:coachly/features/auth/data/dto/login_response_dto/login_response_dto.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseDto>> login();

  Future<Either<Failure, LoginResponseDto>> refreshToken(String refreshToken);
}
