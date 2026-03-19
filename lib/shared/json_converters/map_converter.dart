import 'package:json_annotation/json_annotation.dart';

class MapConverter implements JsonConverter<Map<String, String>?, Object?> {
  const MapConverter();

  @override
  Map<String, String>? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    if (json is Map) {
      final mapped = <String, String>{};
      for (final entry in json.entries) {
        final key = entry.key.toString().trim();
        final value = entry.value;
        if (key.isEmpty || value == null) {
          continue;
        }

        final text = value.toString().trim();
        if (text.isEmpty) {
          continue;
        }

        mapped[key] = text;
      }
      return mapped.isEmpty ? null : mapped;
    }
    return null;
  }

  @override
  Object? toJson(Map<String, String>? object) {
    return object;
  }
}
