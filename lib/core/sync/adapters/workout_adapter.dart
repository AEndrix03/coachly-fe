import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:hive/hive.dart';

class WorkoutAdapter extends TypeAdapter<WorkoutModel> {
  @override
  final int typeId = 0;

  @override
  WorkoutModel read(BinaryReader reader) {
    final map = reader.readMap();
    final json = _convertMap(map);
    return WorkoutModel.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, WorkoutModel obj) {
    writer.writeMap(obj.toJson());
  }

  Map<String, dynamic> _convertMap(dynamic map) {
    if (map is Map) {
      return map.map((key, value) {
        if (value is Map) {
          return MapEntry(key.toString(), _convertMap(value));
        }
        return MapEntry(key.toString(), value);
      });
    }
    return {};
  }
}
