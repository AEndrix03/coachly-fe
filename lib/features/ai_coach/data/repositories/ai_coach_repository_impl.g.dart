// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_coach_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiCoachRepository)
const aiCoachRepositoryProvider = AiCoachRepositoryProvider._();

final class AiCoachRepositoryProvider
    extends
        $FunctionalProvider<
          AiCoachRepository,
          AiCoachRepository,
          AiCoachRepository
        >
    with $Provider<AiCoachRepository> {
  const AiCoachRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiCoachRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiCoachRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiCoachRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiCoachRepository create(Ref ref) {
    return aiCoachRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiCoachRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiCoachRepository>(value),
    );
  }
}

String _$aiCoachRepositoryHash() => r'9764f58146acfaf2e8c6eb7638b66289da61169e';
