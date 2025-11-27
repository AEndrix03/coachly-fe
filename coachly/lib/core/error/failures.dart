import 'package:equatable/equatable.dart';

/// Base class per tutti i Failure types
/// Preferito rispetto alle Exception per type-safety e gestione esplicita degli errori
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final dynamic originalError;

  const Failure(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure([
    String message = 'Network connection failed',
  ]) : super(message, code: 1001);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([
    String message = 'Request timeout',
  ]) : super(message, code: 1002);
}

/// HTTP status code failures
class ServerFailure extends Failure {
  const ServerFailure([
    String message = 'Server error occurred',
    int? statusCode,
  ]) : super(message, code: statusCode ?? 5000);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    String message = 'Unauthorized access',
  ]) : super(message, code: 401);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([
    String message = 'Access forbidden',
  ]) : super(message, code: 403);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([
    String message = 'Resource not found',
  ]) : super(message, code: 404);
}

class ConflictFailure extends Failure {
  const ConflictFailure([
    String message = 'Resource conflict',
  ]) : super(message, code: 409);
}

/// Validation failures
class ValidationFailure extends Failure {
  final Map<String, String> errors;

  const ValidationFailure(
    this.errors, [
    String message = 'Validation failed',
  ]) : super(message, code: 422);

  @override
  List<Object?> get props => [message, code, errors];
}

/// Data failures
class CacheFailure extends Failure {
  const CacheFailure([
    String message = 'Cache operation failed',
  ]) : super(message, code: 2001);
}

class StorageFailure extends Failure {
  const StorageFailure([
    String message = 'Storage operation failed',
  ]) : super(message, code: 2002);
}

class ParsingFailure extends Failure {
  const ParsingFailure([
    String message = 'Failed to parse data',
  ]) : super(message, code: 2003);
}

/// Generic failures
class UnknownFailure extends Failure {
  const UnknownFailure([
    String message = 'An unknown error occurred',
  ]) : super(message, code: 9999);
}

/// Helper per convertire Exception in Failure
Failure exceptionToFailure(dynamic exception) {
  if (exception is Failure) return exception;
  
  final errorMessage = exception.toString();
  
  // Network exceptions
  if (errorMessage.contains('SocketException') ||
      errorMessage.contains('NetworkException')) {
    return const NetworkFailure();
  }
  
  if (errorMessage.contains('TimeoutException')) {
    return const TimeoutFailure();
  }
  
  // HTTP exceptions
  if (errorMessage.contains('401')) {
    return const UnauthorizedFailure();
  }
  
  if (errorMessage.contains('403')) {
    return const ForbiddenFailure();
  }
  
  if (errorMessage.contains('404')) {
    return const NotFoundFailure();
  }
  
  if (errorMessage.contains('5')) {
    return ServerFailure(errorMessage);
  }
  
  return UnknownFailure(errorMessage);
}
