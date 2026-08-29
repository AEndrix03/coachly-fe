// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CatalogExercisesTable extends CatalogExercises
    with TableInfo<$CatalogExercisesTable, CatalogExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _difficultyLevelMeta = const VerificationMeta(
    'difficultyLevel',
  );
  @override
  late final GeneratedColumn<String> difficultyLevel = GeneratedColumn<String>(
    'difficulty_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mechanicsTypeMeta = const VerificationMeta(
    'mechanicsType',
  );
  @override
  late final GeneratedColumn<String> mechanicsType = GeneratedColumn<String>(
    'mechanics_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _forceTypeMeta = const VerificationMeta(
    'forceType',
  );
  @override
  late final GeneratedColumn<String> forceType = GeneratedColumn<String>(
    'force_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unilateralMeta = const VerificationMeta(
    'unilateral',
  );
  @override
  late final GeneratedColumn<bool> unilateral = GeneratedColumn<bool>(
    'unilateral',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("unilateral" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _bodyweightMeta = const VerificationMeta(
    'bodyweight',
  );
  @override
  late final GeneratedColumn<bool> bodyweight = GeneratedColumn<bool>(
    'bodyweight',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bodyweight" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _exerciseKindMeta = const VerificationMeta(
    'exerciseKind',
  );
  @override
  late final GeneratedColumn<String> exerciseKind = GeneratedColumn<String>(
    'exercise_kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _catalogStatusMeta = const VerificationMeta(
    'catalogStatus',
  );
  @override
  late final GeneratedColumn<String> catalogStatus = GeneratedColumn<String>(
    'catalog_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    difficultyLevel,
    mechanicsType,
    forceType,
    unilateral,
    bodyweight,
    exerciseKind,
    catalogStatus,
    payload,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('difficulty_level')) {
      context.handle(
        _difficultyLevelMeta,
        difficultyLevel.isAcceptableOrUnknown(
          data['difficulty_level']!,
          _difficultyLevelMeta,
        ),
      );
    }
    if (data.containsKey('mechanics_type')) {
      context.handle(
        _mechanicsTypeMeta,
        mechanicsType.isAcceptableOrUnknown(
          data['mechanics_type']!,
          _mechanicsTypeMeta,
        ),
      );
    }
    if (data.containsKey('force_type')) {
      context.handle(
        _forceTypeMeta,
        forceType.isAcceptableOrUnknown(data['force_type']!, _forceTypeMeta),
      );
    }
    if (data.containsKey('unilateral')) {
      context.handle(
        _unilateralMeta,
        unilateral.isAcceptableOrUnknown(data['unilateral']!, _unilateralMeta),
      );
    }
    if (data.containsKey('bodyweight')) {
      context.handle(
        _bodyweightMeta,
        bodyweight.isAcceptableOrUnknown(data['bodyweight']!, _bodyweightMeta),
      );
    }
    if (data.containsKey('exercise_kind')) {
      context.handle(
        _exerciseKindMeta,
        exerciseKind.isAcceptableOrUnknown(
          data['exercise_kind']!,
          _exerciseKindMeta,
        ),
      );
    }
    if (data.containsKey('catalog_status')) {
      context.handle(
        _catalogStatusMeta,
        catalogStatus.isAcceptableOrUnknown(
          data['catalog_status']!,
          _catalogStatusMeta,
        ),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      difficultyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty_level'],
      ),
      mechanicsType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mechanics_type'],
      ),
      forceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}force_type'],
      ),
      unilateral: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}unilateral'],
      )!,
      bodyweight: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bodyweight'],
      )!,
      exerciseKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_kind'],
      ),
      catalogStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_status'],
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CatalogExercisesTable createAlias(String alias) {
    return $CatalogExercisesTable(attachedDatabase, alias);
  }
}

