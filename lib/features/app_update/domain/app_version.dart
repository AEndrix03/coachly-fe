/// Versione `major.minor.patch` del client, confrontabile.
///
/// Esiste perche' il confronto fra versioni e' una regola di dominio e non una
/// formattazione: `"1.10.0"` e' **maggiore** di `"1.9.0"`, mentre il confronto
/// fra stringhe direbbe il contrario. E' il tipo di errore che non si vede in
/// sviluppo e che blocca fuori tutti gli utenti al primo `minor` a due cifre.
///
/// Vedi `docs/development/25-release-and-environments.md`.
final class AppVersion implements Comparable<AppVersion> {
  const AppVersion(this.major, this.minor, this.patch);

  final int major;
  final int minor;
  final int patch;

  /// Interpreta `major.minor.patch`, tollerando un suffisso `+build` o `-beta`.
  ///
  /// Ritorna `null` su input che non ha senso: il chiamante decide cosa farne,
  /// e per una guard di aggiornamento la scelta giusta e' **non bloccare**.
  /// Una soglia illeggibile non deve mai chiudere fuori un utente.
  static AppVersion? tryParse(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    // Scarta `+1` di pubspec e gli eventuali pre-release `-beta.2`.
    final core = trimmed.split(RegExp(r'[+\-]')).first;
    final parts = core.split('.');
    if (parts.isEmpty || parts.length > 3) return null;

    final numbers = <int>[];
    for (final part in parts) {
      final value = int.tryParse(part);
      if (value == null || value < 0) return null;
      numbers.add(value);
    }

    return AppVersion(
      numbers[0],
      numbers.length > 1 ? numbers[1] : 0,
      numbers.length > 2 ? numbers[2] : 0,
    );
  }

  @override
  int compareTo(AppVersion other) {
    final byMajor = major.compareTo(other.major);
    if (byMajor != 0) return byMajor;
    final byMinor = minor.compareTo(other.minor);
    if (byMinor != 0) return byMinor;
    return patch.compareTo(other.patch);
  }

  bool operator <(AppVersion other) => compareTo(other) < 0;

  bool operator <=(AppVersion other) => compareTo(other) <= 0;

  bool operator >(AppVersion other) => compareTo(other) > 0;

  bool operator >=(AppVersion other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      other is AppVersion &&
      other.major == major &&
      other.minor == minor &&
      other.patch == patch;

  @override
  int get hashCode => Object.hash(major, minor, patch);

  @override
  String toString() => '$major.$minor.$patch';
}
