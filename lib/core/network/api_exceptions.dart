/// Custom exception classes for API errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'No internet connection']);
}

class ServerException extends ApiException {
  const ServerException([super.message = 'Server error occurred'])
      : super(statusCode: 500);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message = 'Unauthorized access'])
      : super(statusCode: 401);
}

class NotFoundException extends ApiException {
  const NotFoundException([super.message = 'Resource not found'])
      : super(statusCode: 404);
}