class CatalogExerciseRow extends DataClass
    implements Insertable<CatalogExerciseRow> {
  final String id;
  final String code;
  final String? difficultyLevel;
  final String? mechanicsType;
  final String? forceType;
  final bool unilateral;
  final bool bodyweight;
  final String? exerciseKind;
  final String? catalogStatus;

  /// Il payload JSON completo del dettaglio, così come arriva dal backend.
  ///
  /// `null` finché il dettaglio non è stato scaricato: il catalogo si popola
  /// con i riepiloghi e i dettagli restano pigri, uno per volta.
  final String? payload;
  final DateTime updatedAt;
  const CatalogExerciseRow({
    required this.id,
    required this.code,
    this.difficultyLevel,
    this.mechanicsType,
    this.forceType,
    required this.unilateral,
    required this.bodyweight,
    this.exerciseKind,
    this.catalogStatus,
    this.payload,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || difficultyLevel != null) {
      map['difficulty_level'] = Variable<String>(difficultyLevel);
    }
    if (!nullToAbsent || mechanicsType != null) {
      map['mechanics_type'] = Variable<String>(mechanicsType);
    }
    if (!nullToAbsent || forceType != null) {
      map['force_type'] = Variable<String>(forceType);
    }
    map['unilateral'] = Variable<bool>(unilateral);
    map['bodyweight'] = Variable<bool>(bodyweight);
    if (!nullToAbsent || exerciseKind != null) {
      map['exercise_kind'] = Variable<String>(exerciseKind);
    }
    if (!nullToAbsent || catalogStatus != null) {
      map['catalog_status'] = Variable<String>(catalogStatus);
    }
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CatalogExercisesCompanion toCompanion(bool nullToAbsent) {
    return CatalogExercisesCompanion(
      id: Value(id),
      code: Value(code),
      difficultyLevel: difficultyLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(difficultyLevel),
      mechanicsType: mechanicsType == null && nullToAbsent
          ? const Value.absent()
          : Value(mechanicsType),
      forceType: forceType == null && nullToAbsent
          ? const Value.absent()
          : Value(forceType),
      unilateral: Value(unilateral),
      bodyweight: Value(bodyweight),
      exerciseKind: exerciseKind == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseKind),
      catalogStatus: catalogStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogStatus),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      updatedAt: Value(updatedAt),
    );
  }

  factory CatalogExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      difficultyLevel: serializer.fromJson<String?>(json['difficultyLevel']),
      mechanicsType: serializer.fromJson<String?>(json['mechanicsType']),
      forceType: serializer.fromJson<String?>(json['forceType']),
      unilateral: serializer.fromJson<bool>(json['unilateral']),
      bodyweight: serializer.fromJson<bool>(json['bodyweight']),
      exerciseKind: serializer.fromJson<String?>(json['exerciseKind']),
      catalogStatus: serializer.fromJson<String?>(json['catalogStatus']),
      payload: serializer.fromJson<String?>(json['payload']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'difficultyLevel': serializer.toJson<String?>(difficultyLevel),
      'mechanicsType': serializer.toJson<String?>(mechanicsType),
      'forceType': serializer.toJson<String?>(forceType),
      'unilateral': serializer.toJson<bool>(unilateral),
      'bodyweight': serializer.toJson<bool>(bodyweight),
      'exerciseKind': serializer.toJson<String?>(exerciseKind),
      'catalogStatus': serializer.toJson<String?>(catalogStatus),
      'payload': serializer.toJson<String?>(payload),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CatalogExerciseRow copyWith({
    String? id,
    String? code,
    Value<String?> difficultyLevel = const Value.absent(),
    Value<String?> mechanicsType = const Value.absent(),
    Value<String?> forceType = const Value.absent(),
    bool? unilateral,
    bool? bodyweight,
    Value<String?> exerciseKind = const Value.absent(),
    Value<String?> catalogStatus = const Value.absent(),
    Value<String?> payload = const Value.absent(),
    DateTime? updatedAt,
  }) => CatalogExerciseRow(
    id: id ?? this.id,
    code: code ?? this.code,
    difficultyLevel: difficultyLevel.present
        ? difficultyLevel.value
        : this.difficultyLevel,
    mechanicsType: mechanicsType.present
        ? mechanicsType.value
        : this.mechanicsType,
    forceType: forceType.present ? forceType.value : this.forceType,
    unilateral: unilateral ?? this.unilateral,
    bodyweight: bodyweight ?? this.bodyweight,
    exerciseKind: exerciseKind.present ? exerciseKind.value : this.exerciseKind,
    catalogStatus: catalogStatus.present
        ? catalogStatus.value
        : this.catalogStatus,
    payload: payload.present ? payload.value : this.payload,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CatalogExerciseRow copyWithCompanion(CatalogExercisesCompanion data) {
    return CatalogExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      difficultyLevel: data.difficultyLevel.present
          ? data.difficultyLevel.value
          : this.difficultyLevel,
      mechanicsType: data.mechanicsType.present
          ? data.mechanicsType.value
          : this.mechanicsType,
      forceType: data.forceType.present ? data.forceType.value : this.forceType,
      unilateral: data.unilateral.present
          ? data.unilateral.value
          : this.unilateral,
      bodyweight: data.bodyweight.present
          ? data.bodyweight.value
          : this.bodyweight,
      exerciseKind: data.exerciseKind.present
          ? data.exerciseKind.value
          : this.exerciseKind,
      catalogStatus: data.catalogStatus.present
          ? data.catalogStatus.value
          : this.catalogStatus,
      payload: data.payload.present ? data.payload.value : this.payload,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogExerciseRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('mechanicsType: $mechanicsType, ')
          ..write('forceType: $forceType, ')
          ..write('unilateral: $unilateral, ')
          ..write('bodyweight: $bodyweight, ')
          ..write('exerciseKind: $exerciseKind, ')
          ..write('catalogStatus: $catalogStatus, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    difficultyLevel,
    mechanicsType,
    forceType,
    unilateral,
    bodyweight,
    exerciseKind,
    catalogStatus,
    payload,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogExerciseRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.difficultyLevel == this.difficultyLevel &&
          other.mechanicsType == this.mechanicsType &&
          other.forceType == this.forceType &&
          other.unilateral == this.unilateral &&
          other.bodyweight == this.bodyweight &&
          other.exerciseKind == this.exerciseKind &&
          other.catalogStatus == this.catalogStatus &&
          other.payload == this.payload &&
          other.updatedAt == this.updatedAt);
}

class CatalogExercisesCompanion extends UpdateCompanion<CatalogExerciseRow> {
  final Value<String> id;
  final Value<String> code;
  final Value<String?> difficultyLevel;
  final Value<String?> mechanicsType;
  final Value<String?> forceType;
  final Value<bool> unilateral;
  final Value<bool> bodyweight;
  final Value<String?> exerciseKind;
  final Value<String?> catalogStatus;
  final Value<String?> payload;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CatalogExercisesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.difficultyLevel = const Value.absent(),
    this.mechanicsType = const Value.absent(),
    this.forceType = const Value.absent(),
    this.unilateral = const Value.absent(),
    this.bodyweight = const Value.absent(),
    this.exerciseKind = const Value.absent(),
    this.catalogStatus = const Value.absent(),
    this.payload = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogExercisesCompanion.insert({
    required String id,
    this.code = const Value.absent(),
    this.difficultyLevel = const Value.absent(),
    this.mechanicsType = const Value.absent(),
    this.forceType = const Value.absent(),
    this.unilateral = const Value.absent(),
    this.bodyweight = const Value.absent(),
    this.exerciseKind = const Value.absent(),
    this.catalogStatus = const Value.absent(),
    this.payload = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt);
  static Insertable<CatalogExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? difficultyLevel,
    Expression<String>? mechanicsType,
    Expression<String>? forceType,
    Expression<bool>? unilateral,
    Expression<bool>? bodyweight,
    Expression<String>? exerciseKind,
    Expression<String>? catalogStatus,
    Expression<String>? payload,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (difficultyLevel != null) 'difficulty_level': difficultyLevel,
      if (mechanicsType != null) 'mechanics_type': mechanicsType,
      if (forceType != null) 'force_type': forceType,
      if (unilateral != null) 'unilateral': unilateral,
      if (bodyweight != null) 'bodyweight': bodyweight,
      if (exerciseKind != null) 'exercise_kind': exerciseKind,
      if (catalogStatus != null) 'catalog_status': catalogStatus,
      if (payload != null) 'payload': payload,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String?>? difficultyLevel,
    Value<String?>? mechanicsType,
    Value<String?>? forceType,
    Value<bool>? unilateral,
    Value<bool>? bodyweight,
    Value<String?>? exerciseKind,
    Value<String?>? catalogStatus,
    Value<String?>? payload,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CatalogExercisesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      mechanicsType: mechanicsType ?? this.mechanicsType,
      forceType: forceType ?? this.forceType,
      unilateral: unilateral ?? this.unilateral,
      bodyweight: bodyweight ?? this.bodyweight,
      exerciseKind: exerciseKind ?? this.exerciseKind,
      catalogStatus: catalogStatus ?? this.catalogStatus,
      payload: payload ?? this.payload,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (difficultyLevel.present) {
      map['difficulty_level'] = Variable<String>(difficultyLevel.value);
    }
    if (mechanicsType.present) {
      map['mechanics_type'] = Variable<String>(mechanicsType.value);
    }
    if (forceType.present) {
      map['force_type'] = Variable<String>(forceType.value);
    }
    if (unilateral.present) {
      map['unilateral'] = Variable<bool>(unilateral.value);
    }
    if (bodyweight.present) {
      map['bodyweight'] = Variable<bool>(bodyweight.value);
    }
    if (exerciseKind.present) {
      map['exercise_kind'] = Variable<String>(exerciseKind.value);
    }
    if (catalogStatus.present) {
      map['catalog_status'] = Variable<String>(catalogStatus.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogExercisesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('mechanicsType: $mechanicsType, ')
          ..write('forceType: $forceType, ')
          ..write('unilateral: $unilateral, ')
          ..write('bodyweight: $bodyweight, ')
          ..write('exerciseKind: $exerciseKind, ')
          ..write('catalogStatus: $catalogStatus, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalizedTextsTable extends LocalizedTexts
    with TableInfo<$LocalizedTextsTable, LocalizedTextRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalizedTextsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldMeta = const VerificationMeta('field');
  @override
  late final GeneratedColumn<String> field = GeneratedColumn<String>(
    'field',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    entityType,
    entityId,
    field,
    locale,
    value,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'localized_texts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalizedTextRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('field')) {
      context.handle(
        _fieldMeta,
        field.isAcceptableOrUnknown(data['field']!, _fieldMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityType, entityId, field, locale};
  @override
  LocalizedTextRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalizedTextRow(
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      field: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $LocalizedTextsTable createAlias(String alias) {
    return $LocalizedTextsTable(attachedDatabase, alias);
  }
}

class LocalizedTextRow extends DataClass
    implements Insertable<LocalizedTextRow> {
  /// `catalog_exercise`, `custom_exercise`, `muscle`, `equipment`…
  final String entityType;
  final String entityId;

  /// `name`, `description`, `tips`…
  final String field;
  final String locale;
  final String value;
  const LocalizedTextRow({
    required this.entityType,
    required this.entityId,
    required this.field,
    required this.locale,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['field'] = Variable<String>(field);
    map['locale'] = Variable<String>(locale);
    map['value'] = Variable<String>(value);
    return map;
  }

  LocalizedTextsCompanion toCompanion(bool nullToAbsent) {
    return LocalizedTextsCompanion(
      entityType: Value(entityType),
      entityId: Value(entityId),
      field: Value(field),
      locale: Value(locale),
      value: Value(value),
    );
  }

  factory LocalizedTextRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalizedTextRow(
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      field: serializer.fromJson<String>(json['field']),
      locale: serializer.fromJson<String>(json['locale']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'field': serializer.toJson<String>(field),
      'locale': serializer.toJson<String>(locale),
      'value': serializer.toJson<String>(value),
    };
  }

  LocalizedTextRow copyWith({
    String? entityType,
    String? entityId,
    String? field,
    String? locale,
    String? value,
  }) => LocalizedTextRow(
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    field: field ?? this.field,
    locale: locale ?? this.locale,
    value: value ?? this.value,
  );
  LocalizedTextRow copyWithCompanion(LocalizedTextsCompanion data) {
    return LocalizedTextRow(
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      field: data.field.present ? data.field.value : this.field,
      locale: data.locale.present ? data.locale.value : this.locale,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalizedTextRow(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('field: $field, ')
          ..write('locale: $locale, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityType, entityId, field, locale, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalizedTextRow &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.field == this.field &&
          other.locale == this.locale &&
          other.value == this.value);
}

class LocalizedTextsCompanion extends UpdateCompanion<LocalizedTextRow> {
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> field;
  final Value<String> locale;
  final Value<String> value;
  final Value<int> rowid;
  const LocalizedTextsCompanion({
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.field = const Value.absent(),
    this.locale = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalizedTextsCompanion.insert({
    required String entityType,
    required String entityId,
    required String field,
    required String locale,
    required String value,
    this.rowid = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       field = Value(field),
       locale = Value(locale),
       value = Value(value);
  static Insertable<LocalizedTextRow> custom({
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? field,
    Expression<String>? locale,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (field != null) 'field': field,
      if (locale != null) 'locale': locale,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalizedTextsCompanion copyWith({
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? field,
    Value<String>? locale,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return LocalizedTextsCompanion(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      field: field ?? this.field,
      locale: locale ?? this.locale,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (field.present) {
      map['field'] = Variable<String>(field.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalizedTextsCompanion(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('field: $field, ')
          ..write('locale: $locale, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseMusclesTable extends ExerciseMuscles
    with TableInfo<$ExerciseMusclesTable, ExerciseMuscleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseMusclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _muscleIdMeta = const VerificationMeta(
    'muscleId',
  );
  @override
  late final GeneratedColumn<String> muscleId = GeneratedColumn<String>(
    'muscle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _muscleCodeMeta = const VerificationMeta(
    'muscleCode',
  );
  @override
  late final GeneratedColumn<String> muscleCode = GeneratedColumn<String>(
    'muscle_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _involvementMeta = const VerificationMeta(
    'involvement',
  );
  @override
  late final GeneratedColumn<String> involvement = GeneratedColumn<String>(
    'involvement',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    exerciseId,
    muscleId,
    muscleCode,
    involvement,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_muscles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseMuscleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('muscle_id')) {
      context.handle(
        _muscleIdMeta,
        muscleId.isAcceptableOrUnknown(data['muscle_id']!, _muscleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_muscleIdMeta);
    }
    if (data.containsKey('muscle_code')) {
      context.handle(
        _muscleCodeMeta,
        muscleCode.isAcceptableOrUnknown(data['muscle_code']!, _muscleCodeMeta),
      );
    }
    if (data.containsKey('involvement')) {
      context.handle(
        _involvementMeta,
        involvement.isAcceptableOrUnknown(
          data['involvement']!,
          _involvementMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exerciseId, muscleId};
  @override
  ExerciseMuscleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseMuscleRow(
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      muscleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_id'],
      )!,
      muscleCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_code'],
      )!,
      involvement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}involvement'],
      ),
    );
  }

  @override
  $ExerciseMusclesTable createAlias(String alias) {
    return $ExerciseMusclesTable(attachedDatabase, alias);
  }
}

class ExerciseMuscleRow extends DataClass
    implements Insertable<ExerciseMuscleRow> {
  final String exerciseId;
  final String muscleId;
  final String muscleCode;

  /// `primary`, `secondary`, `stabilizer`.
  final String? involvement;
  const ExerciseMuscleRow({
    required this.exerciseId,
    required this.muscleId,
    required this.muscleCode,
    this.involvement,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exercise_id'] = Variable<String>(exerciseId);
    map['muscle_id'] = Variable<String>(muscleId);
    map['muscle_code'] = Variable<String>(muscleCode);
    if (!nullToAbsent || involvement != null) {
      map['involvement'] = Variable<String>(involvement);
    }
    return map;
  }

  ExerciseMusclesCompanion toCompanion(bool nullToAbsent) {
    return ExerciseMusclesCompanion(
      exerciseId: Value(exerciseId),
      muscleId: Value(muscleId),
      muscleCode: Value(muscleCode),
      involvement: involvement == null && nullToAbsent
          ? const Value.absent()
          : Value(involvement),
    );
  }

  factory ExerciseMuscleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseMuscleRow(
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      muscleId: serializer.fromJson<String>(json['muscleId']),
      muscleCode: serializer.fromJson<String>(json['muscleCode']),
      involvement: serializer.fromJson<String?>(json['involvement']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exerciseId': serializer.toJson<String>(exerciseId),
      'muscleId': serializer.toJson<String>(muscleId),
      'muscleCode': serializer.toJson<String>(muscleCode),
      'involvement': serializer.toJson<String?>(involvement),
    };
  }

  ExerciseMuscleRow copyWith({
    String? exerciseId,
    String? muscleId,
    String? muscleCode,
    Value<String?> involvement = const Value.absent(),
  }) => ExerciseMuscleRow(
    exerciseId: exerciseId ?? this.exerciseId,
    muscleId: muscleId ?? this.muscleId,
    muscleCode: muscleCode ?? this.muscleCode,
    involvement: involvement.present ? involvement.value : this.involvement,
  );
  ExerciseMuscleRow copyWithCompanion(ExerciseMusclesCompanion data) {
    return ExerciseMuscleRow(
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      muscleId: data.muscleId.present ? data.muscleId.value : this.muscleId,
      muscleCode: data.muscleCode.present
          ? data.muscleCode.value
          : this.muscleCode,
      involvement: data.involvement.present
          ? data.involvement.value
          : this.involvement,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseMuscleRow(')
          ..write('exerciseId: $exerciseId, ')
          ..write('muscleId: $muscleId, ')
          ..write('muscleCode: $muscleCode, ')
          ..write('involvement: $involvement')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(exerciseId, muscleId, muscleCode, involvement);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseMuscleRow &&
          other.exerciseId == this.exerciseId &&
          other.muscleId == this.muscleId &&
          other.muscleCode == this.muscleCode &&
          other.involvement == this.involvement);
}

class ExerciseMusclesCompanion extends UpdateCompanion<ExerciseMuscleRow> {
  final Value<String> exerciseId;
  final Value<String> muscleId;
  final Value<String> muscleCode;
  final Value<String?> involvement;
  final Value<int> rowid;
  const ExerciseMusclesCompanion({
    this.exerciseId = const Value.absent(),
    this.muscleId = const Value.absent(),
    this.muscleCode = const Value.absent(),
    this.involvement = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseMusclesCompanion.insert({
    required String exerciseId,
    required String muscleId,
    this.muscleCode = const Value.absent(),
    this.involvement = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       muscleId = Value(muscleId);
  static Insertable<ExerciseMuscleRow> custom({
    Expression<String>? exerciseId,
    Expression<String>? muscleId,
    Expression<String>? muscleCode,
    Expression<String>? involvement,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (muscleId != null) 'muscle_id': muscleId,
      if (muscleCode != null) 'muscle_code': muscleCode,
      if (involvement != null) 'involvement': involvement,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseMusclesCompanion copyWith({
    Value<String>? exerciseId,
    Value<String>? muscleId,
    Value<String>? muscleCode,
    Value<String?>? involvement,
    Value<int>? rowid,
  }) {
    return ExerciseMusclesCompanion(
      exerciseId: exerciseId ?? this.exerciseId,
      muscleId: muscleId ?? this.muscleId,
      muscleCode: muscleCode ?? this.muscleCode,
      involvement: involvement ?? this.involvement,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (muscleId.present) {
      map['muscle_id'] = Variable<String>(muscleId.value);
    }
    if (muscleCode.present) {
      map['muscle_code'] = Variable<String>(muscleCode.value);
    }
    if (involvement.present) {
      map['involvement'] = Variable<String>(involvement.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseMusclesCompanion(')
          ..write('exerciseId: $exerciseId, ')
          ..write('muscleId: $muscleId, ')
          ..write('muscleCode: $muscleCode, ')
          ..write('involvement: $involvement, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseEquipmentsTable extends ExerciseEquipments
    with TableInfo<$ExerciseEquipmentsTable, ExerciseEquipmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseEquipmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<String> equipmentId = GeneratedColumn<String>(
    'equipment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentCodeMeta = const VerificationMeta(
    'equipmentCode',
  );
  @override
  late final GeneratedColumn<String> equipmentCode = GeneratedColumn<String>(
    'equipment_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _requiredMeta = const VerificationMeta(
    'required',
  );
  @override
  late final GeneratedColumn<bool> required = GeneratedColumn<bool>(
    'required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("required" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    exerciseId,
    equipmentId,
    equipmentCode,
    required,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_equipments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseEquipmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentIdMeta);
    }
    if (data.containsKey('equipment_code')) {
      context.handle(
        _equipmentCodeMeta,
        equipmentCode.isAcceptableOrUnknown(
          data['equipment_code']!,
          _equipmentCodeMeta,
        ),
      );
    }
    if (data.containsKey('required')) {
      context.handle(
        _requiredMeta,
        required.isAcceptableOrUnknown(data['required']!, _requiredMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exerciseId, equipmentId};
  @override
  ExerciseEquipmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseEquipmentRow(
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_id'],
      )!,
      equipmentCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_code'],
      )!,
      required: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}required'],
      )!,
    );
  }

  @override
  $ExerciseEquipmentsTable createAlias(String alias) {
    return $ExerciseEquipmentsTable(attachedDatabase, alias);
  }
}

class ExerciseEquipmentRow extends DataClass
    implements Insertable<ExerciseEquipmentRow> {
  final String exerciseId;
  final String equipmentId;
  final String equipmentCode;
  final bool required;
  const ExerciseEquipmentRow({
    required this.exerciseId,
    required this.equipmentId,
    required this.equipmentCode,
    required this.required,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exercise_id'] = Variable<String>(exerciseId);
    map['equipment_id'] = Variable<String>(equipmentId);
    map['equipment_code'] = Variable<String>(equipmentCode);
    map['required'] = Variable<bool>(required);
    return map;
  }

  ExerciseEquipmentsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseEquipmentsCompanion(
      exerciseId: Value(exerciseId),
      equipmentId: Value(equipmentId),
      equipmentCode: Value(equipmentCode),
      required: Value(required),
    );
  }

  factory ExerciseEquipmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseEquipmentRow(
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      equipmentId: serializer.fromJson<String>(json['equipmentId']),
      equipmentCode: serializer.fromJson<String>(json['equipmentCode']),
      required: serializer.fromJson<bool>(json['required']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exerciseId': serializer.toJson<String>(exerciseId),
      'equipmentId': serializer.toJson<String>(equipmentId),
      'equipmentCode': serializer.toJson<String>(equipmentCode),
      'required': serializer.toJson<bool>(required),
    };
  }

  ExerciseEquipmentRow copyWith({
    String? exerciseId,
    String? equipmentId,
    String? equipmentCode,
    bool? required,
  }) => ExerciseEquipmentRow(
    exerciseId: exerciseId ?? this.exerciseId,
    equipmentId: equipmentId ?? this.equipmentId,
    equipmentCode: equipmentCode ?? this.equipmentCode,
    required: required ?? this.required,
  );
  ExerciseEquipmentRow copyWithCompanion(ExerciseEquipmentsCompanion data) {
    return ExerciseEquipmentRow(
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
      equipmentCode: data.equipmentCode.present
          ? data.equipmentCode.value
          : this.equipmentCode,
      required: data.required.present ? data.required.value : this.required,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseEquipmentRow(')
          ..write('exerciseId: $exerciseId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('equipmentCode: $equipmentCode, ')
          ..write('required: $required')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(exerciseId, equipmentId, equipmentCode, required);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseEquipmentRow &&
          other.exerciseId == this.exerciseId &&
          other.equipmentId == this.equipmentId &&
          other.equipmentCode == this.equipmentCode &&
          other.required == this.required);
}

class ExerciseEquipmentsCompanion
    extends UpdateCompanion<ExerciseEquipmentRow> {
  final Value<String> exerciseId;
  final Value<String> equipmentId;
  final Value<String> equipmentCode;
  final Value<bool> required;
  final Value<int> rowid;
  const ExerciseEquipmentsCompanion({
    this.exerciseId = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.equipmentCode = const Value.absent(),
    this.required = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseEquipmentsCompanion.insert({
    required String exerciseId,
    required String equipmentId,
    this.equipmentCode = const Value.absent(),
    this.required = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       equipmentId = Value(equipmentId);
  static Insertable<ExerciseEquipmentRow> custom({
    Expression<String>? exerciseId,
    Expression<String>? equipmentId,
    Expression<String>? equipmentCode,
    Expression<bool>? required,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (equipmentCode != null) 'equipment_code': equipmentCode,
      if (required != null) 'required': required,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseEquipmentsCompanion copyWith({
    Value<String>? exerciseId,
    Value<String>? equipmentId,
    Value<String>? equipmentCode,
    Value<bool>? required,
    Value<int>? rowid,
  }) {
    return ExerciseEquipmentsCompanion(
      exerciseId: exerciseId ?? this.exerciseId,
      equipmentId: equipmentId ?? this.equipmentId,
      equipmentCode: equipmentCode ?? this.equipmentCode,
      required: required ?? this.required,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<String>(equipmentId.value);
    }
    if (equipmentCode.present) {
      map['equipment_code'] = Variable<String>(equipmentCode.value);
    }
    if (required.present) {
      map['required'] = Variable<bool>(required.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseEquipmentsCompanion(')
          ..write('exerciseId: $exerciseId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('equipmentCode: $equipmentCode, ')
          ..write('required: $required, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseCategoriesTable extends ExerciseCategories
    with TableInfo<$ExerciseCategoriesTable, ExerciseCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryCodeMeta = const VerificationMeta(
    'categoryCode',
  );
  @override
  late final GeneratedColumn<String> categoryCode = GeneratedColumn<String>(
    'category_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [exerciseId, categoryId, categoryCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_code')) {
      context.handle(
        _categoryCodeMeta,
        categoryCode.isAcceptableOrUnknown(
          data['category_code']!,
          _categoryCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exerciseId, categoryId};
  @override
  ExerciseCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseCategoryRow(
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      categoryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_code'],
      )!,
    );
  }

  @override
  $ExerciseCategoriesTable createAlias(String alias) {
    return $ExerciseCategoriesTable(attachedDatabase, alias);
  }
}

class ExerciseCategoryRow extends DataClass
    implements Insertable<ExerciseCategoryRow> {
  final String exerciseId;
  final String categoryId;
  final String categoryCode;
  const ExerciseCategoryRow({
    required this.exerciseId,
    required this.categoryId,
    required this.categoryCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exercise_id'] = Variable<String>(exerciseId);
    map['category_id'] = Variable<String>(categoryId);
    map['category_code'] = Variable<String>(categoryCode);
    return map;
  }

  ExerciseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExerciseCategoriesCompanion(
      exerciseId: Value(exerciseId),
      categoryId: Value(categoryId),
      categoryCode: Value(categoryCode),
    );
  }

  factory ExerciseCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseCategoryRow(
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryCode: serializer.fromJson<String>(json['categoryCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exerciseId': serializer.toJson<String>(exerciseId),
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryCode': serializer.toJson<String>(categoryCode),
    };
  }

  ExerciseCategoryRow copyWith({
    String? exerciseId,
    String? categoryId,
    String? categoryCode,
  }) => ExerciseCategoryRow(
    exerciseId: exerciseId ?? this.exerciseId,
    categoryId: categoryId ?? this.categoryId,
    categoryCode: categoryCode ?? this.categoryCode,
  );
  ExerciseCategoryRow copyWithCompanion(ExerciseCategoriesCompanion data) {
    return ExerciseCategoryRow(
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categoryCode: data.categoryCode.present
          ? data.categoryCode.value
          : this.categoryCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseCategoryRow(')
          ..write('exerciseId: $exerciseId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryCode: $categoryCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(exerciseId, categoryId, categoryCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseCategoryRow &&
          other.exerciseId == this.exerciseId &&
          other.categoryId == this.categoryId &&
          other.categoryCode == this.categoryCode);
}

class ExerciseCategoriesCompanion extends UpdateCompanion<ExerciseCategoryRow> {
  final Value<String> exerciseId;
  final Value<String> categoryId;
  final Value<String> categoryCode;
  final Value<int> rowid;
  const ExerciseCategoriesCompanion({
    this.exerciseId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseCategoriesCompanion.insert({
    required String exerciseId,
    required String categoryId,
    this.categoryCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       categoryId = Value(categoryId);
  static Insertable<ExerciseCategoryRow> custom({
    Expression<String>? exerciseId,
    Expression<String>? categoryId,
    Expression<String>? categoryCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryCode != null) 'category_code': categoryCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseCategoriesCompanion copyWith({
    Value<String>? exerciseId,
    Value<String>? categoryId,
    Value<String>? categoryCode,
    Value<int>? rowid,
  }) {
    return ExerciseCategoriesCompanion(
      exerciseId: exerciseId ?? this.exerciseId,
      categoryId: categoryId ?? this.categoryId,
      categoryCode: categoryCode ?? this.categoryCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryCode.present) {
      map['category_code'] = Variable<String>(categoryCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseCategoriesCompanion(')
          ..write('exerciseId: $exerciseId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogMetaTable extends CatalogMeta
    with TableInfo<$CatalogMetaTable, CatalogMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _appliedAtMeta = const VerificationMeta(
    'appliedAt',
  );
  @override
  late final GeneratedColumn<DateTime> appliedAt = GeneratedColumn<DateTime>(
    'applied_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, version, appliedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogMetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('applied_at')) {
      context.handle(
        _appliedAtMeta,
        appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogMetaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      appliedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}applied_at'],
      ),
    );
  }

  @override
  $CatalogMetaTable createAlias(String alias) {
    return $CatalogMetaTable(attachedDatabase, alias);
  }
}

class CatalogMetaRow extends DataClass implements Insertable<CatalogMetaRow> {
  final int id;
  final int version;
  final DateTime? appliedAt;
  const CatalogMetaRow({
    required this.id,
    required this.version,
    this.appliedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || appliedAt != null) {
      map['applied_at'] = Variable<DateTime>(appliedAt);
    }
    return map;
  }

  CatalogMetaCompanion toCompanion(bool nullToAbsent) {
    return CatalogMetaCompanion(
      id: Value(id),
      version: Value(version),
      appliedAt: appliedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(appliedAt),
    );
  }

  factory CatalogMetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogMetaRow(
      id: serializer.fromJson<int>(json['id']),
      version: serializer.fromJson<int>(json['version']),
      appliedAt: serializer.fromJson<DateTime?>(json['appliedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'version': serializer.toJson<int>(version),
      'appliedAt': serializer.toJson<DateTime?>(appliedAt),
    };
  }

  CatalogMetaRow copyWith({
    int? id,
    int? version,
    Value<DateTime?> appliedAt = const Value.absent(),
  }) => CatalogMetaRow(
    id: id ?? this.id,
    version: version ?? this.version,
    appliedAt: appliedAt.present ? appliedAt.value : this.appliedAt,
  );
  CatalogMetaRow copyWithCompanion(CatalogMetaCompanion data) {
    return CatalogMetaRow(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogMetaRow(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('appliedAt: $appliedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, version, appliedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogMetaRow &&
          other.id == this.id &&
          other.version == this.version &&
          other.appliedAt == this.appliedAt);
}

class CatalogMetaCompanion extends UpdateCompanion<CatalogMetaRow> {
  final Value<int> id;
  final Value<int> version;
  final Value<DateTime?> appliedAt;
  const CatalogMetaCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.appliedAt = const Value.absent(),
  });
  CatalogMetaCompanion.insert({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.appliedAt = const Value.absent(),
  });
  static Insertable<CatalogMetaRow> custom({
    Expression<int>? id,
    Expression<int>? version,
    Expression<DateTime>? appliedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (appliedAt != null) 'applied_at': appliedAt,
    });
  }

  CatalogMetaCompanion copyWith({
    Value<int>? id,
    Value<int>? version,
    Value<DateTime?>? appliedAt,
  }) {
    return CatalogMetaCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<DateTime>(appliedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogMetaCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('appliedAt: $appliedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomExercisesTable extends CustomExercises
    with TableInfo<$CustomExercisesTable, CustomExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyLevelMeta = const VerificationMeta(
    'difficultyLevel',
  );
  @override
  late final GeneratedColumn<String> difficultyLevel = GeneratedColumn<String>(
    'difficulty_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mechanicsTypeMeta = const VerificationMeta(
    'mechanicsType',
  );
  @override
  late final GeneratedColumn<String> mechanicsType = GeneratedColumn<String>(
    'mechanics_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _forceTypeMeta = const VerificationMeta(
    'forceType',
  );
  @override
  late final GeneratedColumn<String> forceType = GeneratedColumn<String>(
    'force_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unilateralMeta = const VerificationMeta(
    'unilateral',
  );
  @override
  late final GeneratedColumn<bool> unilateral = GeneratedColumn<bool>(
    'unilateral',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("unilateral" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _bodyweightMeta = const VerificationMeta(
    'bodyweight',
  );
  @override
  late final GeneratedColumn<bool> bodyweight = GeneratedColumn<bool>(
    'bodyweight',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bodyweight" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    difficultyLevel,
    mechanicsType,
    forceType,
    unilateral,
    bodyweight,
    payload,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('difficulty_level')) {
      context.handle(
        _difficultyLevelMeta,
        difficultyLevel.isAcceptableOrUnknown(
          data['difficulty_level']!,
          _difficultyLevelMeta,
        ),
      );
    }
    if (data.containsKey('mechanics_type')) {
      context.handle(
        _mechanicsTypeMeta,
        mechanicsType.isAcceptableOrUnknown(
          data['mechanics_type']!,
          _mechanicsTypeMeta,
        ),
      );
    }
    if (data.containsKey('force_type')) {
      context.handle(
        _forceTypeMeta,
        forceType.isAcceptableOrUnknown(data['force_type']!, _forceTypeMeta),
      );
    }
    if (data.containsKey('unilateral')) {
      context.handle(
        _unilateralMeta,
        unilateral.isAcceptableOrUnknown(data['unilateral']!, _unilateralMeta),
      );
    }
    if (data.containsKey('bodyweight')) {
      context.handle(
        _bodyweightMeta,
        bodyweight.isAcceptableOrUnknown(data['bodyweight']!, _bodyweightMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      difficultyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty_level'],
      ),
      mechanicsType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mechanics_type'],
      ),
      forceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}force_type'],
      ),
      unilateral: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}unilateral'],
      )!,
      bodyweight: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bodyweight'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $CustomExercisesTable createAlias(String alias) {
    return $CustomExercisesTable(attachedDatabase, alias);
  }
}

class CustomExerciseRow extends DataClass
    implements Insertable<CustomExerciseRow> {
  final String id;
  final String? difficultyLevel;
  final String? mechanicsType;
  final String? forceType;
  final bool unilateral;
  final bool bodyweight;
  final String? payload;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Soft delete: la riga resta finché la cancellazione non è salita.
  final DateTime? deletedAt;
  const CustomExerciseRow({
    required this.id,
    this.difficultyLevel,
    this.mechanicsType,
    this.forceType,
    required this.unilateral,
    required this.bodyweight,
    this.payload,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || difficultyLevel != null) {
      map['difficulty_level'] = Variable<String>(difficultyLevel);
    }
    if (!nullToAbsent || mechanicsType != null) {
      map['mechanics_type'] = Variable<String>(mechanicsType);
    }
    if (!nullToAbsent || forceType != null) {
      map['force_type'] = Variable<String>(forceType);
    }
    map['unilateral'] = Variable<bool>(unilateral);
    map['bodyweight'] = Variable<bool>(bodyweight);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CustomExercisesCompanion toCompanion(bool nullToAbsent) {
    return CustomExercisesCompanion(
      id: Value(id),
      difficultyLevel: difficultyLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(difficultyLevel),
      mechanicsType: mechanicsType == null && nullToAbsent
          ? const Value.absent()
          : Value(mechanicsType),
      forceType: forceType == null && nullToAbsent
          ? const Value.absent()
          : Value(forceType),
      unilateral: Value(unilateral),
      bodyweight: Value(bodyweight),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory CustomExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      difficultyLevel: serializer.fromJson<String?>(json['difficultyLevel']),
      mechanicsType: serializer.fromJson<String?>(json['mechanicsType']),
      forceType: serializer.fromJson<String?>(json['forceType']),
      unilateral: serializer.fromJson<bool>(json['unilateral']),
      bodyweight: serializer.fromJson<bool>(json['bodyweight']),
      payload: serializer.fromJson<String?>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'difficultyLevel': serializer.toJson<String?>(difficultyLevel),
      'mechanicsType': serializer.toJson<String?>(mechanicsType),
      'forceType': serializer.toJson<String?>(forceType),
      'unilateral': serializer.toJson<bool>(unilateral),
      'bodyweight': serializer.toJson<bool>(bodyweight),
      'payload': serializer.toJson<String?>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  CustomExerciseRow copyWith({
    String? id,
    Value<String?> difficultyLevel = const Value.absent(),
    Value<String?> mechanicsType = const Value.absent(),
    Value<String?> forceType = const Value.absent(),
    bool? unilateral,
    bool? bodyweight,
    Value<String?> payload = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => CustomExerciseRow(
    id: id ?? this.id,
    difficultyLevel: difficultyLevel.present
        ? difficultyLevel.value
        : this.difficultyLevel,
    mechanicsType: mechanicsType.present
        ? mechanicsType.value
        : this.mechanicsType,
    forceType: forceType.present ? forceType.value : this.forceType,
    unilateral: unilateral ?? this.unilateral,
    bodyweight: bodyweight ?? this.bodyweight,
    payload: payload.present ? payload.value : this.payload,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  CustomExerciseRow copyWithCompanion(CustomExercisesCompanion data) {
    return CustomExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      difficultyLevel: data.difficultyLevel.present
          ? data.difficultyLevel.value
          : this.difficultyLevel,
      mechanicsType: data.mechanicsType.present
          ? data.mechanicsType.value
          : this.mechanicsType,
      forceType: data.forceType.present ? data.forceType.value : this.forceType,
      unilateral: data.unilateral.present
          ? data.unilateral.value
          : this.unilateral,
      bodyweight: data.bodyweight.present
          ? data.bodyweight.value
          : this.bodyweight,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomExerciseRow(')
          ..write('id: $id, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('mechanicsType: $mechanicsType, ')
          ..write('forceType: $forceType, ')
          ..write('unilateral: $unilateral, ')
          ..write('bodyweight: $bodyweight, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    difficultyLevel,
    mechanicsType,
    forceType,
    unilateral,
    bodyweight,
    payload,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomExerciseRow &&
          other.id == this.id &&
          other.difficultyLevel == this.difficultyLevel &&
          other.mechanicsType == this.mechanicsType &&
          other.forceType == this.forceType &&
          other.unilateral == this.unilateral &&
          other.bodyweight == this.bodyweight &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CustomExercisesCompanion extends UpdateCompanion<CustomExerciseRow> {
  final Value<String> id;
  final Value<String?> difficultyLevel;
  final Value<String?> mechanicsType;
  final Value<String?> forceType;
  final Value<bool> unilateral;
  final Value<bool> bodyweight;
  final Value<String?> payload;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const CustomExercisesCompanion({
    this.id = const Value.absent(),
    this.difficultyLevel = const Value.absent(),
    this.mechanicsType = const Value.absent(),
    this.forceType = const Value.absent(),
    this.unilateral = const Value.absent(),
    this.bodyweight = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomExercisesCompanion.insert({
    required String id,
    this.difficultyLevel = const Value.absent(),
    this.mechanicsType = const Value.absent(),
    this.forceType = const Value.absent(),
    this.unilateral = const Value.absent(),
    this.bodyweight = const Value.absent(),
    this.payload = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CustomExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? difficultyLevel,
    Expression<String>? mechanicsType,
    Expression<String>? forceType,
    Expression<bool>? unilateral,
    Expression<bool>? bodyweight,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (difficultyLevel != null) 'difficulty_level': difficultyLevel,
      if (mechanicsType != null) 'mechanics_type': mechanicsType,
      if (forceType != null) 'force_type': forceType,
      if (unilateral != null) 'unilateral': unilateral,
      if (bodyweight != null) 'bodyweight': bodyweight,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomExercisesCompanion copyWith({
    Value<String>? id,
    Value<String?>? difficultyLevel,
    Value<String?>? mechanicsType,
    Value<String?>? forceType,
    Value<bool>? unilateral,
    Value<bool>? bodyweight,
    Value<String?>? payload,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return CustomExercisesCompanion(
      id: id ?? this.id,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      mechanicsType: mechanicsType ?? this.mechanicsType,
      forceType: forceType ?? this.forceType,
      unilateral: unilateral ?? this.unilateral,
      bodyweight: bodyweight ?? this.bodyweight,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (difficultyLevel.present) {
      map['difficulty_level'] = Variable<String>(difficultyLevel.value);
    }
    if (mechanicsType.present) {
      map['mechanics_type'] = Variable<String>(mechanicsType.value);
    }
    if (forceType.present) {
      map['force_type'] = Variable<String>(forceType.value);
    }
    if (unilateral.present) {
      map['unilateral'] = Variable<bool>(unilateral.value);
    }
    if (bodyweight.present) {
      map['bodyweight'] = Variable<bool>(bodyweight.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomExercisesCompanion(')
          ..write('id: $id, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('mechanicsType: $mechanicsType, ')
          ..write('forceType: $forceType, ')
          ..write('unilateral: $unilateral, ')
          ..write('bodyweight: $bodyweight, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts
    with TableInfo<$WorkoutsTable, WorkoutRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (origin IN (\'user\',\'assigned\')) NOT NULL DEFAULT \'user\'',
    defaultValue: const CustomExpression('\'user\''),
  );
  static const VerificationMeta _sourceProgramIdMeta = const VerificationMeta(
    'sourceProgramId',
  );
  @override
  late final GeneratedColumn<String> sourceProgramId = GeneratedColumn<String>(
    'source_program_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sessionsCountMeta = const VerificationMeta(
    'sessionsCount',
  );
  @override
  late final GeneratedColumn<int> sessionsCount = GeneratedColumn<int>(
    'sessions_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUsedMeta = const VerificationMeta(
    'lastUsed',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsed = GeneratedColumn<DateTime>(
    'last_used',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    origin,
    sourceProgramId,
    goal,
    durationMinutes,
    sessionsCount,
    progress,
    active,
    archived,
    dirty,
    payload,
    lastUsed,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    }
    if (data.containsKey('source_program_id')) {
      context.handle(
        _sourceProgramIdMeta,
        sourceProgramId.isAcceptableOrUnknown(
          data['source_program_id']!,
          _sourceProgramIdMeta,
        ),
      );
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sessions_count')) {
      context.handle(
        _sessionsCountMeta,
        sessionsCount.isAcceptableOrUnknown(
          data['sessions_count']!,
          _sessionsCountMeta,
        ),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('last_used')) {
      context.handle(
        _lastUsedMeta,
        lastUsed.isAcceptableOrUnknown(data['last_used']!, _lastUsedMeta),
      );
    } else if (isInserting) {
      context.missing(_lastUsedMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      sourceProgramId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_program_id'],
      ),
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      sessionsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sessions_count'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      lastUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class WorkoutRow extends DataClass implements Insertable<WorkoutRow> {
  final String id;

  /// Il vincolo è dichiarato solo come `customConstraint`: dichiararlo anche
  /// con `withDefault` farebbe vincere il custom e ignorare l'altro in
  /// silenzio.
  final String origin;
  final String? sourceProgramId;
  final String? goal;
  final int durationMinutes;
  final int sessionsCount;
  final double progress;
  final bool active;
  final bool archived;

  /// La scheda ha modifiche locali non ancora salite.
  final bool dirty;

  /// Il payload completo della scheda, come arriva da `/workouts/user`.
  final String? payload;
  final DateTime lastUsed;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const WorkoutRow({
    required this.id,
    required this.origin,
    this.sourceProgramId,
    this.goal,
    required this.durationMinutes,
    required this.sessionsCount,
    required this.progress,
    required this.active,
    required this.archived,
    required this.dirty,
    this.payload,
    required this.lastUsed,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['origin'] = Variable<String>(origin);
    if (!nullToAbsent || sourceProgramId != null) {
      map['source_program_id'] = Variable<String>(sourceProgramId);
    }
    if (!nullToAbsent || goal != null) {
      map['goal'] = Variable<String>(goal);
    }
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['sessions_count'] = Variable<int>(sessionsCount);
    map['progress'] = Variable<double>(progress);
    map['active'] = Variable<bool>(active);
    map['archived'] = Variable<bool>(archived);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['last_used'] = Variable<DateTime>(lastUsed);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      origin: Value(origin),
      sourceProgramId: sourceProgramId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceProgramId),
      goal: goal == null && nullToAbsent ? const Value.absent() : Value(goal),
      durationMinutes: Value(durationMinutes),
      sessionsCount: Value(sessionsCount),
      progress: Value(progress),
      active: Value(active),
      archived: Value(archived),
      dirty: Value(dirty),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      lastUsed: Value(lastUsed),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory WorkoutRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutRow(
      id: serializer.fromJson<String>(json['id']),
      origin: serializer.fromJson<String>(json['origin']),
      sourceProgramId: serializer.fromJson<String?>(json['sourceProgramId']),
      goal: serializer.fromJson<String?>(json['goal']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      sessionsCount: serializer.fromJson<int>(json['sessionsCount']),
      progress: serializer.fromJson<double>(json['progress']),
      active: serializer.fromJson<bool>(json['active']),
      archived: serializer.fromJson<bool>(json['archived']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      payload: serializer.fromJson<String?>(json['payload']),
      lastUsed: serializer.fromJson<DateTime>(json['lastUsed']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'origin': serializer.toJson<String>(origin),
      'sourceProgramId': serializer.toJson<String?>(sourceProgramId),
      'goal': serializer.toJson<String?>(goal),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'sessionsCount': serializer.toJson<int>(sessionsCount),
      'progress': serializer.toJson<double>(progress),
      'active': serializer.toJson<bool>(active),
      'archived': serializer.toJson<bool>(archived),
      'dirty': serializer.toJson<bool>(dirty),
      'payload': serializer.toJson<String?>(payload),
      'lastUsed': serializer.toJson<DateTime>(lastUsed),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  WorkoutRow copyWith({
    String? id,
    String? origin,
    Value<String?> sourceProgramId = const Value.absent(),
    Value<String?> goal = const Value.absent(),
    int? durationMinutes,
    int? sessionsCount,
    double? progress,
    bool? active,
    bool? archived,
    bool? dirty,
    Value<String?> payload = const Value.absent(),
    DateTime? lastUsed,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => WorkoutRow(
    id: id ?? this.id,
    origin: origin ?? this.origin,
    sourceProgramId: sourceProgramId.present
        ? sourceProgramId.value
        : this.sourceProgramId,
    goal: goal.present ? goal.value : this.goal,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    sessionsCount: sessionsCount ?? this.sessionsCount,
    progress: progress ?? this.progress,
    active: active ?? this.active,
    archived: archived ?? this.archived,
    dirty: dirty ?? this.dirty,
    payload: payload.present ? payload.value : this.payload,
    lastUsed: lastUsed ?? this.lastUsed,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  WorkoutRow copyWithCompanion(WorkoutsCompanion data) {
    return WorkoutRow(
      id: data.id.present ? data.id.value : this.id,
      origin: data.origin.present ? data.origin.value : this.origin,
      sourceProgramId: data.sourceProgramId.present
          ? data.sourceProgramId.value
          : this.sourceProgramId,
      goal: data.goal.present ? data.goal.value : this.goal,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      sessionsCount: data.sessionsCount.present
          ? data.sessionsCount.value
          : this.sessionsCount,
      progress: data.progress.present ? data.progress.value : this.progress,
      active: data.active.present ? data.active.value : this.active,
      archived: data.archived.present ? data.archived.value : this.archived,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      payload: data.payload.present ? data.payload.value : this.payload,
      lastUsed: data.lastUsed.present ? data.lastUsed.value : this.lastUsed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutRow(')
          ..write('id: $id, ')
          ..write('origin: $origin, ')
          ..write('sourceProgramId: $sourceProgramId, ')
          ..write('goal: $goal, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('sessionsCount: $sessionsCount, ')
          ..write('progress: $progress, ')
          ..write('active: $active, ')
          ..write('archived: $archived, ')
          ..write('dirty: $dirty, ')
          ..write('payload: $payload, ')
          ..write('lastUsed: $lastUsed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    origin,
    sourceProgramId,
    goal,
    durationMinutes,
    sessionsCount,
    progress,
    active,
    archived,
    dirty,
    payload,
    lastUsed,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutRow &&
          other.id == this.id &&
          other.origin == this.origin &&
          other.sourceProgramId == this.sourceProgramId &&
          other.goal == this.goal &&
          other.durationMinutes == this.durationMinutes &&
          other.sessionsCount == this.sessionsCount &&
          other.progress == this.progress &&
          other.active == this.active &&
          other.archived == this.archived &&
          other.dirty == this.dirty &&
          other.payload == this.payload &&
          other.lastUsed == this.lastUsed &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class WorkoutsCompanion extends UpdateCompanion<WorkoutRow> {
  final Value<String> id;
  final Value<String> origin;
  final Value<String?> sourceProgramId;
  final Value<String?> goal;
  final Value<int> durationMinutes;
  final Value<int> sessionsCount;
  final Value<double> progress;
  final Value<bool> active;
  final Value<bool> archived;
  final Value<bool> dirty;
  final Value<String?> payload;
  final Value<DateTime> lastUsed;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.origin = const Value.absent(),
    this.sourceProgramId = const Value.absent(),
    this.goal = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.sessionsCount = const Value.absent(),
    this.progress = const Value.absent(),
    this.active = const Value.absent(),
    this.archived = const Value.absent(),
    this.dirty = const Value.absent(),
    this.payload = const Value.absent(),
    this.lastUsed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    required String id,
    this.origin = const Value.absent(),
    this.sourceProgramId = const Value.absent(),
    this.goal = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.sessionsCount = const Value.absent(),
    this.progress = const Value.absent(),
    this.active = const Value.absent(),
    this.archived = const Value.absent(),
    this.dirty = const Value.absent(),
    this.payload = const Value.absent(),
    required DateTime lastUsed,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lastUsed = Value(lastUsed),
       updatedAt = Value(updatedAt);
  static Insertable<WorkoutRow> custom({
    Expression<String>? id,
    Expression<String>? origin,
    Expression<String>? sourceProgramId,
    Expression<String>? goal,
    Expression<int>? durationMinutes,
    Expression<int>? sessionsCount,
    Expression<double>? progress,
    Expression<bool>? active,
    Expression<bool>? archived,
    Expression<bool>? dirty,
    Expression<String>? payload,
    Expression<DateTime>? lastUsed,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (origin != null) 'origin': origin,
      if (sourceProgramId != null) 'source_program_id': sourceProgramId,
      if (goal != null) 'goal': goal,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (sessionsCount != null) 'sessions_count': sessionsCount,
      if (progress != null) 'progress': progress,
      if (active != null) 'active': active,
      if (archived != null) 'archived': archived,
      if (dirty != null) 'dirty': dirty,
      if (payload != null) 'payload': payload,
      if (lastUsed != null) 'last_used': lastUsed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsCompanion copyWith({
    Value<String>? id,
    Value<String>? origin,
    Value<String?>? sourceProgramId,
    Value<String?>? goal,
    Value<int>? durationMinutes,
    Value<int>? sessionsCount,
    Value<double>? progress,
    Value<bool>? active,
    Value<bool>? archived,
    Value<bool>? dirty,
    Value<String?>? payload,
    Value<DateTime>? lastUsed,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      origin: origin ?? this.origin,
      sourceProgramId: sourceProgramId ?? this.sourceProgramId,
      goal: goal ?? this.goal,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      progress: progress ?? this.progress,
      active: active ?? this.active,
      archived: archived ?? this.archived,
      dirty: dirty ?? this.dirty,
      payload: payload ?? this.payload,
      lastUsed: lastUsed ?? this.lastUsed,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (sourceProgramId.present) {
      map['source_program_id'] = Variable<String>(sourceProgramId.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (sessionsCount.present) {
      map['sessions_count'] = Variable<int>(sessionsCount.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (lastUsed.present) {
      map['last_used'] = Variable<DateTime>(lastUsed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('origin: $origin, ')
          ..write('sourceProgramId: $sourceProgramId, ')
          ..write('goal: $goal, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('sessionsCount: $sessionsCount, ')
          ..write('progress: $progress, ')
          ..write('active: $active, ')
          ..write('archived: $archived, ')
          ..write('dirty: $dirty, ')
          ..write('payload: $payload, ')
          ..write('lastUsed: $lastUsed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSnapshotsTable extends WorkoutSnapshots
    with TableInfo<$WorkoutSnapshotsTable, WorkoutSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commandJsonMeta = const VerificationMeta(
    'commandJson',
  );
  @override
  late final GeneratedColumn<String> commandJson = GeneratedColumn<String>(
    'command_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUpdatedAtMeta = const VerificationMeta(
    'sourceUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> sourceUpdatedAt =
      GeneratedColumn<DateTime>(
        'source_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    workoutId,
    commandJson,
    sourceUpdatedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('command_json')) {
      context.handle(
        _commandJsonMeta,
        commandJson.isAcceptableOrUnknown(
          data['command_json']!,
          _commandJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commandJsonMeta);
    }
    if (data.containsKey('source_updated_at')) {
      context.handle(
        _sourceUpdatedAtMeta,
        sourceUpdatedAt.isAcceptableOrUnknown(
          data['source_updated_at']!,
          _sourceUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceUpdatedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workoutId};
  @override
  WorkoutSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSnapshotRow(
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      commandJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command_json'],
      )!,
      sourceUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}source_updated_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkoutSnapshotsTable createAlias(String alias) {
    return $WorkoutSnapshotsTable(attachedDatabase, alias);
  }
}

class WorkoutSnapshotRow extends DataClass
    implements Insertable<WorkoutSnapshotRow> {
  final String workoutId;
  final String commandJson;
  final DateTime sourceUpdatedAt;
  final DateTime updatedAt;
  const WorkoutSnapshotRow({
    required this.workoutId,
    required this.commandJson,
    required this.sourceUpdatedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['workout_id'] = Variable<String>(workoutId);
    map['command_json'] = Variable<String>(commandJson);
    map['source_updated_at'] = Variable<DateTime>(sourceUpdatedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkoutSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSnapshotsCompanion(
      workoutId: Value(workoutId),
      commandJson: Value(commandJson),
      sourceUpdatedAt: Value(sourceUpdatedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkoutSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSnapshotRow(
      workoutId: serializer.fromJson<String>(json['workoutId']),
      commandJson: serializer.fromJson<String>(json['commandJson']),
      sourceUpdatedAt: serializer.fromJson<DateTime>(json['sourceUpdatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workoutId': serializer.toJson<String>(workoutId),
      'commandJson': serializer.toJson<String>(commandJson),
      'sourceUpdatedAt': serializer.toJson<DateTime>(sourceUpdatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkoutSnapshotRow copyWith({
    String? workoutId,
    String? commandJson,
    DateTime? sourceUpdatedAt,
    DateTime? updatedAt,
  }) => WorkoutSnapshotRow(
    workoutId: workoutId ?? this.workoutId,
    commandJson: commandJson ?? this.commandJson,
    sourceUpdatedAt: sourceUpdatedAt ?? this.sourceUpdatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkoutSnapshotRow copyWithCompanion(WorkoutSnapshotsCompanion data) {
    return WorkoutSnapshotRow(
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      commandJson: data.commandJson.present
          ? data.commandJson.value
          : this.commandJson,
      sourceUpdatedAt: data.sourceUpdatedAt.present
          ? data.sourceUpdatedAt.value
          : this.sourceUpdatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSnapshotRow(')
          ..write('workoutId: $workoutId, ')
          ..write('commandJson: $commandJson, ')
          ..write('sourceUpdatedAt: $sourceUpdatedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(workoutId, commandJson, sourceUpdatedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSnapshotRow &&
          other.workoutId == this.workoutId &&
          other.commandJson == this.commandJson &&
          other.sourceUpdatedAt == this.sourceUpdatedAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutSnapshotsCompanion extends UpdateCompanion<WorkoutSnapshotRow> {
  final Value<String> workoutId;
  final Value<String> commandJson;
  final Value<DateTime> sourceUpdatedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkoutSnapshotsCompanion({
    this.workoutId = const Value.absent(),
    this.commandJson = const Value.absent(),
    this.sourceUpdatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSnapshotsCompanion.insert({
    required String workoutId,
    required String commandJson,
    required DateTime sourceUpdatedAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : workoutId = Value(workoutId),
       commandJson = Value(commandJson),
       sourceUpdatedAt = Value(sourceUpdatedAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkoutSnapshotRow> custom({
    Expression<String>? workoutId,
    Expression<String>? commandJson,
    Expression<DateTime>? sourceUpdatedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workoutId != null) 'workout_id': workoutId,
      if (commandJson != null) 'command_json': commandJson,
      if (sourceUpdatedAt != null) 'source_updated_at': sourceUpdatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSnapshotsCompanion copyWith({
    Value<String>? workoutId,
    Value<String>? commandJson,
    Value<DateTime>? sourceUpdatedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSnapshotsCompanion(
      workoutId: workoutId ?? this.workoutId,
      commandJson: commandJson ?? this.commandJson,
      sourceUpdatedAt: sourceUpdatedAt ?? this.sourceUpdatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (commandJson.present) {
      map['command_json'] = Variable<String>(commandJson.value);
    }
    if (sourceUpdatedAt.present) {
      map['source_updated_at'] = Variable<DateTime>(sourceUpdatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSnapshotsCompanion(')
          ..write('workoutId: $workoutId, ')
          ..write('commandJson: $commandJson, ')
          ..write('sourceUpdatedAt: $sourceUpdatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActiveWorkoutDraftsTable extends ActiveWorkoutDrafts
    with TableInfo<$ActiveWorkoutDraftsTable, ActiveWorkoutDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveWorkoutDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [workoutId, payload, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_workout_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveWorkoutDraftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workoutId};
  @override
  ActiveWorkoutDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveWorkoutDraftRow(
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActiveWorkoutDraftsTable createAlias(String alias) {
    return $ActiveWorkoutDraftsTable(attachedDatabase, alias);
  }
}

class ActiveWorkoutDraftRow extends DataClass
    implements Insertable<ActiveWorkoutDraftRow> {
  final String workoutId;
  final String payload;
  final DateTime updatedAt;
  const ActiveWorkoutDraftRow({
    required this.workoutId,
    required this.payload,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['workout_id'] = Variable<String>(workoutId);
    map['payload'] = Variable<String>(payload);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActiveWorkoutDraftsCompanion toCompanion(bool nullToAbsent) {
    return ActiveWorkoutDraftsCompanion(
      workoutId: Value(workoutId),
      payload: Value(payload),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActiveWorkoutDraftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveWorkoutDraftRow(
      workoutId: serializer.fromJson<String>(json['workoutId']),
      payload: serializer.fromJson<String>(json['payload']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workoutId': serializer.toJson<String>(workoutId),
      'payload': serializer.toJson<String>(payload),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ActiveWorkoutDraftRow copyWith({
    String? workoutId,
    String? payload,
    DateTime? updatedAt,
  }) => ActiveWorkoutDraftRow(
    workoutId: workoutId ?? this.workoutId,
    payload: payload ?? this.payload,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActiveWorkoutDraftRow copyWithCompanion(ActiveWorkoutDraftsCompanion data) {
    return ActiveWorkoutDraftRow(
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      payload: data.payload.present ? data.payload.value : this.payload,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveWorkoutDraftRow(')
          ..write('workoutId: $workoutId, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workoutId, payload, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveWorkoutDraftRow &&
          other.workoutId == this.workoutId &&
          other.payload == this.payload &&
          other.updatedAt == this.updatedAt);
}

class ActiveWorkoutDraftsCompanion
    extends UpdateCompanion<ActiveWorkoutDraftRow> {
  final Value<String> workoutId;
  final Value<String> payload;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ActiveWorkoutDraftsCompanion({
    this.workoutId = const Value.absent(),
    this.payload = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveWorkoutDraftsCompanion.insert({
    required String workoutId,
    required String payload,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : workoutId = Value(workoutId),
       payload = Value(payload),
       updatedAt = Value(updatedAt);
  static Insertable<ActiveWorkoutDraftRow> custom({
    Expression<String>? workoutId,
    Expression<String>? payload,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workoutId != null) 'workout_id': workoutId,
      if (payload != null) 'payload': payload,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveWorkoutDraftsCompanion copyWith({
    Value<String>? workoutId,
    Value<String>? payload,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ActiveWorkoutDraftsCompanion(
      workoutId: workoutId ?? this.workoutId,
      payload: payload ?? this.payload,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveWorkoutDraftsCompanion(')
          ..write('workoutId: $workoutId, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    status,
    payload,
    startedAt,
    completedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionRow extends DataClass implements Insertable<SessionRow> {
  final String id;
  final String workoutId;
  final String status;
  final String? payload;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SessionRow({
    required this.id,
    required this.workoutId,
    required this.status,
    this.payload,
    this.startedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      status: Value(status),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRow(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      status: serializer.fromJson<String>(json['status']),
      payload: serializer.fromJson<String?>(json['payload']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'status': serializer.toJson<String>(status),
      'payload': serializer.toJson<String?>(payload),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SessionRow copyWith({
    String? id,
    String? workoutId,
    String? status,
    Value<String?> payload = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SessionRow(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    status: status ?? this.status,
    payload: payload.present ? payload.value : this.payload,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SessionRow copyWithCompanion(SessionsCompanion data) {
    return SessionRow(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      status: data.status.present ? data.status.value : this.status,
      payload: data.payload.present ? data.payload.value : this.payload,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRow(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('status: $status, ')
          ..write('payload: $payload, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutId,
    status,
    payload,
    startedAt,
    completedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRow &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.status == this.status &&
          other.payload == this.payload &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SessionsCompanion extends UpdateCompanion<SessionRow> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<String> status;
  final Value<String?> payload;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.status = const Value.absent(),
    this.payload = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String workoutId,
    this.status = const Value.absent(),
    this.payload = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutId = Value(workoutId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SessionRow> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<String>? status,
    Expression<String>? payload,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (status != null) 'status': status,
      if (payload != null) 'payload': payload,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutId,
    Value<String>? status,
    Value<String?>? payload,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      status: status ?? this.status,
      payload: payload ?? this.payload,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('status: $status, ')
          ..write('payload: $payload, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secondaryPayloadMeta = const VerificationMeta(
    'secondaryPayload',
  );
  @override
  late final GeneratedColumn<String> secondaryPayload = GeneratedColumn<String>(
    'secondary_payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payload,
    secondaryPayload,
    status,
    attempts,
    nextAttemptAt,
    lastError,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('secondary_payload')) {
      context.handle(
        _secondaryPayloadMeta,
        secondaryPayload.isAcceptableOrUnknown(
          data['secondary_payload']!,
          _secondaryPayloadMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      secondaryPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_payload'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  final String id;

  /// `session`, `workout`, `custom_exercise`…
  final String entityType;
  final String entityId;

  /// `create`, `update`, `delete`.
  final String operation;

  /// Il payload che viaggia sul filo: qui **sì** che il modello coincide con
  /// il contratto dell'API, perché è quello che si invia.
  final String payload;

  /// Payload accessorio (es. il comando workout mergiato di una sessione).
  final String? secondaryPayload;
  final String status;
  final int attempts;
  final DateTime? nextAttemptAt;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OutboxRow({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    this.secondaryPayload,
    required this.status,
    required this.attempts,
    this.nextAttemptAt,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || secondaryPayload != null) {
      map['secondary_payload'] = Variable<String>(secondaryPayload);
    }
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      secondaryPayload: secondaryPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryPayload),
      status: Value(status),
      attempts: Value(attempts),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      secondaryPayload: serializer.fromJson<String?>(json['secondaryPayload']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'secondaryPayload': serializer.toJson<String?>(secondaryPayload),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OutboxRow copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payload,
    Value<String?> secondaryPayload = const Value.absent(),
    String? status,
    int? attempts,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OutboxRow(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    secondaryPayload: secondaryPayload.present
        ? secondaryPayload.value
        : this.secondaryPayload,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OutboxRow copyWithCompanion(OutboxCompanion data) {
    return OutboxRow(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      secondaryPayload: data.secondaryPayload.present
          ? data.secondaryPayload.value
          : this.secondaryPayload,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRow(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('secondaryPayload: $secondaryPayload, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payload,
    secondaryPayload,
    status,
    attempts,
    nextAttemptAt,
    lastError,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxRow &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.secondaryPayload == this.secondaryPayload &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OutboxCompanion extends UpdateCompanion<OutboxRow> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<String?> secondaryPayload;
  final Value<String> status;
  final Value<int> attempts;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.secondaryPayload = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    this.secondaryPayload = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payload = Value(payload),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<OutboxRow> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<String>? secondaryPayload,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (secondaryPayload != null) 'secondary_payload': secondaryPayload,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<String?>? secondaryPayload,
    Value<String>? status,
    Value<int>? attempts,
    Value<DateTime?>? nextAttemptAt,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OutboxCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      secondaryPayload: secondaryPayload ?? this.secondaryPayload,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (secondaryPayload.present) {
      map['secondary_payload'] = Variable<String>(secondaryPayload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('secondaryPayload: $secondaryPayload, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VoiceAliasesTable extends VoiceAliases
    with TableInfo<$VoiceAliasesTable, VoiceAliasRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VoiceAliasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _phraseMeta = const VerificationMeta('phrase');
  @override
  late final GeneratedColumn<String> phrase = GeneratedColumn<String>(
    'phrase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hitsMeta = const VerificationMeta('hits');
  @override
  late final GeneratedColumn<int> hits = GeneratedColumn<int>(
    'hits',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    phrase,
    exerciseId,
    hits,
    createdAt,
    lastUsedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'voice_aliases';
  @override
  VerificationContext validateIntegrity(
    Insertable<VoiceAliasRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('phrase')) {
      context.handle(
        _phraseMeta,
        phrase.isAcceptableOrUnknown(data['phrase']!, _phraseMeta),
      );
    } else if (isInserting) {
      context.missing(_phraseMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('hits')) {
      context.handle(
        _hitsMeta,
        hits.isAcceptableOrUnknown(data['hits']!, _hitsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUsedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {phrase};
  @override
  VoiceAliasRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoiceAliasRow(
      phrase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phrase'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      hits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hits'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      )!,
    );
  }

  @override
  $VoiceAliasesTable createAlias(String alias) {
    return $VoiceAliasesTable(attachedDatabase, alias);
  }
}

class VoiceAliasRow extends DataClass implements Insertable<VoiceAliasRow> {
  /// Testo pronunciato, già normalizzato.
  final String phrase;
  final String exerciseId;
  final int hits;
  final DateTime createdAt;
  final DateTime lastUsedAt;
  const VoiceAliasRow({
    required this.phrase,
    required this.exerciseId,
    required this.hits,
    required this.createdAt,
    required this.lastUsedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['phrase'] = Variable<String>(phrase);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['hits'] = Variable<int>(hits);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    return map;
  }

  VoiceAliasesCompanion toCompanion(bool nullToAbsent) {
    return VoiceAliasesCompanion(
      phrase: Value(phrase),
      exerciseId: Value(exerciseId),
      hits: Value(hits),
      createdAt: Value(createdAt),
      lastUsedAt: Value(lastUsedAt),
    );
  }

  factory VoiceAliasRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoiceAliasRow(
      phrase: serializer.fromJson<String>(json['phrase']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      hits: serializer.fromJson<int>(json['hits']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUsedAt: serializer.fromJson<DateTime>(json['lastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'phrase': serializer.toJson<String>(phrase),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'hits': serializer.toJson<int>(hits),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUsedAt': serializer.toJson<DateTime>(lastUsedAt),
    };
  }

  VoiceAliasRow copyWith({
    String? phrase,
    String? exerciseId,
    int? hits,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) => VoiceAliasRow(
    phrase: phrase ?? this.phrase,
    exerciseId: exerciseId ?? this.exerciseId,
    hits: hits ?? this.hits,
    createdAt: createdAt ?? this.createdAt,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
  );
  VoiceAliasRow copyWithCompanion(VoiceAliasesCompanion data) {
    return VoiceAliasRow(
      phrase: data.phrase.present ? data.phrase.value : this.phrase,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      hits: data.hits.present ? data.hits.value : this.hits,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoiceAliasRow(')
          ..write('phrase: $phrase, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('hits: $hits, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(phrase, exerciseId, hits, createdAt, lastUsedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoiceAliasRow &&
          other.phrase == this.phrase &&
          other.exerciseId == this.exerciseId &&
          other.hits == this.hits &&
          other.createdAt == this.createdAt &&
          other.lastUsedAt == this.lastUsedAt);
}

class VoiceAliasesCompanion extends UpdateCompanion<VoiceAliasRow> {
  final Value<String> phrase;
  final Value<String> exerciseId;
  final Value<int> hits;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastUsedAt;
  final Value<int> rowid;
  const VoiceAliasesCompanion({
    this.phrase = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.hits = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VoiceAliasesCompanion.insert({
    required String phrase,
    required String exerciseId,
    this.hits = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastUsedAt,
    this.rowid = const Value.absent(),
  }) : phrase = Value(phrase),
       exerciseId = Value(exerciseId),
       createdAt = Value(createdAt),
       lastUsedAt = Value(lastUsedAt);
  static Insertable<VoiceAliasRow> custom({
    Expression<String>? phrase,
    Expression<String>? exerciseId,
    Expression<int>? hits,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUsedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (phrase != null) 'phrase': phrase,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (hits != null) 'hits': hits,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VoiceAliasesCompanion copyWith({
    Value<String>? phrase,
    Value<String>? exerciseId,
    Value<int>? hits,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastUsedAt,
    Value<int>? rowid,
  }) {
    return VoiceAliasesCompanion(
      phrase: phrase ?? this.phrase,
      exerciseId: exerciseId ?? this.exerciseId,
      hits: hits ?? this.hits,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (phrase.present) {
      map['phrase'] = Variable<String>(phrase.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (hits.present) {
      map['hits'] = Variable<int>(hits.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VoiceAliasesCompanion(')
          ..write('phrase: $phrase, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('hits: $hits, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VoiceResolutionLogsTable extends VoiceResolutionLogs
    with TableInfo<$VoiceResolutionLogsTable, VoiceResolutionLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VoiceResolutionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedTextMeta = const VerificationMeta(
    'normalizedText',
  );
  @override
  late final GeneratedColumn<String> normalizedText = GeneratedColumn<String>(
    'normalized_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _candidatesMeta = const VerificationMeta(
    'candidates',
  );
  @override
  late final GeneratedColumn<String> candidates = GeneratedColumn<String>(
    'candidates',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chosenExerciseIdMeta = const VerificationMeta(
    'chosenExerciseId',
  );
  @override
  late final GeneratedColumn<String> chosenExerciseId = GeneratedColumn<String>(
    'chosen_exercise_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correctedExerciseIdMeta =
      const VerificationMeta('correctedExerciseId');
  @override
  late final GeneratedColumn<String> correctedExerciseId =
      GeneratedColumn<String>(
        'corrected_exercise_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    normalizedText,
    candidates,
    outcome,
    chosenExerciseId,
    correctedExerciseId,
    confidence,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'voice_resolution_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<VoiceResolutionLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('normalized_text')) {
      context.handle(
        _normalizedTextMeta,
        normalizedText.isAcceptableOrUnknown(
          data['normalized_text']!,
          _normalizedTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedTextMeta);
    }
    if (data.containsKey('candidates')) {
      context.handle(
        _candidatesMeta,
        candidates.isAcceptableOrUnknown(data['candidates']!, _candidatesMeta),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    if (data.containsKey('chosen_exercise_id')) {
      context.handle(
        _chosenExerciseIdMeta,
        chosenExerciseId.isAcceptableOrUnknown(
          data['chosen_exercise_id']!,
          _chosenExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('corrected_exercise_id')) {
      context.handle(
        _correctedExerciseIdMeta,
        correctedExerciseId.isAcceptableOrUnknown(
          data['corrected_exercise_id']!,
          _correctedExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VoiceResolutionLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoiceResolutionLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      normalizedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_text'],
      )!,
      candidates: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidates'],
      ),
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      chosenExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chosen_exercise_id'],
      ),
      correctedExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}corrected_exercise_id'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VoiceResolutionLogsTable createAlias(String alias) {
    return $VoiceResolutionLogsTable(attachedDatabase, alias);
  }
}

class VoiceResolutionLogRow extends DataClass
    implements Insertable<VoiceResolutionLogRow> {
  final String id;

  /// Testo **normalizzato**, mai quello grezzo.
  final String normalizedText;

  /// Candidati e punteggi, come JSON.
  final String? candidates;
  final String outcome;
  final String? chosenExerciseId;

  /// L'esercizio che l'utente ha scelto correggendo la proposta.
  final String? correctedExerciseId;
  final double? confidence;
  final DateTime createdAt;
  const VoiceResolutionLogRow({
    required this.id,
    required this.normalizedText,
    this.candidates,
    required this.outcome,
    this.chosenExerciseId,
    this.correctedExerciseId,
    this.confidence,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['normalized_text'] = Variable<String>(normalizedText);
    if (!nullToAbsent || candidates != null) {
      map['candidates'] = Variable<String>(candidates);
    }
    map['outcome'] = Variable<String>(outcome);
    if (!nullToAbsent || chosenExerciseId != null) {
      map['chosen_exercise_id'] = Variable<String>(chosenExerciseId);
    }
    if (!nullToAbsent || correctedExerciseId != null) {
      map['corrected_exercise_id'] = Variable<String>(correctedExerciseId);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VoiceResolutionLogsCompanion toCompanion(bool nullToAbsent) {
    return VoiceResolutionLogsCompanion(
      id: Value(id),
      normalizedText: Value(normalizedText),
      candidates: candidates == null && nullToAbsent
          ? const Value.absent()
          : Value(candidates),
      outcome: Value(outcome),
      chosenExerciseId: chosenExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(chosenExerciseId),
      correctedExerciseId: correctedExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(correctedExerciseId),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      createdAt: Value(createdAt),
    );
  }

  factory VoiceResolutionLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoiceResolutionLogRow(
      id: serializer.fromJson<String>(json['id']),
      normalizedText: serializer.fromJson<String>(json['normalizedText']),
      candidates: serializer.fromJson<String?>(json['candidates']),
      outcome: serializer.fromJson<String>(json['outcome']),
      chosenExerciseId: serializer.fromJson<String?>(json['chosenExerciseId']),
      correctedExerciseId: serializer.fromJson<String?>(
        json['correctedExerciseId'],
      ),
      confidence: serializer.fromJson<double?>(json['confidence']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'normalizedText': serializer.toJson<String>(normalizedText),
      'candidates': serializer.toJson<String?>(candidates),
      'outcome': serializer.toJson<String>(outcome),
      'chosenExerciseId': serializer.toJson<String?>(chosenExerciseId),
      'correctedExerciseId': serializer.toJson<String?>(correctedExerciseId),
      'confidence': serializer.toJson<double?>(confidence),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VoiceResolutionLogRow copyWith({
    String? id,
    String? normalizedText,
    Value<String?> candidates = const Value.absent(),
    String? outcome,
    Value<String?> chosenExerciseId = const Value.absent(),
    Value<String?> correctedExerciseId = const Value.absent(),
    Value<double?> confidence = const Value.absent(),
    DateTime? createdAt,
  }) => VoiceResolutionLogRow(
    id: id ?? this.id,
    normalizedText: normalizedText ?? this.normalizedText,
    candidates: candidates.present ? candidates.value : this.candidates,
    outcome: outcome ?? this.outcome,
    chosenExerciseId: chosenExerciseId.present
        ? chosenExerciseId.value
        : this.chosenExerciseId,
    correctedExerciseId: correctedExerciseId.present
        ? correctedExerciseId.value
        : this.correctedExerciseId,
    confidence: confidence.present ? confidence.value : this.confidence,
    createdAt: createdAt ?? this.createdAt,
  );
  VoiceResolutionLogRow copyWithCompanion(VoiceResolutionLogsCompanion data) {
    return VoiceResolutionLogRow(
      id: data.id.present ? data.id.value : this.id,
      normalizedText: data.normalizedText.present
          ? data.normalizedText.value
          : this.normalizedText,
      candidates: data.candidates.present
          ? data.candidates.value
          : this.candidates,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      chosenExerciseId: data.chosenExerciseId.present
          ? data.chosenExerciseId.value
          : this.chosenExerciseId,
      correctedExerciseId: data.correctedExerciseId.present
          ? data.correctedExerciseId.value
          : this.correctedExerciseId,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoiceResolutionLogRow(')
          ..write('id: $id, ')
          ..write('normalizedText: $normalizedText, ')
          ..write('candidates: $candidates, ')
          ..write('outcome: $outcome, ')
          ..write('chosenExerciseId: $chosenExerciseId, ')
          ..write('correctedExerciseId: $correctedExerciseId, ')
          ..write('confidence: $confidence, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    normalizedText,
    candidates,
    outcome,
    chosenExerciseId,
    correctedExerciseId,
    confidence,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoiceResolutionLogRow &&
          other.id == this.id &&
          other.normalizedText == this.normalizedText &&
          other.candidates == this.candidates &&
          other.outcome == this.outcome &&
          other.chosenExerciseId == this.chosenExerciseId &&
          other.correctedExerciseId == this.correctedExerciseId &&
          other.confidence == this.confidence &&
          other.createdAt == this.createdAt);
}

class VoiceResolutionLogsCompanion
    extends UpdateCompanion<VoiceResolutionLogRow> {
  final Value<String> id;
  final Value<String> normalizedText;
  final Value<String?> candidates;
  final Value<String> outcome;
  final Value<String?> chosenExerciseId;
  final Value<String?> correctedExerciseId;
  final Value<double?> confidence;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VoiceResolutionLogsCompanion({
    this.id = const Value.absent(),
    this.normalizedText = const Value.absent(),
    this.candidates = const Value.absent(),
    this.outcome = const Value.absent(),
    this.chosenExerciseId = const Value.absent(),
    this.correctedExerciseId = const Value.absent(),
    this.confidence = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VoiceResolutionLogsCompanion.insert({
    required String id,
    required String normalizedText,
    this.candidates = const Value.absent(),
    required String outcome,
    this.chosenExerciseId = const Value.absent(),
    this.correctedExerciseId = const Value.absent(),
    this.confidence = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       normalizedText = Value(normalizedText),
       outcome = Value(outcome),
       createdAt = Value(createdAt);
  static Insertable<VoiceResolutionLogRow> custom({
    Expression<String>? id,
    Expression<String>? normalizedText,
    Expression<String>? candidates,
    Expression<String>? outcome,
    Expression<String>? chosenExerciseId,
    Expression<String>? correctedExerciseId,
    Expression<double>? confidence,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (normalizedText != null) 'normalized_text': normalizedText,
      if (candidates != null) 'candidates': candidates,
      if (outcome != null) 'outcome': outcome,
      if (chosenExerciseId != null) 'chosen_exercise_id': chosenExerciseId,
      if (correctedExerciseId != null)
        'corrected_exercise_id': correctedExerciseId,
      if (confidence != null) 'confidence': confidence,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VoiceResolutionLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? normalizedText,
    Value<String?>? candidates,
    Value<String>? outcome,
    Value<String?>? chosenExerciseId,
    Value<String?>? correctedExerciseId,
    Value<double?>? confidence,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return VoiceResolutionLogsCompanion(
      id: id ?? this.id,
      normalizedText: normalizedText ?? this.normalizedText,
      candidates: candidates ?? this.candidates,
      outcome: outcome ?? this.outcome,
      chosenExerciseId: chosenExerciseId ?? this.chosenExerciseId,
      correctedExerciseId: correctedExerciseId ?? this.correctedExerciseId,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (normalizedText.present) {
      map['normalized_text'] = Variable<String>(normalizedText.value);
    }
    if (candidates.present) {
      map['candidates'] = Variable<String>(candidates.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (chosenExerciseId.present) {
      map['chosen_exercise_id'] = Variable<String>(chosenExerciseId.value);
    }
    if (correctedExerciseId.present) {
      map['corrected_exercise_id'] = Variable<String>(
        correctedExerciseId.value,
      );
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VoiceResolutionLogsCompanion(')
          ..write('id: $id, ')
          ..write('normalizedText: $normalizedText, ')
          ..write('candidates: $candidates, ')
          ..write('outcome: $outcome, ')
          ..write('chosenExerciseId: $chosenExerciseId, ')
          ..write('correctedExerciseId: $correctedExerciseId, ')
          ..write('confidence: $confidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatalogExercisesTable catalogExercises = $CatalogExercisesTable(
    this,
  );
  late final $LocalizedTextsTable localizedTexts = $LocalizedTextsTable(this);
  late final $ExerciseMusclesTable exerciseMuscles = $ExerciseMusclesTable(
    this,
  );
  late final $ExerciseEquipmentsTable exerciseEquipments =
      $ExerciseEquipmentsTable(this);
  late final $ExerciseCategoriesTable exerciseCategories =
      $ExerciseCategoriesTable(this);
  late final $CatalogMetaTable catalogMeta = $CatalogMetaTable(this);
  late final $CustomExercisesTable customExercises = $CustomExercisesTable(
    this,
  );
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutSnapshotsTable workoutSnapshots = $WorkoutSnapshotsTable(
    this,
  );
  late final $ActiveWorkoutDraftsTable activeWorkoutDrafts =
      $ActiveWorkoutDraftsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $VoiceAliasesTable voiceAliases = $VoiceAliasesTable(this);
  late final $VoiceResolutionLogsTable voiceResolutionLogs =
      $VoiceResolutionLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catalogExercises,
    localizedTexts,
    exerciseMuscles,
    exerciseEquipments,
    exerciseCategories,
    catalogMeta,
    customExercises,
    workouts,
    workoutSnapshots,
    activeWorkoutDrafts,
    sessions,
    outbox,
    voiceAliases,
    voiceResolutionLogs,
  ];
}

typedef $$CatalogExercisesTableCreateCompanionBuilder =
    CatalogExercisesCompanion Function({
      required String id,
      Value<String> code,
      Value<String?> difficultyLevel,
      Value<String?> mechanicsType,
      Value<String?> forceType,
      Value<bool> unilateral,
      Value<bool> bodyweight,
      Value<String?> exerciseKind,
      Value<String?> catalogStatus,
      Value<String?> payload,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CatalogExercisesTableUpdateCompanionBuilder =
    CatalogExercisesCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String?> difficultyLevel,
      Value<String?> mechanicsType,
      Value<String?> forceType,
      Value<bool> unilateral,
      Value<bool> bodyweight,
      Value<String?> exerciseKind,
      Value<String?> catalogStatus,
      Value<String?> payload,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CatalogExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogExercisesTable> {
  $$CatalogExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mechanicsType => $composableBuilder(
    column: $table.mechanicsType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get forceType => $composableBuilder(
    column: $table.forceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get unilateral => $composableBuilder(
    column: $table.unilateral,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bodyweight => $composableBuilder(
    column: $table.bodyweight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseKind => $composableBuilder(
    column: $table.exerciseKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogStatus => $composableBuilder(
    column: $table.catalogStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogExercisesTable> {
  $$CatalogExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mechanicsType => $composableBuilder(
    column: $table.mechanicsType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get forceType => $composableBuilder(
    column: $table.forceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get unilateral => $composableBuilder(
    column: $table.unilateral,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bodyweight => $composableBuilder(
    column: $table.bodyweight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseKind => $composableBuilder(
    column: $table.exerciseKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogStatus => $composableBuilder(
    column: $table.catalogStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogExercisesTable> {
  $$CatalogExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mechanicsType => $composableBuilder(
    column: $table.mechanicsType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get forceType =>
      $composableBuilder(column: $table.forceType, builder: (column) => column);

  GeneratedColumn<bool> get unilateral => $composableBuilder(
    column: $table.unilateral,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get bodyweight => $composableBuilder(
    column: $table.bodyweight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseKind => $composableBuilder(
    column: $table.exerciseKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catalogStatus => $composableBuilder(
    column: $table.catalogStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CatalogExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogExercisesTable,
          CatalogExerciseRow,
          $$CatalogExercisesTableFilterComposer,
          $$CatalogExercisesTableOrderingComposer,
          $$CatalogExercisesTableAnnotationComposer,
          $$CatalogExercisesTableCreateCompanionBuilder,
          $$CatalogExercisesTableUpdateCompanionBuilder,
          (
            CatalogExerciseRow,
            BaseReferences<
              _$AppDatabase,
              $CatalogExercisesTable,
              CatalogExerciseRow
            >,
          ),
          CatalogExerciseRow,
          PrefetchHooks Function()
        > {
  $$CatalogExercisesTableTableManager(
    _$AppDatabase db,
    $CatalogExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String?> difficultyLevel = const Value.absent(),
                Value<String?> mechanicsType = const Value.absent(),
                Value<String?> forceType = const Value.absent(),
                Value<bool> unilateral = const Value.absent(),
                Value<bool> bodyweight = const Value.absent(),
                Value<String?> exerciseKind = const Value.absent(),
                Value<String?> catalogStatus = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogExercisesCompanion(
                id: id,
                code: code,
                difficultyLevel: difficultyLevel,
                mechanicsType: mechanicsType,
                forceType: forceType,
                unilateral: unilateral,
                bodyweight: bodyweight,
                exerciseKind: exerciseKind,
                catalogStatus: catalogStatus,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> code = const Value.absent(),
                Value<String?> difficultyLevel = const Value.absent(),
                Value<String?> mechanicsType = const Value.absent(),
                Value<String?> forceType = const Value.absent(),
                Value<bool> unilateral = const Value.absent(),
                Value<bool> bodyweight = const Value.absent(),
                Value<String?> exerciseKind = const Value.absent(),
                Value<String?> catalogStatus = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CatalogExercisesCompanion.insert(
                id: id,
                code: code,
                difficultyLevel: difficultyLevel,
                mechanicsType: mechanicsType,
                forceType: forceType,
                unilateral: unilateral,
                bodyweight: bodyweight,
                exerciseKind: exerciseKind,
                catalogStatus: catalogStatus,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogExercisesTable,
      CatalogExerciseRow,
      $$CatalogExercisesTableFilterComposer,
      $$CatalogExercisesTableOrderingComposer,
      $$CatalogExercisesTableAnnotationComposer,
      $$CatalogExercisesTableCreateCompanionBuilder,
      $$CatalogExercisesTableUpdateCompanionBuilder,
      (
        CatalogExerciseRow,
        BaseReferences<
          _$AppDatabase,
          $CatalogExercisesTable,
          CatalogExerciseRow
        >,
      ),
      CatalogExerciseRow,
      PrefetchHooks Function()
    >;
typedef $$LocalizedTextsTableCreateCompanionBuilder =
    LocalizedTextsCompanion Function({
      required String entityType,
      required String entityId,
      required String field,
      required String locale,
      required String value,
      Value<int> rowid,
    });
typedef $$LocalizedTextsTableUpdateCompanionBuilder =
    LocalizedTextsCompanion Function({
      Value<String> entityType,
      Value<String> entityId,
      Value<String> field,
      Value<String> locale,
      Value<String> value,
      Value<int> rowid,
    });

class $$LocalizedTextsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalizedTextsTable> {
  $$LocalizedTextsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get field => $composableBuilder(
    column: $table.field,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalizedTextsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalizedTextsTable> {
  $$LocalizedTextsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get field => $composableBuilder(
    column: $table.field,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalizedTextsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalizedTextsTable> {
  $$LocalizedTextsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get field =>
      $composableBuilder(column: $table.field, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$LocalizedTextsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalizedTextsTable,
          LocalizedTextRow,
          $$LocalizedTextsTableFilterComposer,
          $$LocalizedTextsTableOrderingComposer,
          $$LocalizedTextsTableAnnotationComposer,
          $$LocalizedTextsTableCreateCompanionBuilder,
          $$LocalizedTextsTableUpdateCompanionBuilder,
          (
            LocalizedTextRow,
            BaseReferences<
              _$AppDatabase,
              $LocalizedTextsTable,
              LocalizedTextRow
            >,
          ),
          LocalizedTextRow,
          PrefetchHooks Function()
        > {
  $$LocalizedTextsTableTableManager(
    _$AppDatabase db,
    $LocalizedTextsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalizedTextsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalizedTextsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalizedTextsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> field = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalizedTextsCompanion(
                entityType: entityType,
                entityId: entityId,
                field: field,
                locale: locale,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityType,
                required String entityId,
                required String field,
                required String locale,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => LocalizedTextsCompanion.insert(
                entityType: entityType,
                entityId: entityId,
                field: field,
                locale: locale,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalizedTextsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalizedTextsTable,
      LocalizedTextRow,
      $$LocalizedTextsTableFilterComposer,
      $$LocalizedTextsTableOrderingComposer,
      $$LocalizedTextsTableAnnotationComposer,
      $$LocalizedTextsTableCreateCompanionBuilder,
      $$LocalizedTextsTableUpdateCompanionBuilder,
      (
        LocalizedTextRow,
        BaseReferences<_$AppDatabase, $LocalizedTextsTable, LocalizedTextRow>,
      ),
      LocalizedTextRow,
      PrefetchHooks Function()
    >;
typedef $$ExerciseMusclesTableCreateCompanionBuilder =
    ExerciseMusclesCompanion Function({
      required String exerciseId,
      required String muscleId,
      Value<String> muscleCode,
      Value<String?> involvement,
      Value<int> rowid,
    });
typedef $$ExerciseMusclesTableUpdateCompanionBuilder =
    ExerciseMusclesCompanion Function({
      Value<String> exerciseId,
      Value<String> muscleId,
      Value<String> muscleCode,
      Value<String?> involvement,
      Value<int> rowid,
    });

class $$ExerciseMusclesTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseMusclesTable> {
  $$ExerciseMusclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get muscleId => $composableBuilder(
    column: $table.muscleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get muscleCode => $composableBuilder(
    column: $table.muscleCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get involvement => $composableBuilder(
    column: $table.involvement,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseMusclesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseMusclesTable> {
  $$ExerciseMusclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleId => $composableBuilder(
    column: $table.muscleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleCode => $composableBuilder(
    column: $table.muscleCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get involvement => $composableBuilder(
    column: $table.involvement,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseMusclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseMusclesTable> {
  $$ExerciseMusclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get muscleId =>
      $composableBuilder(column: $table.muscleId, builder: (column) => column);

  GeneratedColumn<String> get muscleCode => $composableBuilder(
    column: $table.muscleCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get involvement => $composableBuilder(
    column: $table.involvement,
    builder: (column) => column,
  );
}

class $$ExerciseMusclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseMusclesTable,
          ExerciseMuscleRow,
          $$ExerciseMusclesTableFilterComposer,
          $$ExerciseMusclesTableOrderingComposer,
          $$ExerciseMusclesTableAnnotationComposer,
          $$ExerciseMusclesTableCreateCompanionBuilder,
          $$ExerciseMusclesTableUpdateCompanionBuilder,
          (
            ExerciseMuscleRow,
            BaseReferences<
              _$AppDatabase,
              $ExerciseMusclesTable,
              ExerciseMuscleRow
            >,
          ),
          ExerciseMuscleRow,
          PrefetchHooks Function()
        > {
  $$ExerciseMusclesTableTableManager(
    _$AppDatabase db,
    $ExerciseMusclesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseMusclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseMusclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseMusclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> exerciseId = const Value.absent(),
                Value<String> muscleId = const Value.absent(),
                Value<String> muscleCode = const Value.absent(),
                Value<String?> involvement = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseMusclesCompanion(
                exerciseId: exerciseId,
                muscleId: muscleId,
                muscleCode: muscleCode,
                involvement: involvement,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String exerciseId,
                required String muscleId,
                Value<String> muscleCode = const Value.absent(),
                Value<String?> involvement = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseMusclesCompanion.insert(
                exerciseId: exerciseId,
                muscleId: muscleId,
                muscleCode: muscleCode,
                involvement: involvement,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseMusclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseMusclesTable,
      ExerciseMuscleRow,
      $$ExerciseMusclesTableFilterComposer,
      $$ExerciseMusclesTableOrderingComposer,
      $$ExerciseMusclesTableAnnotationComposer,
      $$ExerciseMusclesTableCreateCompanionBuilder,
      $$ExerciseMusclesTableUpdateCompanionBuilder,
      (
        ExerciseMuscleRow,
        BaseReferences<_$AppDatabase, $ExerciseMusclesTable, ExerciseMuscleRow>,
      ),
      ExerciseMuscleRow,
      PrefetchHooks Function()
    >;
typedef $$ExerciseEquipmentsTableCreateCompanionBuilder =
    ExerciseEquipmentsCompanion Function({
      required String exerciseId,
      required String equipmentId,
      Value<String> equipmentCode,
      Value<bool> required,
      Value<int> rowid,
    });
typedef $$ExerciseEquipmentsTableUpdateCompanionBuilder =
    ExerciseEquipmentsCompanion Function({
      Value<String> exerciseId,
      Value<String> equipmentId,
      Value<String> equipmentCode,
      Value<bool> required,
      Value<int> rowid,
    });

class $$ExerciseEquipmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseEquipmentsTable> {
  $$ExerciseEquipmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentId => $composableBuilder(
    column: $table.equipmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentCode => $composableBuilder(
    column: $table.equipmentCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get required => $composableBuilder(
    column: $table.required,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseEquipmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseEquipmentsTable> {
  $$ExerciseEquipmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentId => $composableBuilder(
    column: $table.equipmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentCode => $composableBuilder(
    column: $table.equipmentCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get required => $composableBuilder(
    column: $table.required,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseEquipmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseEquipmentsTable> {
  $$ExerciseEquipmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipmentId => $composableBuilder(
    column: $table.equipmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipmentCode => $composableBuilder(
    column: $table.equipmentCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get required =>
      $composableBuilder(column: $table.required, builder: (column) => column);
}

class $$ExerciseEquipmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseEquipmentsTable,
          ExerciseEquipmentRow,
          $$ExerciseEquipmentsTableFilterComposer,
          $$ExerciseEquipmentsTableOrderingComposer,
          $$ExerciseEquipmentsTableAnnotationComposer,
          $$ExerciseEquipmentsTableCreateCompanionBuilder,
          $$ExerciseEquipmentsTableUpdateCompanionBuilder,
          (
            ExerciseEquipmentRow,
            BaseReferences<
              _$AppDatabase,
              $ExerciseEquipmentsTable,
              ExerciseEquipmentRow
            >,
          ),
          ExerciseEquipmentRow,
          PrefetchHooks Function()
        > {
  $$ExerciseEquipmentsTableTableManager(
    _$AppDatabase db,
    $ExerciseEquipmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseEquipmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseEquipmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseEquipmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> exerciseId = const Value.absent(),
                Value<String> equipmentId = const Value.absent(),
                Value<String> equipmentCode = const Value.absent(),
                Value<bool> required = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseEquipmentsCompanion(
                exerciseId: exerciseId,
                equipmentId: equipmentId,
                equipmentCode: equipmentCode,
                required: required,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String exerciseId,
                required String equipmentId,
                Value<String> equipmentCode = const Value.absent(),
                Value<bool> required = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseEquipmentsCompanion.insert(
                exerciseId: exerciseId,
                equipmentId: equipmentId,
                equipmentCode: equipmentCode,
                required: required,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseEquipmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseEquipmentsTable,
      ExerciseEquipmentRow,
      $$ExerciseEquipmentsTableFilterComposer,
      $$ExerciseEquipmentsTableOrderingComposer,
      $$ExerciseEquipmentsTableAnnotationComposer,
      $$ExerciseEquipmentsTableCreateCompanionBuilder,
      $$ExerciseEquipmentsTableUpdateCompanionBuilder,
      (
        ExerciseEquipmentRow,
        BaseReferences<
          _$AppDatabase,
          $ExerciseEquipmentsTable,
          ExerciseEquipmentRow
        >,
      ),
      ExerciseEquipmentRow,
      PrefetchHooks Function()
    >;
typedef $$ExerciseCategoriesTableCreateCompanionBuilder =
    ExerciseCategoriesCompanion Function({
      required String exerciseId,
      required String categoryId,
      Value<String> categoryCode,
      Value<int> rowid,
    });
typedef $$ExerciseCategoriesTableUpdateCompanionBuilder =
    ExerciseCategoriesCompanion Function({
      Value<String> exerciseId,
      Value<String> categoryId,
      Value<String> categoryCode,
      Value<int> rowid,
    });

class $$ExerciseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseCategoriesTable> {
  $$ExerciseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseCategoriesTable> {
  $$ExerciseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseCategoriesTable> {
  $$ExerciseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => column,
  );
}

class $$ExerciseCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseCategoriesTable,
          ExerciseCategoryRow,
          $$ExerciseCategoriesTableFilterComposer,
          $$ExerciseCategoriesTableOrderingComposer,
          $$ExerciseCategoriesTableAnnotationComposer,
          $$ExerciseCategoriesTableCreateCompanionBuilder,
          $$ExerciseCategoriesTableUpdateCompanionBuilder,
          (
            ExerciseCategoryRow,
            BaseReferences<
              _$AppDatabase,
              $ExerciseCategoriesTable,
              ExerciseCategoryRow
            >,
          ),
          ExerciseCategoryRow,
          PrefetchHooks Function()
        > {
  $$ExerciseCategoriesTableTableManager(
    _$AppDatabase db,
    $ExerciseCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> exerciseId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> categoryCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseCategoriesCompanion(
                exerciseId: exerciseId,
                categoryId: categoryId,
                categoryCode: categoryCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String exerciseId,
                required String categoryId,
                Value<String> categoryCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseCategoriesCompanion.insert(
                exerciseId: exerciseId,
                categoryId: categoryId,
                categoryCode: categoryCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseCategoriesTable,
      ExerciseCategoryRow,
      $$ExerciseCategoriesTableFilterComposer,
      $$ExerciseCategoriesTableOrderingComposer,
      $$ExerciseCategoriesTableAnnotationComposer,
      $$ExerciseCategoriesTableCreateCompanionBuilder,
      $$ExerciseCategoriesTableUpdateCompanionBuilder,
      (
        ExerciseCategoryRow,
        BaseReferences<
          _$AppDatabase,
          $ExerciseCategoriesTable,
          ExerciseCategoryRow
        >,
      ),
      ExerciseCategoryRow,
      PrefetchHooks Function()
    >;
typedef $$CatalogMetaTableCreateCompanionBuilder =
    CatalogMetaCompanion Function({
      Value<int> id,
      Value<int> version,
      Value<DateTime?> appliedAt,
    });
typedef $$CatalogMetaTableUpdateCompanionBuilder =
    CatalogMetaCompanion Function({
      Value<int> id,
      Value<int> version,
      Value<DateTime?> appliedAt,
    });

class $$CatalogMetaTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogMetaTable> {
  $$CatalogMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogMetaTable> {
  $$CatalogMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogMetaTable> {
  $$CatalogMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);
}

class $$CatalogMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogMetaTable,
          CatalogMetaRow,
          $$CatalogMetaTableFilterComposer,
          $$CatalogMetaTableOrderingComposer,
          $$CatalogMetaTableAnnotationComposer,
          $$CatalogMetaTableCreateCompanionBuilder,
          $$CatalogMetaTableUpdateCompanionBuilder,
          (
            CatalogMetaRow,
            BaseReferences<_$AppDatabase, $CatalogMetaTable, CatalogMetaRow>,
          ),
          CatalogMetaRow,
          PrefetchHooks Function()
        > {
  $$CatalogMetaTableTableManager(_$AppDatabase db, $CatalogMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime?> appliedAt = const Value.absent(),
              }) => CatalogMetaCompanion(
                id: id,
                version: version,
                appliedAt: appliedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime?> appliedAt = const Value.absent(),
              }) => CatalogMetaCompanion.insert(
                id: id,
                version: version,
                appliedAt: appliedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogMetaTable,
      CatalogMetaRow,
      $$CatalogMetaTableFilterComposer,
      $$CatalogMetaTableOrderingComposer,
      $$CatalogMetaTableAnnotationComposer,
      $$CatalogMetaTableCreateCompanionBuilder,
      $$CatalogMetaTableUpdateCompanionBuilder,
      (
        CatalogMetaRow,
        BaseReferences<_$AppDatabase, $CatalogMetaTable, CatalogMetaRow>,
      ),
      CatalogMetaRow,
      PrefetchHooks Function()
    >;
typedef $$CustomExercisesTableCreateCompanionBuilder =
    CustomExercisesCompanion Function({
      required String id,
      Value<String?> difficultyLevel,
      Value<String?> mechanicsType,
      Value<String?> forceType,
      Value<bool> unilateral,
      Value<bool> bodyweight,
      Value<String?> payload,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$CustomExercisesTableUpdateCompanionBuilder =
    CustomExercisesCompanion Function({
      Value<String> id,
      Value<String?> difficultyLevel,
      Value<String?> mechanicsType,
      Value<String?> forceType,
      Value<bool> unilateral,
      Value<bool> bodyweight,
      Value<String?> payload,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$CustomExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mechanicsType => $composableBuilder(
    column: $table.mechanicsType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get forceType => $composableBuilder(
    column: $table.forceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get unilateral => $composableBuilder(
    column: $table.unilateral,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bodyweight => $composableBuilder(
    column: $table.bodyweight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mechanicsType => $composableBuilder(
    column: $table.mechanicsType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get forceType => $composableBuilder(
    column: $table.forceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get unilateral => $composableBuilder(
    column: $table.unilateral,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bodyweight => $composableBuilder(
    column: $table.bodyweight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mechanicsType => $composableBuilder(
    column: $table.mechanicsType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get forceType =>
      $composableBuilder(column: $table.forceType, builder: (column) => column);

  GeneratedColumn<bool> get unilateral => $composableBuilder(
    column: $table.unilateral,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get bodyweight => $composableBuilder(
    column: $table.bodyweight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$CustomExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomExercisesTable,
          CustomExerciseRow,
          $$CustomExercisesTableFilterComposer,
          $$CustomExercisesTableOrderingComposer,
          $$CustomExercisesTableAnnotationComposer,
          $$CustomExercisesTableCreateCompanionBuilder,
          $$CustomExercisesTableUpdateCompanionBuilder,
          (
            CustomExerciseRow,
            BaseReferences<
              _$AppDatabase,
              $CustomExercisesTable,
              CustomExerciseRow
            >,
          ),
          CustomExerciseRow,
          PrefetchHooks Function()
        > {
  $$CustomExercisesTableTableManager(
    _$AppDatabase db,
    $CustomExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> difficultyLevel = const Value.absent(),
                Value<String?> mechanicsType = const Value.absent(),
                Value<String?> forceType = const Value.absent(),
                Value<bool> unilateral = const Value.absent(),
                Value<bool> bodyweight = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomExercisesCompanion(
                id: id,
                difficultyLevel: difficultyLevel,
                mechanicsType: mechanicsType,
                forceType: forceType,
                unilateral: unilateral,
                bodyweight: bodyweight,
                payload: payload,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> difficultyLevel = const Value.absent(),
                Value<String?> mechanicsType = const Value.absent(),
                Value<String?> forceType = const Value.absent(),
                Value<bool> unilateral = const Value.absent(),
                Value<bool> bodyweight = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomExercisesCompanion.insert(
                id: id,
                difficultyLevel: difficultyLevel,
                mechanicsType: mechanicsType,
                forceType: forceType,
                unilateral: unilateral,
                bodyweight: bodyweight,
                payload: payload,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomExercisesTable,
      CustomExerciseRow,
      $$CustomExercisesTableFilterComposer,
      $$CustomExercisesTableOrderingComposer,
      $$CustomExercisesTableAnnotationComposer,
      $$CustomExercisesTableCreateCompanionBuilder,
      $$CustomExercisesTableUpdateCompanionBuilder,
      (
        CustomExerciseRow,
        BaseReferences<_$AppDatabase, $CustomExercisesTable, CustomExerciseRow>,
      ),
      CustomExerciseRow,
      PrefetchHooks Function()
    >;
typedef $$WorkoutsTableCreateCompanionBuilder =
    WorkoutsCompanion Function({
      required String id,
      Value<String> origin,
      Value<String?> sourceProgramId,
      Value<String?> goal,
      Value<int> durationMinutes,
      Value<int> sessionsCount,
      Value<double> progress,
      Value<bool> active,
      Value<bool> archived,
      Value<bool> dirty,
      Value<String?> payload,
      required DateTime lastUsed,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$WorkoutsTableUpdateCompanionBuilder =
    WorkoutsCompanion Function({
      Value<String> id,
      Value<String> origin,
      Value<String?> sourceProgramId,
      Value<String?> goal,
      Value<int> durationMinutes,
      Value<int> sessionsCount,
      Value<double> progress,
      Value<bool> active,
      Value<bool> archived,
      Value<bool> dirty,
      Value<String?> payload,
      Value<DateTime> lastUsed,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceProgramId => $composableBuilder(
    column: $table.sourceProgramId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionsCount => $composableBuilder(
    column: $table.sessionsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsed => $composableBuilder(
    column: $table.lastUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceProgramId => $composableBuilder(
    column: $table.sourceProgramId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionsCount => $composableBuilder(
    column: $table.sessionsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsed => $composableBuilder(
    column: $table.lastUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get sourceProgramId => $composableBuilder(
    column: $table.sourceProgramId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionsCount => $composableBuilder(
    column: $table.sessionsCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsed =>
      $composableBuilder(column: $table.lastUsed, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTable,
          WorkoutRow,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (
            WorkoutRow,
            BaseReferences<_$AppDatabase, $WorkoutsTable, WorkoutRow>,
          ),
          WorkoutRow,
          PrefetchHooks Function()
        > {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<String?> sourceProgramId = const Value.absent(),
                Value<String?> goal = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> sessionsCount = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> lastUsed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                origin: origin,
                sourceProgramId: sourceProgramId,
                goal: goal,
                durationMinutes: durationMinutes,
                sessionsCount: sessionsCount,
                progress: progress,
                active: active,
                archived: archived,
                dirty: dirty,
                payload: payload,
                lastUsed: lastUsed,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> origin = const Value.absent(),
                Value<String?> sourceProgramId = const Value.absent(),
                Value<String?> goal = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> sessionsCount = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                required DateTime lastUsed,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion.insert(
                id: id,
                origin: origin,
                sourceProgramId: sourceProgramId,
                goal: goal,
                durationMinutes: durationMinutes,
                sessionsCount: sessionsCount,
                progress: progress,
                active: active,
                archived: archived,
                dirty: dirty,
                payload: payload,
                lastUsed: lastUsed,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTable,
      WorkoutRow,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (WorkoutRow, BaseReferences<_$AppDatabase, $WorkoutsTable, WorkoutRow>),
      WorkoutRow,
      PrefetchHooks Function()
    >;
typedef $$WorkoutSnapshotsTableCreateCompanionBuilder =
    WorkoutSnapshotsCompanion Function({
      required String workoutId,
      required String commandJson,
      required DateTime sourceUpdatedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSnapshotsTableUpdateCompanionBuilder =
    WorkoutSnapshotsCompanion Function({
      Value<String> workoutId,
      Value<String> commandJson,
      Value<DateTime> sourceUpdatedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$WorkoutSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSnapshotsTable> {
  $$WorkoutSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commandJson => $composableBuilder(
    column: $table.commandJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sourceUpdatedAt => $composableBuilder(
    column: $table.sourceUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSnapshotsTable> {
  $$WorkoutSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commandJson => $composableBuilder(
    column: $table.commandJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sourceUpdatedAt => $composableBuilder(
    column: $table.sourceUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSnapshotsTable> {
  $$WorkoutSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get workoutId =>
      $composableBuilder(column: $table.workoutId, builder: (column) => column);

  GeneratedColumn<String> get commandJson => $composableBuilder(
    column: $table.commandJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sourceUpdatedAt => $composableBuilder(
    column: $table.sourceUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WorkoutSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSnapshotsTable,
          WorkoutSnapshotRow,
          $$WorkoutSnapshotsTableFilterComposer,
          $$WorkoutSnapshotsTableOrderingComposer,
          $$WorkoutSnapshotsTableAnnotationComposer,
          $$WorkoutSnapshotsTableCreateCompanionBuilder,
          $$WorkoutSnapshotsTableUpdateCompanionBuilder,
          (
            WorkoutSnapshotRow,
            BaseReferences<
              _$AppDatabase,
              $WorkoutSnapshotsTable,
              WorkoutSnapshotRow
            >,
          ),
          WorkoutSnapshotRow,
          PrefetchHooks Function()
        > {
  $$WorkoutSnapshotsTableTableManager(
    _$AppDatabase db,
    $WorkoutSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> workoutId = const Value.absent(),
                Value<String> commandJson = const Value.absent(),
                Value<DateTime> sourceUpdatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSnapshotsCompanion(
                workoutId: workoutId,
                commandJson: commandJson,
                sourceUpdatedAt: sourceUpdatedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String workoutId,
                required String commandJson,
                required DateTime sourceUpdatedAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSnapshotsCompanion.insert(
                workoutId: workoutId,
                commandJson: commandJson,
                sourceUpdatedAt: sourceUpdatedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSnapshotsTable,
      WorkoutSnapshotRow,
      $$WorkoutSnapshotsTableFilterComposer,
      $$WorkoutSnapshotsTableOrderingComposer,
      $$WorkoutSnapshotsTableAnnotationComposer,
      $$WorkoutSnapshotsTableCreateCompanionBuilder,
      $$WorkoutSnapshotsTableUpdateCompanionBuilder,
      (
        WorkoutSnapshotRow,
        BaseReferences<
          _$AppDatabase,
          $WorkoutSnapshotsTable,
          WorkoutSnapshotRow
        >,
      ),
      WorkoutSnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$ActiveWorkoutDraftsTableCreateCompanionBuilder =
    ActiveWorkoutDraftsCompanion Function({
      required String workoutId,
      required String payload,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ActiveWorkoutDraftsTableUpdateCompanionBuilder =
    ActiveWorkoutDraftsCompanion Function({
      Value<String> workoutId,
      Value<String> payload,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ActiveWorkoutDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutDraftsTable> {
  $$ActiveWorkoutDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveWorkoutDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutDraftsTable> {
  $$ActiveWorkoutDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveWorkoutDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutDraftsTable> {
  $$ActiveWorkoutDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get workoutId =>
      $composableBuilder(column: $table.workoutId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActiveWorkoutDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveWorkoutDraftsTable,
          ActiveWorkoutDraftRow,
          $$ActiveWorkoutDraftsTableFilterComposer,
          $$ActiveWorkoutDraftsTableOrderingComposer,
          $$ActiveWorkoutDraftsTableAnnotationComposer,
          $$ActiveWorkoutDraftsTableCreateCompanionBuilder,
          $$ActiveWorkoutDraftsTableUpdateCompanionBuilder,
          (
            ActiveWorkoutDraftRow,
            BaseReferences<
              _$AppDatabase,
              $ActiveWorkoutDraftsTable,
              ActiveWorkoutDraftRow
            >,
          ),
          ActiveWorkoutDraftRow,
          PrefetchHooks Function()
        > {
  $$ActiveWorkoutDraftsTableTableManager(
    _$AppDatabase db,
    $ActiveWorkoutDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveWorkoutDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveWorkoutDraftsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActiveWorkoutDraftsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> workoutId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveWorkoutDraftsCompanion(
                workoutId: workoutId,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String workoutId,
                required String payload,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ActiveWorkoutDraftsCompanion.insert(
                workoutId: workoutId,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveWorkoutDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveWorkoutDraftsTable,
      ActiveWorkoutDraftRow,
      $$ActiveWorkoutDraftsTableFilterComposer,
      $$ActiveWorkoutDraftsTableOrderingComposer,
      $$ActiveWorkoutDraftsTableAnnotationComposer,
      $$ActiveWorkoutDraftsTableCreateCompanionBuilder,
      $$ActiveWorkoutDraftsTableUpdateCompanionBuilder,
      (
        ActiveWorkoutDraftRow,
        BaseReferences<
          _$AppDatabase,
          $ActiveWorkoutDraftsTable,
          ActiveWorkoutDraftRow
        >,
      ),
      ActiveWorkoutDraftRow,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      required String workoutId,
      Value<String> status,
      Value<String?> payload,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<String> workoutId,
      Value<String> status,
      Value<String?> payload,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workoutId =>
      $composableBuilder(column: $table.workoutId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          SessionRow,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (
            SessionRow,
            BaseReferences<_$AppDatabase, $SessionsTable, SessionRow>,
          ),
          SessionRow,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                workoutId: workoutId,
                status: status,
                payload: payload,
                startedAt: startedAt,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutId,
                Value<String> status = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                workoutId: workoutId,
                status: status,
                payload: payload,
                startedAt: startedAt,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      SessionRow,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (SessionRow, BaseReferences<_$AppDatabase, $SessionsTable, SessionRow>),
      SessionRow,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder =
    OutboxCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String operation,
      required String payload,
      Value<String?> secondaryPayload,
      Value<String> status,
      Value<int> attempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$OutboxTableUpdateCompanionBuilder =
    OutboxCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payload,
      Value<String?> secondaryPayload,
      Value<String> status,
      Value<int> attempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryPayload => $composableBuilder(
    column: $table.secondaryPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryPayload => $composableBuilder(
    column: $table.secondaryPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get secondaryPayload => $composableBuilder(
    column: $table.secondaryPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxRow,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
          OutboxRow,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String?> secondaryPayload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                secondaryPayload: secondaryPayload,
                status: status,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operation,
                required String payload,
                Value<String?> secondaryPayload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => OutboxCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                secondaryPayload: secondaryPayload,
                status: status,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxRow,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxRow, BaseReferences<_$AppDatabase, $OutboxTable, OutboxRow>),
      OutboxRow,
      PrefetchHooks Function()
    >;
typedef $$VoiceAliasesTableCreateCompanionBuilder =
    VoiceAliasesCompanion Function({
      required String phrase,
      required String exerciseId,
      Value<int> hits,
      required DateTime createdAt,
      required DateTime lastUsedAt,
      Value<int> rowid,
    });
typedef $$VoiceAliasesTableUpdateCompanionBuilder =
    VoiceAliasesCompanion Function({
      Value<String> phrase,
      Value<String> exerciseId,
      Value<int> hits,
      Value<DateTime> createdAt,
      Value<DateTime> lastUsedAt,
      Value<int> rowid,
    });

class $$VoiceAliasesTableFilterComposer
    extends Composer<_$AppDatabase, $VoiceAliasesTable> {
  $$VoiceAliasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get phrase => $composableBuilder(
    column: $table.phrase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hits => $composableBuilder(
    column: $table.hits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VoiceAliasesTableOrderingComposer
    extends Composer<_$AppDatabase, $VoiceAliasesTable> {
  $$VoiceAliasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get phrase => $composableBuilder(
    column: $table.phrase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hits => $composableBuilder(
    column: $table.hits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VoiceAliasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VoiceAliasesTable> {
  $$VoiceAliasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get phrase =>
      $composableBuilder(column: $table.phrase, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hits =>
      $composableBuilder(column: $table.hits, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );
}

class $$VoiceAliasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VoiceAliasesTable,
          VoiceAliasRow,
          $$VoiceAliasesTableFilterComposer,
          $$VoiceAliasesTableOrderingComposer,
          $$VoiceAliasesTableAnnotationComposer,
          $$VoiceAliasesTableCreateCompanionBuilder,
          $$VoiceAliasesTableUpdateCompanionBuilder,
          (
            VoiceAliasRow,
            BaseReferences<_$AppDatabase, $VoiceAliasesTable, VoiceAliasRow>,
          ),
          VoiceAliasRow,
          PrefetchHooks Function()
        > {
  $$VoiceAliasesTableTableManager(_$AppDatabase db, $VoiceAliasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VoiceAliasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VoiceAliasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VoiceAliasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> phrase = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> hits = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastUsedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VoiceAliasesCompanion(
                phrase: phrase,
                exerciseId: exerciseId,
                hits: hits,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String phrase,
                required String exerciseId,
                Value<int> hits = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastUsedAt,
                Value<int> rowid = const Value.absent(),
              }) => VoiceAliasesCompanion.insert(
                phrase: phrase,
                exerciseId: exerciseId,
                hits: hits,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VoiceAliasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VoiceAliasesTable,
      VoiceAliasRow,
      $$VoiceAliasesTableFilterComposer,
      $$VoiceAliasesTableOrderingComposer,
      $$VoiceAliasesTableAnnotationComposer,
      $$VoiceAliasesTableCreateCompanionBuilder,
      $$VoiceAliasesTableUpdateCompanionBuilder,
      (
        VoiceAliasRow,
        BaseReferences<_$AppDatabase, $VoiceAliasesTable, VoiceAliasRow>,
      ),
      VoiceAliasRow,
      PrefetchHooks Function()
    >;
typedef $$VoiceResolutionLogsTableCreateCompanionBuilder =
    VoiceResolutionLogsCompanion Function({
      required String id,
      required String normalizedText,
      Value<String?> candidates,
      required String outcome,
      Value<String?> chosenExerciseId,
      Value<String?> correctedExerciseId,
      Value<double?> confidence,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$VoiceResolutionLogsTableUpdateCompanionBuilder =
    VoiceResolutionLogsCompanion Function({
      Value<String> id,
      Value<String> normalizedText,
      Value<String?> candidates,
      Value<String> outcome,
      Value<String?> chosenExerciseId,
      Value<String?> correctedExerciseId,
      Value<double?> confidence,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$VoiceResolutionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $VoiceResolutionLogsTable> {
  $$VoiceResolutionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedText => $composableBuilder(
    column: $table.normalizedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidates => $composableBuilder(
    column: $table.candidates,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chosenExerciseId => $composableBuilder(
    column: $table.chosenExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctedExerciseId => $composableBuilder(
    column: $table.correctedExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VoiceResolutionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $VoiceResolutionLogsTable> {
  $$VoiceResolutionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedText => $composableBuilder(
    column: $table.normalizedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidates => $composableBuilder(
    column: $table.candidates,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chosenExerciseId => $composableBuilder(
    column: $table.chosenExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctedExerciseId => $composableBuilder(
    column: $table.correctedExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VoiceResolutionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VoiceResolutionLogsTable> {
  $$VoiceResolutionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get normalizedText => $composableBuilder(
    column: $table.normalizedText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get candidates => $composableBuilder(
    column: $table.candidates,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<String> get chosenExerciseId => $composableBuilder(
    column: $table.chosenExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get correctedExerciseId => $composableBuilder(
    column: $table.correctedExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VoiceResolutionLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VoiceResolutionLogsTable,
          VoiceResolutionLogRow,
          $$VoiceResolutionLogsTableFilterComposer,
          $$VoiceResolutionLogsTableOrderingComposer,
          $$VoiceResolutionLogsTableAnnotationComposer,
          $$VoiceResolutionLogsTableCreateCompanionBuilder,
          $$VoiceResolutionLogsTableUpdateCompanionBuilder,
          (
            VoiceResolutionLogRow,
            BaseReferences<
              _$AppDatabase,
              $VoiceResolutionLogsTable,
              VoiceResolutionLogRow
            >,
          ),
          VoiceResolutionLogRow,
          PrefetchHooks Function()
        > {
  $$VoiceResolutionLogsTableTableManager(
    _$AppDatabase db,
    $VoiceResolutionLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VoiceResolutionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VoiceResolutionLogsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$VoiceResolutionLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> normalizedText = const Value.absent(),
                Value<String?> candidates = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<String?> chosenExerciseId = const Value.absent(),
                Value<String?> correctedExerciseId = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VoiceResolutionLogsCompanion(
                id: id,
                normalizedText: normalizedText,
                candidates: candidates,
                outcome: outcome,
                chosenExerciseId: chosenExerciseId,
                correctedExerciseId: correctedExerciseId,
                confidence: confidence,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String normalizedText,
                Value<String?> candidates = const Value.absent(),
                required String outcome,
                Value<String?> chosenExerciseId = const Value.absent(),
                Value<String?> correctedExerciseId = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => VoiceResolutionLogsCompanion.insert(
                id: id,
                normalizedText: normalizedText,
                candidates: candidates,
                outcome: outcome,
                chosenExerciseId: chosenExerciseId,
                correctedExerciseId: correctedExerciseId,
                confidence: confidence,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VoiceResolutionLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VoiceResolutionLogsTable,
      VoiceResolutionLogRow,
      $$VoiceResolutionLogsTableFilterComposer,
      $$VoiceResolutionLogsTableOrderingComposer,
      $$VoiceResolutionLogsTableAnnotationComposer,
      $$VoiceResolutionLogsTableCreateCompanionBuilder,
      $$VoiceResolutionLogsTableUpdateCompanionBuilder,
      (
        VoiceResolutionLogRow,
        BaseReferences<
          _$AppDatabase,
          $VoiceResolutionLogsTable,
          VoiceResolutionLogRow
        >,
      ),
      VoiceResolutionLogRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatalogExercisesTableTableManager get catalogExercises =>
      $$CatalogExercisesTableTableManager(_db, _db.catalogExercises);
  $$LocalizedTextsTableTableManager get localizedTexts =>
      $$LocalizedTextsTableTableManager(_db, _db.localizedTexts);
  $$ExerciseMusclesTableTableManager get exerciseMuscles =>
      $$ExerciseMusclesTableTableManager(_db, _db.exerciseMuscles);
  $$ExerciseEquipmentsTableTableManager get exerciseEquipments =>
      $$ExerciseEquipmentsTableTableManager(_db, _db.exerciseEquipments);
  $$ExerciseCategoriesTableTableManager get exerciseCategories =>
      $$ExerciseCategoriesTableTableManager(_db, _db.exerciseCategories);
  $$CatalogMetaTableTableManager get catalogMeta =>
      $$CatalogMetaTableTableManager(_db, _db.catalogMeta);
  $$CustomExercisesTableTableManager get customExercises =>
      $$CustomExercisesTableTableManager(_db, _db.customExercises);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutSnapshotsTableTableManager get workoutSnapshots =>
      $$WorkoutSnapshotsTableTableManager(_db, _db.workoutSnapshots);
  $$ActiveWorkoutDraftsTableTableManager get activeWorkoutDrafts =>
      $$ActiveWorkoutDraftsTableTableManager(_db, _db.activeWorkoutDrafts);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$VoiceAliasesTableTableManager get voiceAliases =>
      $$VoiceAliasesTableTableManager(_db, _db.voiceAliases);
  $$VoiceResolutionLogsTableTableManager get voiceResolutionLogs =>
      $$VoiceResolutionLogsTableTableManager(_db, _db.voiceResolutionLogs);
}
