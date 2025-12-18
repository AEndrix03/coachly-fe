// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_interceptor_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(httpClient)
const httpClientProvider = HttpClientProvider._();

final class HttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  const HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$httpClientHash() => r'8c21f22632338286954dc297d3cf423520492f98';

@ProviderFor(authHttpClient)
const authHttpClientProvider = AuthHttpClientProvider._();

final class AuthHttpClientProvider
    extends $FunctionalProvider<AuthHttpClient, AuthHttpClient, AuthHttpClient>
    with $Provider<AuthHttpClient> {
  const AuthHttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authHttpClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHttpClientHash();

  @$internal
  @override
  $ProviderElement<AuthHttpClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthHttpClient create(Ref ref) {
    return authHttpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthHttpClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthHttpClient>(value),
    );
  }
}

String _$authHttpClientHash() => r'79e4fa11d8d6f60622de5b7a6773cfb3c4b9e421';
