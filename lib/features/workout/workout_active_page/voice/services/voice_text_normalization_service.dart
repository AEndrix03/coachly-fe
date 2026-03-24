import 'package:flutter_riverpod/flutter_riverpod.dart';

final voiceTextNormalizationServiceProvider =
    Provider<VoiceTextNormalizationService>((ref) {
      return const VoiceTextNormalizationService();
    });

class VoiceTextNormalizationService {
  const VoiceTextNormalizationService();

  static const Map<String, String> _tokenReplacements = {
    'kilo': 'kg',
    'kilos': 'kg',
    'kili': 'kg',
    'kilogram': 'kg',
    'kilograms': 'kg',
    'chilogrammo': 'kg',
    'chilogrammi': 'kg',
    'chilo': 'kg',
    'chili': 'kg',
    'serie': 'sets',
    'set': 'sets',
    'series': 'sets',
    'rip': 'reps',
    'rep': 'reps',
    'repetition': 'reps',
    'repetitions': 'reps',
    'ripetizione': 'reps',
    'ripetizioni': 'reps',
  };

  static const Map<String, int> _spokenNumbers = {
    'zero': 0,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    'ten': 10,
    'eleven': 11,
    'twelve': 12,
    'thirteen': 13,
    'fourteen': 14,
    'fifteen': 15,
    'sixteen': 16,
    'seventeen': 17,
    'eighteen': 18,
    'nineteen': 19,
    'twenty': 20,
    'uno': 1,
    'una': 1,
    'due': 2,
    'tre': 3,
    'quattro': 4,
    'cinque': 5,
    'sei': 6,
    'sette': 7,
    'otto': 8,
    'nove': 9,
    'dieci': 10,
    'undici': 11,
    'dodici': 12,
    'tredici': 13,
    'quattordici': 14,
    'quindici': 15,
    'sedici': 16,
    'diciassette': 17,
    'diciotto': 18,
    'diciannove': 19,
    'venti': 20,
  };

  String normalize(String input) {
    var value = input.toLowerCase().trim();
    if (value.isEmpty) {
      return '';
    }

    value = value
        .replaceAll(RegExp(r"[`']"), "'")
        .replaceAll(RegExp(r'(\d),(\d)'), r'$1.$2')
        .replaceAll(RegExp(r'[^a-z0-9.\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final normalizedTokens = value
        .split(' ')
        .where((token) => token.isNotEmpty)
        .map(_normalizeToken)
        .toList();

    return normalizedTokens.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _normalizeToken(String rawToken) {
    final token = rawToken.trim();
    if (token.isEmpty) {
      return token;
    }

    if (_spokenNumbers.containsKey(token)) {
      return _spokenNumbers[token]!.toString();
    }

    return _tokenReplacements[token] ?? token;
  }
}
