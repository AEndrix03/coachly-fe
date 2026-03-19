// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemma_inference_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gemmaInferenceService)
const gemmaInferenceServiceProvider = GemmaInferenceServiceProvider._();

final class GemmaInferenceServiceProvider
    extends
        $FunctionalProvider<
          GemmaInferenceService,
          GemmaInferenceService,
          GemmaInferenceService
        >
    with $Provider<GemmaInferenceService> {
  const GemmaInferenceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gemmaInferenceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gemmaInferenceServiceHash();

  @$internal
  @override
  $ProviderElement<GemmaInferenceService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GemmaInferenceService create(Ref ref) {
    return gemmaInferenceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GemmaInferenceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GemmaInferenceService>(value),
    );
  }
}

String _$gemmaInferenceServiceHash() =>
    r'bf5a9fc98f9f5200dc4ad266d028cf0b0b806ff0';
