import 'package:json_annotation/json_annotation.dart';

class MapConverter implements JsonConverter<Map<String, String>?, Object?> {
  const MapConverter();

  @override
  Map<String, String>? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    if (json is Map<String, dynamic>) {
      return json.map((k, e) => MapEntry(k, e as String));
    }
    // Handle cases where backend might send "" or other non-map types
    return null;
  }

  @override
  Object? toJson(Map<String, String>? object) {
    return object;
  }
}
