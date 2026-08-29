// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `keepAlive`: il client tiene il [RequestCoalescer], e tramite `authDio` lo
/// stato di deduplica del refresh.
///
/// Con `autoDispose` quelle mappe si azzeravano ogni volta che nessuno
/// osservava il provider: due schermate aperte in sequenza ripartivano da zero
/// e le richieste identiche tornavano a duplicarsi — cioe' esattamente il
/// sintomo che il coalescer esiste per eliminare.

@ProviderFor(apiClient)
const apiClientProvider = ApiClientProvider._();

/// `keepAlive`: il client tiene il [RequestCoalescer], e tramite `authDio` lo
/// stato di deduplica del refresh.
///
/// Con `autoDispose` quelle mappe si azzeravano ogni volta che nessuno
/// osservava il provider: due schermate aperte in sequenza ripartivano da zero
/// e le richieste identiche tornavano a duplicarsi — cioe' esattamente il
/// sintomo che il coalescer esiste per eliminare.

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  /// `keepAlive`: il client tiene il [RequestCoalescer], e tramite `authDio` lo
  /// stato di deduplica del refresh.
  ///
  /// Con `autoDispose` quelle mappe si azzeravano ogni volta che nessuno
  /// osservava il provider: due schermate aperte in sequenza ripartivano da zero
  /// e le richieste identiche tornavano a duplicarsi — cioe' esattamente il
  /// sintomo che il coalescer esiste per eliminare.
  const ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'91061708ae02dde981e933d0ed17718667507c2d';
