// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stt_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sttService)
const sttServiceProvider = SttServiceProvider._();

final class SttServiceProvider
    extends $FunctionalProvider<SttService, SttService, SttService>
    with $Provider<SttService> {
  const SttServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sttServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sttServiceHash();

  @$internal
  @override
  $ProviderElement<SttService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SttService create(Ref ref) {
    return sttService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SttService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SttService>(value),
    );
  }
}

String _$sttServiceHash() => r'3b5f6549512bd03809edc2626d6c58894e3c5e51';
