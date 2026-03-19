// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_coach_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiCoachNotifier)
const aiCoachProvider = AiCoachNotifierProvider._();

final class AiCoachNotifierProvider
    extends $AsyncNotifierProvider<AiCoachNotifier, AiCoachState> {
  const AiCoachNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiCoachProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiCoachNotifierHash();

  @$internal
  @override
  AiCoachNotifier create() => AiCoachNotifier();
}

String _$aiCoachNotifierHash() => r'b0f5ef581e1e01194572ea4631c612859cfac7a0';

abstract class _$AiCoachNotifier extends $AsyncNotifier<AiCoachState> {
  FutureOr<AiCoachState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AiCoachState>, AiCoachState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AiCoachState>, AiCoachState>,
              AsyncValue<AiCoachState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
