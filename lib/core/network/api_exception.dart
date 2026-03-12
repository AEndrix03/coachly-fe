/// Eccezioni personalizzate per API calls
/// Simile agli interceptor error handlers di Angular
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException({String message = 'Network error occurred'})
    : super(message: message);
}

class ServerException extends ApiException {
  ServerException({String message = 'Server error occurred', int? statusCode})
    : super(message: message, statusCode: statusCode);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String message = 'Unauthorized'})
    : super(message: message, statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException({String message = 'Resource not found'})
    : super(message: message, statusCode: 404);
}

class ValidationException extends ApiException {
  ValidationException({String message = 'Validation error', dynamic data})
    : super(message: message, statusCode: 422, data: data);
}
