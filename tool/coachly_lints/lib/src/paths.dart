/// Helper sui percorsi: le dependency rules di `docs/development/01-principles.md`
/// sono espresse come vincoli fra cartelle, quindi quasi tutti i lint si
/// riducono a "chi sono io" e "chi sto importando".
String _normalize(String path) => path.replaceAll(r'\', '/');

/// I file dove i primitivi di stile sono legittimi.
bool isTokenFile(String path) {
  final p = _normalize(path);
  return p.contains('/lib/design_system/tokens/') ||
      p.contains('/lib/design_system/theme/');
}

bool isInLayer(String path, String layer) =>
    _normalize(path).contains('/$layer/');

bool isPresentation(String path) {
  final p = _normalize(path);
  return p.contains('/presentation/') ||
      p.contains('/lib/design_system/components/');
}

bool isApplication(String path) => isInLayer(path, 'application');

bool isDataLayer(String path) => isInLayer(path, 'data');

bool isRepository(String path) =>
    _normalize(path).contains('/data/repositories/');

bool isCore(String path) => _normalize(path).contains('/lib/core/');

bool isTest(String path) {
  final p = _normalize(path);
  return p.contains('/test/') || p.endsWith('_test.dart');
}

/// Il file generato non si corregge a mano: segnalarlo è solo rumore.
bool isGenerated(String path) {
  final p = _normalize(path);
  return p.endsWith('.g.dart') || p.endsWith('.freezed.dart');
}

/// Estrae la feature di appartenenza, se il file sta sotto `lib/features/`.
String? featureOf(String path) {
  final p = _normalize(path);
  final marker = '/lib/features/';
  final index = p.indexOf(marker);
  if (index == -1) return null;
  final rest = p.substring(index + marker.length);
  final slash = rest.indexOf('/');
  return slash == -1 ? rest : rest.substring(0, slash);
}
