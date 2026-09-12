// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the current network connectivity status and streams updates.

@ProviderFor(connectivity)
const connectivityProvider = ConnectivityProvider._();

/// Provides the current network connectivity status and streams updates.

final class ConnectivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ConnectivityResult>>,
          List<ConnectivityResult>,
          Stream<List<ConnectivityResult>>
        >
    with
        $FutureModifier<List<ConnectivityResult>>,
        $StreamProvider<List<ConnectivityResult>> {
  /// Provides the current network connectivity status and streams updates.
  const ConnectivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityHash();

  @$internal
  @override
  $StreamProviderElement<List<ConnectivityResult>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ConnectivityResult>> create(Ref ref) {
    return connectivity(ref);
  }
}

String _$connectivityHash() => r'69c6e2db8337a9ff832358c4a079a4846fa6f28c';

/// Se il dispositivo ha un'interfaccia di rete attiva.
///
/// Emette subito lo stato corrente e poi segue i cambi, cosi' chi lo osserva
/// non deve aspettare la prima transizione. Dice che una rete c'e', non che il
/// backend risponda: e' un segnale per provare, mai un'autorita'.

@ProviderFor(isOnline)
const isOnlineProvider = IsOnlineProvider._();

/// Se il dispositivo ha un'interfaccia di rete attiva.
///
/// Emette subito lo stato corrente e poi segue i cambi, cosi' chi lo osserva
/// non deve aspettare la prima transizione. Dice che una rete c'e', non che il
/// backend risponda: e' un segnale per provare, mai un'autorita'.

final class IsOnlineProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Se il dispositivo ha un'interfaccia di rete attiva.
  ///
  /// Emette subito lo stato corrente e poi segue i cambi, cosi' chi lo osserva
  /// non deve aspettare la prima transizione. Dice che una rete c'e', non che il
  /// backend risponda: e' un segnale per provare, mai un'autorita'.
  const IsOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOnlineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOnlineHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return isOnline(ref);
  }
}

String _$isOnlineHash() => r'3feb5aac2ef2bf93acd29bdbb4821ed52ddec3b4';
