// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_exercise_dao.dart';

// ignore_for_file: type=lint
mixin _$CustomExerciseDaoMixin on DatabaseAccessor<AppDatabase> {
  $CustomExercisesTable get customExercises => attachedDatabase.customExercises;
  $LocalizedTextsTable get localizedTexts => attachedDatabase.localizedTexts;
  CustomExerciseDaoManager get managers => CustomExerciseDaoManager(this);
}

class CustomExerciseDaoManager {
  final _$CustomExerciseDaoMixin _db;
  CustomExerciseDaoManager(this._db);
  $$CustomExercisesTableTableManager get customExercises =>
      $$CustomExercisesTableTableManager(
        _db.attachedDatabase,
        _db.customExercises,
      );
  $$LocalizedTextsTableTableManager get localizedTexts =>
      $$LocalizedTextsTableTableManager(
        _db.attachedDatabase,
        _db.localizedTexts,
      );
}
