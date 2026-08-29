// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_catalog_dao.dart';

// ignore_for_file: type=lint
mixin _$ExerciseCatalogDaoMixin on DatabaseAccessor<AppDatabase> {
  $CatalogExercisesTable get catalogExercises =>
      attachedDatabase.catalogExercises;
  $LocalizedTextsTable get localizedTexts => attachedDatabase.localizedTexts;
  $ExerciseMusclesTable get exerciseMuscles => attachedDatabase.exerciseMuscles;
  $ExerciseEquipmentsTable get exerciseEquipments =>
      attachedDatabase.exerciseEquipments;
  ExerciseCatalogDaoManager get managers => ExerciseCatalogDaoManager(this);
}

class ExerciseCatalogDaoManager {
  final _$ExerciseCatalogDaoMixin _db;
  ExerciseCatalogDaoManager(this._db);
  $$CatalogExercisesTableTableManager get catalogExercises =>
      $$CatalogExercisesTableTableManager(
        _db.attachedDatabase,
        _db.catalogExercises,
      );
  $$LocalizedTextsTableTableManager get localizedTexts =>
      $$LocalizedTextsTableTableManager(
        _db.attachedDatabase,
        _db.localizedTexts,
      );
  $$ExerciseMusclesTableTableManager get exerciseMuscles =>
      $$ExerciseMusclesTableTableManager(
        _db.attachedDatabase,
        _db.exerciseMuscles,
      );
  $$ExerciseEquipmentsTableTableManager get exerciseEquipments =>
      $$ExerciseEquipmentsTableTableManager(
        _db.attachedDatabase,
        _db.exerciseEquipments,
      );
}
