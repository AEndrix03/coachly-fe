import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// Provides the current network connectivity status and streams updates.
@riverpod
Stream<List<ConnectivityResult>> connectivity(Ref ref) {
  return Connectivity().onConnectivityChanged;
}

bool _hasNetwork(List<ConnectivityResult> results) =>
    results.any((result) => result != ConnectivityResult.none);

/// Se il dispositivo ha un'interfaccia di rete attiva.
///
/// Emette subito lo stato corrente e poi segue i cambi, cosi' chi lo osserva
/// non deve aspettare la prima transizione. Dice che una rete c'e', non che il
/// backend risponda: e' un segnale per provare, mai un'autorita'.
@riverpod
Stream<bool> isOnline(Ref ref) async* {
  final connectivity = Connectivity();
  yield _hasNetwork(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(_hasNetwork);
}
