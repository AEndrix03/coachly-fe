// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_interceptor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Una sola istanza di Dio per la vita della app.
///
/// `keepAlive` perche' ricrearla butterebbe via il pool di connessioni, e
/// perche' `authDio` le aggancia un interceptor: un Dio ricreato in silenzio
/// significa un interceptor riagganciato in silenzio.

@ProviderFor(dioClient)
const dioClientProvider = DioClientProvider._();

/// Una sola istanza di Dio per la vita della app.
///
/// `keepAlive` perche' ricrearla butterebbe via il pool di connessioni, e
/// perche' `authDio` le aggancia un interceptor: un Dio ricreato in silenzio
/// significa un interceptor riagganciato in silenzio.

final class DioClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Una sola istanza di Dio per la vita della app.
  ///
  /// `keepAlive` perche' ricrearla butterebbe via il pool di connessioni, e
  /// perche' `authDio` le aggancia un interceptor: un Dio ricreato in silenzio
  /// significa un interceptor riagganciato in silenzio.
  const DioClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioClientHash() => r'6361539bdeba6df783b0ded53bd5f0f3fbddd7c8';

/// Il Dio con l'autenticazione agganciata.
///
/// `keepAlive` non e' un'ottimizzazione: [AuthInterceptor] tiene il refresh in
/// corso per deduplicarlo, e un interceptor ricreato lo dimentica — dieci
/// richieste scadute insieme tornerebbero a produrre dieci refresh.

@ProviderFor(authDio)
const authDioProvider = AuthDioProvider._();

/// Il Dio con l'autenticazione agganciata.
///
/// `keepAlive` non e' un'ottimizzazione: [AuthInterceptor] tiene il refresh in
/// corso per deduplicarlo, e un interceptor ricreato lo dimentica — dieci
/// richieste scadute insieme tornerebbero a produrre dieci refresh.

final class AuthDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Il Dio con l'autenticazione agganciata.
  ///
  /// `keepAlive` non e' un'ottimizzazione: [AuthInterceptor] tiene il refresh in
  /// corso per deduplicarlo, e un interceptor ricreato lo dimentica — dieci
  /// richieste scadute insieme tornerebbero a produrre dieci refresh.
  const AuthDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return authDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$authDioHash() => r'736452034671a201ed80ca8a93825115240dd2bd';
