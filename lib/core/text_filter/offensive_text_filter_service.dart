enum TextModerationPolicy { freeText, titleStrict }

class OffensiveTextFilterService {
  const OffensiveTextFilterService();

  static const List<String> _positiveWords = [
    'gentilezza',
    'rispetto',
    'empatia',
    'armonia',
    'serenita',
    'cortesia',
    'equilibrio',
    'costruttivita',
  ];

  static final List<_CompiledTerm> _offensiveTerms = _compileTerms(const [
    'bastardo',
    'stronzo',
    'idiota',
    'imbecille',
    'cretino',
    'deficiente',
    'vaffanculo',
    'fanculo',
    'asshole',
    'motherfucker',
    'bitch',
    'slut',
    'cabron',
    'hijodeputa',
    'connard',
    'salope',
    'arschloch',
    'kurwa',
    'puta',
    'puto',
  ]);

  static final List<_CompiledTerm> _strictTitleTerms = _compileTerms(const [
    'cazzo',
    'merda',
    'porca',
    'shit',
    'fuck',
    'damn',
    'joder',
    'mierda',
    'putain',
    'scheisse',
    'caralho',
    'porra',
    'foda',
  ]);

  String sanitize(
    String input, {
    TextModerationPolicy policy = TextModerationPolicy.freeText,
  }) {
    if (input.isEmpty) {
      return input;
    }

    final terms = policy == TextModerationPolicy.titleStrict
        ? [..._offensiveTerms, ..._strictTitleTerms]
        : _offensiveTerms;

    var output = input;
    var replacementIndex = 0;

    for (final term in terms) {
      output = output.replaceAllMapped(term.pattern, (match) {
        final prefix = match.group(1) ?? '';
        final replacement =
            _positiveWords[replacementIndex % _positiveWords.length];
        replacementIndex++;
        return '$prefix$replacement';
      });
    }

    return output;
  }

  static List<_CompiledTerm> _compileTerms(List<String> terms) {
    return terms
        .map((t) => _normalizeCanonical(t))
        .where((t) => t.isNotEmpty)
        .toSet()
        .map((t) => _CompiledTerm(_buildFlexiblePattern(t)))
        .toList(growable: false);
  }

  static RegExp _buildFlexiblePattern(String canonicalTerm) {
    final chars = canonicalTerm.split('');
    final body = chars.map(_charPattern).join(r'[\W_]*');
    final pattern =
        '(^|[^A-Za-zÀ-ÖØ-öø-ÿ0-9])($body)(?=\$|[^A-Za-zÀ-ÖØ-öø-ÿ0-9])';
    return RegExp(pattern, caseSensitive: false, unicode: true);
  }

  static String _normalizeCanonical(String raw) {
    final lower = raw.toLowerCase();
    final ascii = _stripDiacritics(lower);
    return ascii.replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static String _charPattern(String char) {
    final variants = _charVariants[char];
    if (variants == null || variants.isEmpty) {
      return RegExp.escape(char);
    }
    final escaped = variants.map(RegExp.escape).join();
    return '[$escaped]';
  }

  static String _stripDiacritics(String input) {
    var output = input;
    _diacritics.forEach((key, value) {
      output = output.replaceAll(key, value);
    });
    return output;
  }

  static const Map<String, String> _diacritics = {
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ã': 'a',
    'ä': 'a',
    'å': 'a',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'ì': 'i',
    'í': 'i',
    'î': 'i',
    'ï': 'i',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ö': 'o',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'ü': 'u',
    'ç': 'c',
    'ñ': 'n',
    'ý': 'y',
    'ÿ': 'y',
  };

  static const Map<String, List<String>> _charVariants = {
    'a': ['a', 'A', '4', '@', 'à', 'á', 'â', 'ã', 'ä', 'å'],
    'b': ['b', 'B', '8'],
    'c': ['c', 'C', '(', '<', 'ç'],
    'd': ['d', 'D'],
    'e': ['e', 'E', '3', 'è', 'é', 'ê', 'ë'],
    'f': ['f', 'F'],
    'g': ['g', 'G', '6', '9'],
    'h': ['h', 'H'],
    'i': ['i', 'I', '1', '!', '|', 'ì', 'í', 'î', 'ï'],
    'j': ['j', 'J'],
    'k': ['k', 'K'],
    'l': ['l', 'L', '1', '|'],
    'm': ['m', 'M'],
    'n': ['n', 'N', 'ñ'],
    'o': ['o', 'O', '0', 'ò', 'ó', 'ô', 'õ', 'ö'],
    'p': ['p', 'P'],
    'q': ['q', 'Q', '9'],
    'r': ['r', 'R'],
    's': ['s', 'S', '5', r'$'],
    't': ['t', 'T', '7', '+'],
    'u': ['u', 'U', 'ù', 'ú', 'û', 'ü'],
    'v': ['v', 'V'],
    'w': ['w', 'W'],
    'x': ['x', 'X'],
    'y': ['y', 'Y', 'ý', 'ÿ'],
    'z': ['z', 'Z', '2'],
    '0': ['0', 'o', 'O'],
    '1': ['1', 'i', 'I', 'l', 'L', '!'],
    '2': ['2', 'z', 'Z'],
    '3': ['3', 'e', 'E'],
    '4': ['4', 'a', 'A', '@'],
    '5': ['5', 's', 'S', r'$'],
    '6': ['6', 'g', 'G'],
    '7': ['7', 't', 'T', '+'],
    '8': ['8', 'b', 'B'],
    '9': ['9', 'g', 'G', 'q', 'Q'],
  };
}

class _CompiledTerm {
  const _CompiledTerm(this.pattern);

  final RegExp pattern;
}
