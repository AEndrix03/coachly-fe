/// Il tipo di ritorno unico del data layer.
///
/// Vedi `docs/development/07-errors-and-feedback.md`. Ogni metodo pubblico di
/// un repository ritorna un [Result]: nessuna eccezione attraversa il confine
/// del data layer, le eccezioni tecniche si convertono lì, dove ci sono le
/// informazioni per farlo.
///
/// È una `sealed class`: `switch` esaustivo con pattern matching Dart 3.
///
/// ```dart
/// switch (result) {
///   case Ok(:final value): // ...
///   case Err(:final failure): // ...
/// }
/// ```
sealed class Result<T, F> {
  const Result();

  /// `true` se il risultato è un [Ok].
  bool get isOk => this is Ok<T, F>;

  /// Il valore se [Ok], altrimenti `null`.
  ///
  /// Attenzione: con `T` nullable un `null` non distingue Ok da Err. In quel
  /// caso usa il pattern matching o [fold].
  T? get valueOrNull => switch (this) {
    Ok<T, F>(:final value) => value,
    Err<T, F>() => null,
  };

  /// Il fallimento se [Err], altrimenti `null`.
  F? get failureOrNull => switch (this) {
    Ok<T, F>() => null,
    Err<T, F>(:final failure) => failure,
  };

  /// Trasforma il valore di successo, lasciando intatto il fallimento.
  Result<R, F> map<R>(R Function(T value) transform) => switch (this) {
    Ok<T, F>(:final value) => Ok<R, F>(transform(value)),
    Err<T, F>(:final failure) => Err<R, F>(failure),
  };

  /// Trasforma il fallimento, lasciando intatto il valore di successo.
  Result<T, G> mapErr<G>(G Function(F failure) transform) => switch (this) {
    Ok<T, F>(:final value) => Ok<T, G>(value),
    Err<T, F>(:final failure) => Err<T, G>(transform(failure)),
  };

  /// Riduce i due rami a un valore solo.
  R fold<R>(R Function(T value) onOk, R Function(F failure) onErr) =>
      switch (this) {
        Ok<T, F>(:final value) => onOk(value),
        Err<T, F>(:final failure) => onErr(failure),
      };
}

/// Ramo di successo.
final class Ok<T, F> extends Result<T, F> {
  final T value;

  const Ok(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Ok<T, F> && other.value == value;

  @override
  int get hashCode => Object.hash(Ok<T, F>, value);

  @override
  String toString() => 'Ok($value)';
}

/// Ramo di fallimento.
final class Err<T, F> extends Result<T, F> {
  final F failure;

  const Err(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Err<T, F> && other.failure == failure;

  @override
  int get hashCode => Object.hash(Err<T, F>, failure);

  @override
  String toString() => 'Err($failure)';
}
