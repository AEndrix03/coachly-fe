import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/result/result.dart';

/// Adattatore fra il trasporto (`ApiResponse`) e il tipo di ritorno del data
/// layer (`Result<T, Failure>`).
///
/// Vive nel data layer per costruzione: sopra il repository non esistono
/// `ApiResponse` né `statusCode` (`docs/development/01-principles.md`, § 4).
/// La firma di `ApiClient` non cambia: la conversione avviene qui.
extension ApiResponseResultX<T> on ApiResponse<T> {
  /// Converte una risposta fallita nel `Failure` corrispondente.
  ///
  /// Il `message` che ne risulta è **diagnostico**, non testo per l'utente
  /// (`docs/development/07-errors-and-feedback.md`).
  Failure toFailure() =>
      failureFromStatusCode(statusCode, message: message, errors: errors);

  /// Converte la risposta in un [Result].
  ///
  /// Una risposta di successo senza corpo è un fallimento: il chiamante ha
  /// chiesto un `T` e non lo ha ottenuto. Per gli endpoint che non ritornano
  /// nulla usa [toVoidResult].
  Result<T, Failure> toResult() {
    if (!success) return Err(toFailure());

    final payload = data;
    if (payload == null) {
      return Err(
        ParsingFailure('Successful response without payload: $message'),
      );
    }
    return Ok(payload);
  }

  /// Converte la risposta in un [Result] che ignora il corpo.
  ///
  /// Per gli endpoint senza payload (`DELETE`, comandi).
  Result<void, Failure> toVoidResult() =>
      success ? const Ok<void, Failure>(null) : Err(toFailure());
}

/// Mappa uno status code HTTP sulla tassonomia dei `Failure`.
///
/// `null` e `0` indicano che la richiesta non è mai arrivata a destinazione:
/// è un problema di rete, non di semantica.
Failure failureFromStatusCode(
  int? statusCode, {
  String? message,
  Map<String, dynamic>? errors,
}) {
  final diagnostic = (message == null || message.isEmpty) ? null : message;

  if (statusCode == null || statusCode == 0) {
    return diagnostic == null
        ? const NetworkFailure()
        : NetworkFailure(diagnostic);
  }

  return switch (statusCode) {
    408 || 504 =>
      diagnostic == null ? const TimeoutFailure() : TimeoutFailure(diagnostic),
    401 =>
      diagnostic == null
          ? const UnauthorizedFailure()
          : UnauthorizedFailure(diagnostic),
    403 =>
      diagnostic == null
          ? const ForbiddenFailure()
          : ForbiddenFailure(diagnostic),
    404 =>
      diagnostic == null
          ? const NotFoundFailure()
          : NotFoundFailure(diagnostic),
    409 =>
      diagnostic == null
          ? const ConflictFailure()
          : ConflictFailure(diagnostic),
    422 =>
      diagnostic == null
          ? ValidationFailure(_fieldErrors(errors))
          : ValidationFailure(_fieldErrors(errors), diagnostic),
    >= 500 && < 600 => ServerFailure(
      diagnostic ?? 'Server error occurred',
      statusCode,
    ),
    _ =>
      diagnostic == null
          ? const UnexpectedFailure()
          : UnexpectedFailure(diagnostic),
  };
}

Map<String, String> _fieldErrors(Map<String, dynamic>? errors) {
  if (errors == null || errors.isEmpty) return const {};
  return {
    for (final entry in errors.entries) entry.key: entry.value.toString(),
  };
}

/// Ponte inverso: `Result` → `ApiResponse`.
///
/// Serve **solo** ai metodi di compatibilità dei repository già migrati, per
/// non rompere i chiamanti non ancora convertiti. Non usarlo in codice nuovo.
extension ResultApiResponseX<T extends Object> on Result<T, Failure> {
  ApiResponse<T> toApiResponse() => fold(
    (value) => ApiResponse<T>.success(data: value),
    (failure) => ApiResponse<T>.error(
      message: failure.message,
      statusCode: failure.code,
      errors: failure is ValidationFailure ? failure.errors : null,
    ),
  );
}

/// Variante di [ResultApiResponseX.toApiResponse] per i risultati senza corpo.
ApiResponse<void> voidResultToApiResponse(Result<void, Failure> result) =>
    result.fold(
      (_) => ApiResponse<void>.success(),
      (failure) => ApiResponse<void>.error(
        message: failure.message,
        statusCode: failure.code,
        errors: failure is ValidationFailure ? failure.errors : null,
      ),
    );
