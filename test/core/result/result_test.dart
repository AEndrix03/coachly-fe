import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Ok esposto correttamente dai getter', () {
      const Result<int, Failure> result = Ok(42);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, 42);
      expect(result.failureOrNull, isNull);
    });

    test('Err esposto correttamente dai getter', () {
      const failure = NotFoundFailure();
      const Result<int, Failure> result = Err(failure);

      expect(result.isOk, isFalse);
      expect(result.valueOrNull, isNull);
      expect(result.failureOrNull, failure);
    });

    test('map trasforma solo il ramo di successo', () {
      const Result<int, Failure> ok = Ok(2);
      const Result<int, Failure> err = Err(ServerFailure());

      expect(ok.map((value) => value * 2).valueOrNull, 4);
      expect(err.map((value) => value * 2).failureOrNull, isA<ServerFailure>());
    });

    test('mapErr trasforma solo il ramo di fallimento', () {
      const Result<int, Failure> ok = Ok(2);
      const Result<int, Failure> err = Err(ServerFailure());

      expect(ok.mapErr((_) => const NetworkFailure()).valueOrNull, 2);
      expect(
        err.mapErr((_) => const NetworkFailure()).failureOrNull,
        isA<NetworkFailure>(),
      );
    });

    test('fold riduce entrambi i rami', () {
      const Result<int, Failure> ok = Ok(7);
      const Result<int, Failure> err = Err(UnauthorizedFailure());

      expect(ok.fold((value) => 'ok:$value', (_) => 'err'), 'ok:7');
      expect(err.fold((value) => 'ok:$value', (_) => 'err'), 'err');
    });

    test('il pattern matching e esaustivo', () {
      String describe(Result<int, Failure> result) => switch (result) {
        Ok(:final value) => 'value $value',
        Err(:final failure) => 'failure ${failure.runtimeType}',
      };

      expect(describe(const Ok(1)), 'value 1');
      expect(describe(const Err(NetworkFailure())), 'failure NetworkFailure');
    });

    test('uguaglianza per valore', () {
      expect(const Ok<int, Failure>(1), const Ok<int, Failure>(1));
      expect(const Ok<int, Failure>(1), isNot(const Ok<int, Failure>(2)));
      expect(
        const Err<int, Failure>(NotFoundFailure()),
        const Err<int, Failure>(NotFoundFailure()),
      );
    });
  });
}
