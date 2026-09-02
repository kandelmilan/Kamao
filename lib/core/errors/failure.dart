/// Base class for all failures.
abstract class Failure {
  const Failure(this.message, [this.statusCode]);

  /// Error message to display or log.
  final String message;

  /// HTTP status code (if available).
  final int? statusCode;

  @override
  String toString() {
    return '$runtimeType(message: $message, statusCode: $statusCode)';
  }
}

/// Network connection failure.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.statusCode]);
}

/// Request timeout failure.
class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, [super.statusCode]);
}

/// Authentication or authorization failure.
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, [super.statusCode]);
}

/// Validation failure (400 Bad Request).
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.statusCode]);
}

/// Server failure (5xx, 404, etc.).
class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.statusCode]);
}

/// Unknown or unexpected failure.
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.statusCode]);
}
