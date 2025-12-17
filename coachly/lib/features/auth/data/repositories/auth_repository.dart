import 'package:coachly/core/error/either.dart';
import 'package:coachly/core/error/failures.dart';
import 'package:coachly/features/auth/data/dto/login_request_dto.dart';
import 'package:coachly/features/auth/data/models/login_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginRequestDto loginRequest);
}
