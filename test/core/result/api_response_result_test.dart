import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/core/result/api_response_result.dart';
import 'package:coachly/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('failureFromStatusCode', () {
    test('assenza di status code significa problema di rete', () {
      expect(failureFromStatusCode(null), isA<NetworkFailure>());
      expect(failureFromStatusCode(0), isA<NetworkFailure>());
    });

    test('mappa gli status code sulla tassonomia', () {
      expect(failureFromStatusCode(401), isA<UnauthorizedFailure>());
      expect(failureFromStatusCode(403), isA<ForbiddenFailure>());
      expect(failureFromStatusCode(404), isA<NotFoundFailure>());
      expect(failureFromStatusCode(408), isA<TimeoutFailure>());
      expect(failureFromStatusCode(409), isA<ConflictFailure>());
      expect(failureFromStatusCode(422), isA<ValidationFailure>());
      expect(failureFromStatusCode(500), isA<ServerFailure>());
      expect(failureFromStatusCode(503), isA<ServerFailure>());
      expect(failureFromStatusCode(504), isA<TimeoutFailure>());
      expect(failureFromStatusCode(418), isA<UnexpectedFailure>());
    });

    test('422 porta con se i campi non validi', () {
      final failure =
          failureFromStatusCode(422, errors: {'nameI18n': 'required'})
              as ValidationFailure;

      expect(failure.errors, {'nameI18n': 'required'});
    });

    test('il messaggio resta diagnostico', () {
      final failure = failureFromStatusCode(500, message: 'upstream exploded');

      expect(failure.message, 'upstream exploded');
      expect(failure.code, 500);
    });
  });

  group('ApiResponse.toResult', () {
    test('successo con dati produce Ok', () {
      final result = ApiResponse<int>.success(data: 1).toResult();

      expect(result, isA<Ok<int, Failure>>());
      expect(result.valueOrNull, 1);
    });

    test('successo senza corpo e un fallimento di parsing', () {
      final result = ApiResponse<int>.success().toResult();

      expect(result.failureOrNull, isA<ParsingFailure>());
    });

    test('errore produce Err tipizzato', () {
      final result = ApiResponse<int>.error(
        message: 'nope',
        statusCode: 404,
      ).toResult();

      expect(result.failureOrNull, isA<NotFoundFailure>());
    });
  });

  group('ApiResponse.toVoidResult', () {
    test('successo senza corpo e valido', () {
      expect(ApiResponse<void>.success().toVoidResult().isOk, isTrue);
    });

    test('errore resta un fallimento', () {
      final result = ApiResponse<void>.error(
        message: 'nope',
        statusCode: 401,
      ).toVoidResult();

      expect(result.failureOrNull, isA<UnauthorizedFailure>());
    });
  });

  group('ponte inverso Result -> ApiResponse', () {
    test('Ok diventa una risposta di successo', () {
      const Result<int, Failure> result = Ok(3);
      final response = result.toApiResponse();

      expect(response.success, isTrue);
      expect(response.data, 3);
    });

    test('Err riporta messaggio e status code', () {
      const Result<int, Failure> result = Err(NotFoundFailure());
      final response = result.toApiResponse();

      expect(response.success, isFalse);
      expect(response.statusCode, 404);
      expect(response.message, isNotEmpty);
    });

    test('Err di validazione riporta i campi', () {
      const Result<int, Failure> result = Err(
        ValidationFailure({'nameI18n': 'required'}),
      );

      expect(result.toApiResponse().errors, {'nameI18n': 'required'});
    });

    test('il ponte void non perde il fallimento', () {
      final response = voidResultToApiResponse(
        const Err<void, Failure>(ServerFailure()),
      );

      expect(response.success, isFalse);
    });
  });
}
