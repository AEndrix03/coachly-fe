import 'failures.dart';

/// Type-safe Either type per gestione errori funzionale
/// Alternativa a dartz per evitare dipendenze extra
sealed class Either<L, R> {
  const Either();

  /// Crea Left (errore)
  const factory Either.left(L value) = Left<L, R>;

  /// Crea Right (successo)
  const factory Either.right(R value) = Right<L, R>;

  /// Pattern matching
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);

  /// Check se è Right (successo)
  bool get isRight => this is Right<L, R>;

  /// Check se è Left (errore)
  bool get isLeft => this is Left<L, R>;

  /// Estrae valore Right o null
  R? get rightOrNull => fold((_) => null, (r) => r);

  /// Estrae valore Left o null
  L? get leftOrNull => fold((l) => l, (_) => null);
}

/// Left (errore)
final class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onLeft(value);
  }

  @override
  bool operator ==(Object other) => other is Left<L, R> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Right (successo)
final class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onRight(value);
  }

  @override
  bool operator ==(Object other) =>
      other is Right<L, R> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Extensions per convenienza
extension EitherX<L, R> on Either<L, R> {
  /// Map sul valore Right
  Either<L, T> map<T>(T Function(R value) f) {
    return fold((left) => Either.left(left), (right) => Either.right(f(right)));
  }

  /// FlatMap / bind
  Either<L, T> flatMap<T>(Either<L, T> Function(R value) f) {
    return fold((left) => Either.left(left), (right) => f(right));
  }

  /// Esegui side effect se Right
  Either<L, R> onRight(void Function(R value) f) {
    if (isRight) {
      f(rightOrNull as R);
    }
    return this;
  }

  /// Esegui side effect se Left
  Either<L, R> onLeft(void Function(L value) f) {
    if (isLeft) {
      f(leftOrNull as L);
    }
    return this;
  }

  /// Ottieni valore Right o lancia eccezione
  R getOrElse(R Function() orElse) {
    return fold((_) => orElse(), (r) => r);
  }
}

/// Helper per wrappare try-catch in Either
Either<Failure, T> tryCatch<T>(
  T Function() operation, {
  Failure Function(dynamic error)? onError,
}) {
  try {
    return Either.right(operation());
  } catch (e, stackTrace) {
    final failure = onError?.call(e) ?? UnknownFailure(e.toString());
    return Either.left(failure);
  }
}

/// Helper async
Future<Either<Failure, T>> tryCatchAsync<T>(
  Future<T> Function() operation, {
  Failure Function(dynamic error)? onError,
}) async {
  try {
    final result = await operation();
    return Either.right(result);
  } catch (e, stackTrace) {
    final failure = onError?.call(e) ?? UnknownFailure(e.toString());
    return Either.left(failure);
  }
}
