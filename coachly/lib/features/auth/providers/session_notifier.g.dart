// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SessionNotifier)
const sessionProvider = SessionNotifierProvider._();

final class SessionNotifierProvider
    extends $NotifierProvider<SessionNotifier, Session> {
  const SessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionNotifierHash();

  @$internal
  @override
  SessionNotifier create() => SessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Session value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Session>(value),
    );
  }
}

String _$sessionNotifierHash() => r'fac80cfaa6ce278a04cf035000d9a71e129a9633';

abstract class _$SessionNotifier extends $Notifier<Session> {
  Session build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Session, Session>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Session, Session>,
              Session,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
