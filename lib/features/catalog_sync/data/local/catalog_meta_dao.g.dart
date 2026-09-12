// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_meta_dao.dart';

// ignore_for_file: type=lint
mixin _$CatalogMetaDaoMixin on DatabaseAccessor<AppDatabase> {
  $CatalogMetaTable get catalogMeta => attachedDatabase.catalogMeta;
  CatalogMetaDaoManager get managers => CatalogMetaDaoManager(this);
}

class CatalogMetaDaoManager {
  final _$CatalogMetaDaoMixin _db;
  CatalogMetaDaoManager(this._db);
  $$CatalogMetaTableTableManager get catalogMeta =>
      $$CatalogMetaTableTableManager(_db.attachedDatabase, _db.catalogMeta);
}
