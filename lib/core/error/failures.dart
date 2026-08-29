/// Tassonomia dei fallimenti.
///
/// Vedi `docs/development/07-errors-and-feedback.md`. Nessuna eccezione tecnica
/// deve attraversare il confine del data layer: si converte qui, dove ci sono
/// le informazioni per farlo.
///
/// Un `Failure` **non contiene testo per l'utente**: `message` è diagnostico.
/// Il messaggio mostrato si costruisce nella presentazione, tradotto
/// (`docs/development/13-i18n.md`).
sealed class Failure implements Exception {
  final String message;
  final int? code;
  final Object? originalError;

  const Failure(this.message, {this.code, this.originalError});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          other.runtimeType == runtimeType &&
          other.message == message &&
          other.code == code;

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  @override
  String toString() => '$runtimeType($message${code == null ? '' : ', $code'})';
}

// ── Rete e trasporto ────────────────────────────────────────────────────────

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed'])
    : super(code: 1001);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']) : super(code: 1002);
}

final class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Server error occurred',
    int? statusCode,
  ]) : super(code: statusCode ?? 5000);
}

/// Richiesta annullata perché chi l'aveva chiesta non esiste più.
///
/// **Non è un errore**: non si mostra all'utente e non si riporta al crash
/// reporter.
final class CancelledFailure extends Failure {
  const CancelledFailure([super.message = 'Request cancelled'])
    : super(code: 1003);
}

// ── Semantica ───────────────────────────────────────────────────────────────

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access'])
    : super(code: 401);
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'Access forbidden'])
    : super(code: 403);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found'])
    : super(code: 404);
}

final class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'Resource conflict'])
    : super(code: 409);
}

final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([super.message = 'Invalid credentials'])
    : super(code: 401);
}

final class ValidationFailure extends Failure {
  final Map<String, String> errors;

  const ValidationFailure(this.errors, [String message = 'Validation failed'])
    : super(message, code: 422);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationFailure &&
          other.message == message &&
          _mapEquals(other.errors, errors);

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    Object.hashAllUnordered(
      errors.entries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
  );

  static bool _mapEquals(Map<String, String> a, Map<String, String> b) =>
      identical(a, b) ||
      a.length == b.length &&
          a.entries.every((entry) => b[entry.key] == entry.value);
}

// ── Locale ──────────────────────────────────────────────────────────────────

final class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Storage operation failed'])
    : super(code: 2002);
}

final class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Failed to parse data'])
    : super(code: 2003);
}

/// L'operazione richiede la rete e la rete non c'è.
///
/// Distinto da [NetworkFailure]: qui il fallimento è previsto e la UI può
/// spiegarlo, invece di presentarlo come un errore.
final class NotAvailableOfflineFailure extends Failure {
  const NotAvailableOfflineFailure([super.message = 'Requires connectivity'])
    : super(code: 2004);
}

// ── Residuo ─────────────────────────────────────────────────────────────────

/// L'unico fallimento che si riporta al crash reporter.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'An unexpected error occurred',
    Object? originalError,
  ]) : super(code: 9999, originalError: originalError);
}

/// Converte un'eccezione tecnica in un [Failure].
///
/// Da usare **solo** al confine del data layer.
Failure exceptionToFailure(Object exception) {
  if (exception is Failure) return exception;

  final description = exception.toString();

  if (description.contains('SocketException') ||
      description.contains('NetworkException')) {
    return const NetworkFailure();
  }
  if (description.contains('TimeoutException')) {
    return const TimeoutFailure();
  }
  if (description.contains('FormatException')) {
    return const ParsingFailure();
  }

  return UnexpectedFailure(description, exception);
}
