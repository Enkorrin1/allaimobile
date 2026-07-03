// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppMetadataTable extends AppMetadata
    with TableInfo<$AppMetadataTable, AppMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
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
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppMetadataTable createAlias(String alias) {
    return $AppMetadataTable(attachedDatabase, alias);
  }
}

class AppMetadataData extends DataClass implements Insertable<AppMetadataData> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppMetadataData({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppMetadataCompanion toCompanion(bool nullToAbsent) {
    return AppMetadataCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppMetadataData copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppMetadataData(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppMetadataData copyWithCompanion(AppMetadataCompanion data) {
    return AppMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppMetadataCompanion extends UpdateCompanion<AppMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetadataCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
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
    return (StringBuffer('AppMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogSnapshotsTable extends CatalogSnapshots
    with TableInfo<$CatalogSnapshotsTable, CatalogSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogJsonMeta = const VerificationMeta(
    'catalogJson',
  );
  @override
  late final GeneratedColumn<String> catalogJson = GeneratedColumn<String>(
    'catalog_json',
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
  List<GeneratedColumn> get $columns => [id, catalogJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('catalog_json')) {
      context.handle(
        _catalogJsonMeta,
        catalogJson.isAcceptableOrUnknown(
          data['catalog_json']!,
          _catalogJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_catalogJsonMeta);
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
  CatalogSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      catalogJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CatalogSnapshotsTable createAlias(String alias) {
    return $CatalogSnapshotsTable(attachedDatabase, alias);
  }
}

class CatalogSnapshot extends DataClass implements Insertable<CatalogSnapshot> {
  final String id;
  final String catalogJson;
  final DateTime updatedAt;
  const CatalogSnapshot({
    required this.id,
    required this.catalogJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['catalog_json'] = Variable<String>(catalogJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CatalogSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return CatalogSnapshotsCompanion(
      id: Value(id),
      catalogJson: Value(catalogJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory CatalogSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogSnapshot(
      id: serializer.fromJson<String>(json['id']),
      catalogJson: serializer.fromJson<String>(json['catalogJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'catalogJson': serializer.toJson<String>(catalogJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CatalogSnapshot copyWith({
    String? id,
    String? catalogJson,
    DateTime? updatedAt,
  }) => CatalogSnapshot(
    id: id ?? this.id,
    catalogJson: catalogJson ?? this.catalogJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CatalogSnapshot copyWithCompanion(CatalogSnapshotsCompanion data) {
    return CatalogSnapshot(
      id: data.id.present ? data.id.value : this.id,
      catalogJson: data.catalogJson.present
          ? data.catalogJson.value
          : this.catalogJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogSnapshot(')
          ..write('id: $id, ')
          ..write('catalogJson: $catalogJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, catalogJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogSnapshot &&
          other.id == this.id &&
          other.catalogJson == this.catalogJson &&
          other.updatedAt == this.updatedAt);
}

class CatalogSnapshotsCompanion extends UpdateCompanion<CatalogSnapshot> {
  final Value<String> id;
  final Value<String> catalogJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CatalogSnapshotsCompanion({
    this.id = const Value.absent(),
    this.catalogJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogSnapshotsCompanion.insert({
    required String id,
    required String catalogJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       catalogJson = Value(catalogJson),
       updatedAt = Value(updatedAt);
  static Insertable<CatalogSnapshot> custom({
    Expression<String>? id,
    Expression<String>? catalogJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catalogJson != null) 'catalog_json': catalogJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogSnapshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? catalogJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CatalogSnapshotsCompanion(
      id: id ?? this.id,
      catalogJson: catalogJson ?? this.catalogJson,
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
    if (catalogJson.present) {
      map['catalog_json'] = Variable<String>(catalogJson.value);
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
    return (StringBuffer('CatalogSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('catalogJson: $catalogJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GenerationJobsTable extends GenerationJobs
    with TableInfo<$GenerationJobsTable, GenerationJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GenerationJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputAssetIdsJsonMeta = const VerificationMeta(
    'inputAssetIdsJson',
  );
  @override
  late final GeneratedColumn<String> inputAssetIdsJson =
      GeneratedColumn<String>(
        'input_asset_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _outputAssetIdsJsonMeta =
      const VerificationMeta('outputAssetIdsJson');
  @override
  late final GeneratedColumn<String> outputAssetIdsJson =
      GeneratedColumn<String>(
        'output_asset_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _settingsJsonMeta = const VerificationMeta(
    'settingsJson',
  );
  @override
  late final GeneratedColumn<String> settingsJson = GeneratedColumn<String>(
    'settings_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costCoinsMeta = const VerificationMeta(
    'costCoins',
  );
  @override
  late final GeneratedColumn<int> costCoins = GeneratedColumn<int>(
    'cost_coins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
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
    userId,
    modelId,
    templateId,
    status,
    prompt,
    inputAssetIdsJson,
    outputAssetIdsJson,
    settingsJson,
    costCoins,
    progress,
    errorCode,
    errorMessage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'generation_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<GenerationJob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('input_asset_ids_json')) {
      context.handle(
        _inputAssetIdsJsonMeta,
        inputAssetIdsJson.isAcceptableOrUnknown(
          data['input_asset_ids_json']!,
          _inputAssetIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inputAssetIdsJsonMeta);
    }
    if (data.containsKey('output_asset_ids_json')) {
      context.handle(
        _outputAssetIdsJsonMeta,
        outputAssetIdsJson.isAcceptableOrUnknown(
          data['output_asset_ids_json']!,
          _outputAssetIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outputAssetIdsJsonMeta);
    }
    if (data.containsKey('settings_json')) {
      context.handle(
        _settingsJsonMeta,
        settingsJson.isAcceptableOrUnknown(
          data['settings_json']!,
          _settingsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingsJsonMeta);
    }
    if (data.containsKey('cost_coins')) {
      context.handle(
        _costCoinsMeta,
        costCoins.isAcceptableOrUnknown(data['cost_coins']!, _costCoinsMeta),
      );
    } else if (isInserting) {
      context.missing(_costCoinsMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
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
  GenerationJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GenerationJob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      )!,
      inputAssetIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_asset_ids_json'],
      )!,
      outputAssetIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output_asset_ids_json'],
      )!,
      settingsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}settings_json'],
      )!,
      costCoins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_coins'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      ),
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
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
  $GenerationJobsTable createAlias(String alias) {
    return $GenerationJobsTable(attachedDatabase, alias);
  }
}

class GenerationJob extends DataClass implements Insertable<GenerationJob> {
  final String id;
  final String userId;
  final String modelId;
  final String? templateId;
  final String status;
  final String prompt;
  final String inputAssetIdsJson;
  final String outputAssetIdsJson;
  final String settingsJson;
  final int costCoins;
  final double? progress;
  final String? errorCode;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GenerationJob({
    required this.id,
    required this.userId,
    required this.modelId,
    this.templateId,
    required this.status,
    required this.prompt,
    required this.inputAssetIdsJson,
    required this.outputAssetIdsJson,
    required this.settingsJson,
    required this.costCoins,
    this.progress,
    this.errorCode,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['model_id'] = Variable<String>(modelId);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    map['status'] = Variable<String>(status);
    map['prompt'] = Variable<String>(prompt);
    map['input_asset_ids_json'] = Variable<String>(inputAssetIdsJson);
    map['output_asset_ids_json'] = Variable<String>(outputAssetIdsJson);
    map['settings_json'] = Variable<String>(settingsJson);
    map['cost_coins'] = Variable<int>(costCoins);
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<double>(progress);
    }
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GenerationJobsCompanion toCompanion(bool nullToAbsent) {
    return GenerationJobsCompanion(
      id: Value(id),
      userId: Value(userId),
      modelId: Value(modelId),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      status: Value(status),
      prompt: Value(prompt),
      inputAssetIdsJson: Value(inputAssetIdsJson),
      outputAssetIdsJson: Value(outputAssetIdsJson),
      settingsJson: Value(settingsJson),
      costCoins: Value(costCoins),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GenerationJob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GenerationJob(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      modelId: serializer.fromJson<String>(json['modelId']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      status: serializer.fromJson<String>(json['status']),
      prompt: serializer.fromJson<String>(json['prompt']),
      inputAssetIdsJson: serializer.fromJson<String>(json['inputAssetIdsJson']),
      outputAssetIdsJson: serializer.fromJson<String>(
        json['outputAssetIdsJson'],
      ),
      settingsJson: serializer.fromJson<String>(json['settingsJson']),
      costCoins: serializer.fromJson<int>(json['costCoins']),
      progress: serializer.fromJson<double?>(json['progress']),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'modelId': serializer.toJson<String>(modelId),
      'templateId': serializer.toJson<String?>(templateId),
      'status': serializer.toJson<String>(status),
      'prompt': serializer.toJson<String>(prompt),
      'inputAssetIdsJson': serializer.toJson<String>(inputAssetIdsJson),
      'outputAssetIdsJson': serializer.toJson<String>(outputAssetIdsJson),
      'settingsJson': serializer.toJson<String>(settingsJson),
      'costCoins': serializer.toJson<int>(costCoins),
      'progress': serializer.toJson<double?>(progress),
      'errorCode': serializer.toJson<String?>(errorCode),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GenerationJob copyWith({
    String? id,
    String? userId,
    String? modelId,
    Value<String?> templateId = const Value.absent(),
    String? status,
    String? prompt,
    String? inputAssetIdsJson,
    String? outputAssetIdsJson,
    String? settingsJson,
    int? costCoins,
    Value<double?> progress = const Value.absent(),
    Value<String?> errorCode = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GenerationJob(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    modelId: modelId ?? this.modelId,
    templateId: templateId.present ? templateId.value : this.templateId,
    status: status ?? this.status,
    prompt: prompt ?? this.prompt,
    inputAssetIdsJson: inputAssetIdsJson ?? this.inputAssetIdsJson,
    outputAssetIdsJson: outputAssetIdsJson ?? this.outputAssetIdsJson,
    settingsJson: settingsJson ?? this.settingsJson,
    costCoins: costCoins ?? this.costCoins,
    progress: progress.present ? progress.value : this.progress,
    errorCode: errorCode.present ? errorCode.value : this.errorCode,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GenerationJob copyWithCompanion(GenerationJobsCompanion data) {
    return GenerationJob(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      status: data.status.present ? data.status.value : this.status,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      inputAssetIdsJson: data.inputAssetIdsJson.present
          ? data.inputAssetIdsJson.value
          : this.inputAssetIdsJson,
      outputAssetIdsJson: data.outputAssetIdsJson.present
          ? data.outputAssetIdsJson.value
          : this.outputAssetIdsJson,
      settingsJson: data.settingsJson.present
          ? data.settingsJson.value
          : this.settingsJson,
      costCoins: data.costCoins.present ? data.costCoins.value : this.costCoins,
      progress: data.progress.present ? data.progress.value : this.progress,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GenerationJob(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('modelId: $modelId, ')
          ..write('templateId: $templateId, ')
          ..write('status: $status, ')
          ..write('prompt: $prompt, ')
          ..write('inputAssetIdsJson: $inputAssetIdsJson, ')
          ..write('outputAssetIdsJson: $outputAssetIdsJson, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('costCoins: $costCoins, ')
          ..write('progress: $progress, ')
          ..write('errorCode: $errorCode, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    modelId,
    templateId,
    status,
    prompt,
    inputAssetIdsJson,
    outputAssetIdsJson,
    settingsJson,
    costCoins,
    progress,
    errorCode,
    errorMessage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GenerationJob &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.modelId == this.modelId &&
          other.templateId == this.templateId &&
          other.status == this.status &&
          other.prompt == this.prompt &&
          other.inputAssetIdsJson == this.inputAssetIdsJson &&
          other.outputAssetIdsJson == this.outputAssetIdsJson &&
          other.settingsJson == this.settingsJson &&
          other.costCoins == this.costCoins &&
          other.progress == this.progress &&
          other.errorCode == this.errorCode &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GenerationJobsCompanion extends UpdateCompanion<GenerationJob> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> modelId;
  final Value<String?> templateId;
  final Value<String> status;
  final Value<String> prompt;
  final Value<String> inputAssetIdsJson;
  final Value<String> outputAssetIdsJson;
  final Value<String> settingsJson;
  final Value<int> costCoins;
  final Value<double?> progress;
  final Value<String?> errorCode;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GenerationJobsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.modelId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.status = const Value.absent(),
    this.prompt = const Value.absent(),
    this.inputAssetIdsJson = const Value.absent(),
    this.outputAssetIdsJson = const Value.absent(),
    this.settingsJson = const Value.absent(),
    this.costCoins = const Value.absent(),
    this.progress = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GenerationJobsCompanion.insert({
    required String id,
    required String userId,
    required String modelId,
    this.templateId = const Value.absent(),
    required String status,
    required String prompt,
    required String inputAssetIdsJson,
    required String outputAssetIdsJson,
    required String settingsJson,
    required int costCoins,
    this.progress = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       modelId = Value(modelId),
       status = Value(status),
       prompt = Value(prompt),
       inputAssetIdsJson = Value(inputAssetIdsJson),
       outputAssetIdsJson = Value(outputAssetIdsJson),
       settingsJson = Value(settingsJson),
       costCoins = Value(costCoins),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GenerationJob> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? modelId,
    Expression<String>? templateId,
    Expression<String>? status,
    Expression<String>? prompt,
    Expression<String>? inputAssetIdsJson,
    Expression<String>? outputAssetIdsJson,
    Expression<String>? settingsJson,
    Expression<int>? costCoins,
    Expression<double>? progress,
    Expression<String>? errorCode,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (modelId != null) 'model_id': modelId,
      if (templateId != null) 'template_id': templateId,
      if (status != null) 'status': status,
      if (prompt != null) 'prompt': prompt,
      if (inputAssetIdsJson != null) 'input_asset_ids_json': inputAssetIdsJson,
      if (outputAssetIdsJson != null)
        'output_asset_ids_json': outputAssetIdsJson,
      if (settingsJson != null) 'settings_json': settingsJson,
      if (costCoins != null) 'cost_coins': costCoins,
      if (progress != null) 'progress': progress,
      if (errorCode != null) 'error_code': errorCode,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GenerationJobsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? modelId,
    Value<String?>? templateId,
    Value<String>? status,
    Value<String>? prompt,
    Value<String>? inputAssetIdsJson,
    Value<String>? outputAssetIdsJson,
    Value<String>? settingsJson,
    Value<int>? costCoins,
    Value<double?>? progress,
    Value<String?>? errorCode,
    Value<String?>? errorMessage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GenerationJobsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      modelId: modelId ?? this.modelId,
      templateId: templateId ?? this.templateId,
      status: status ?? this.status,
      prompt: prompt ?? this.prompt,
      inputAssetIdsJson: inputAssetIdsJson ?? this.inputAssetIdsJson,
      outputAssetIdsJson: outputAssetIdsJson ?? this.outputAssetIdsJson,
      settingsJson: settingsJson ?? this.settingsJson,
      costCoins: costCoins ?? this.costCoins,
      progress: progress ?? this.progress,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (inputAssetIdsJson.present) {
      map['input_asset_ids_json'] = Variable<String>(inputAssetIdsJson.value);
    }
    if (outputAssetIdsJson.present) {
      map['output_asset_ids_json'] = Variable<String>(outputAssetIdsJson.value);
    }
    if (settingsJson.present) {
      map['settings_json'] = Variable<String>(settingsJson.value);
    }
    if (costCoins.present) {
      map['cost_coins'] = Variable<int>(costCoins.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
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
    return (StringBuffer('GenerationJobsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('modelId: $modelId, ')
          ..write('templateId: $templateId, ')
          ..write('status: $status, ')
          ..write('prompt: $prompt, ')
          ..write('inputAssetIdsJson: $inputAssetIdsJson, ')
          ..write('outputAssetIdsJson: $outputAssetIdsJson, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('costCoins: $costCoins, ')
          ..write('progress: $progress, ')
          ..write('errorCode: $errorCode, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, Asset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    jobId,
    type,
    role,
    url,
    thumbnailUrl,
    width,
    height,
    durationSec,
    mimeType,
    sizeBytes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Asset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
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
  Asset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      ),
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class Asset extends DataClass implements Insertable<Asset> {
  final String id;
  final String? jobId;
  final String type;
  final String role;
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final int? durationSec;
  final String mimeType;
  final int? sizeBytes;
  final DateTime createdAt;
  const Asset({
    required this.id,
    this.jobId,
    required this.type,
    required this.role,
    required this.url,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.durationSec,
    required this.mimeType,
    this.sizeBytes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || jobId != null) {
      map['job_id'] = Variable<String>(jobId);
    }
    map['type'] = Variable<String>(type);
    map['role'] = Variable<String>(role);
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || durationSec != null) {
      map['duration_sec'] = Variable<int>(durationSec);
    }
    map['mime_type'] = Variable<String>(mimeType);
    if (!nullToAbsent || sizeBytes != null) {
      map['size_bytes'] = Variable<int>(sizeBytes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      jobId: jobId == null && nullToAbsent
          ? const Value.absent()
          : Value(jobId),
      type: Value(type),
      role: Value(role),
      url: Value(url),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      mimeType: Value(mimeType),
      sizeBytes: sizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeBytes),
      createdAt: Value(createdAt),
    );
  }

  factory Asset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String?>(json['jobId']),
      type: serializer.fromJson<String>(json['type']),
      role: serializer.fromJson<String>(json['role']),
      url: serializer.fromJson<String>(json['url']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      sizeBytes: serializer.fromJson<int?>(json['sizeBytes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String?>(jobId),
      'type': serializer.toJson<String>(type),
      'role': serializer.toJson<String>(role),
      'url': serializer.toJson<String>(url),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'durationSec': serializer.toJson<int?>(durationSec),
      'mimeType': serializer.toJson<String>(mimeType),
      'sizeBytes': serializer.toJson<int?>(sizeBytes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Asset copyWith({
    String? id,
    Value<String?> jobId = const Value.absent(),
    String? type,
    String? role,
    String? url,
    Value<String?> thumbnailUrl = const Value.absent(),
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<int?> durationSec = const Value.absent(),
    String? mimeType,
    Value<int?> sizeBytes = const Value.absent(),
    DateTime? createdAt,
  }) => Asset(
    id: id ?? this.id,
    jobId: jobId.present ? jobId.value : this.jobId,
    type: type ?? this.type,
    role: role ?? this.role,
    url: url ?? this.url,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    durationSec: durationSec.present ? durationSec.value : this.durationSec,
    mimeType: mimeType ?? this.mimeType,
    sizeBytes: sizeBytes.present ? sizeBytes.value : this.sizeBytes,
    createdAt: createdAt ?? this.createdAt,
  );
  Asset copyWithCompanion(AssetsCompanion data) {
    return Asset(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      type: data.type.present ? data.type.value : this.type,
      role: data.role.present ? data.role.value : this.role,
      url: data.url.present ? data.url.value : this.url,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('type: $type, ')
          ..write('role: $role, ')
          ..write('url: $url, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('durationSec: $durationSec, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jobId,
    type,
    role,
    url,
    thumbnailUrl,
    width,
    height,
    durationSec,
    mimeType,
    sizeBytes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.type == this.type &&
          other.role == this.role &&
          other.url == this.url &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.width == this.width &&
          other.height == this.height &&
          other.durationSec == this.durationSec &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.createdAt == this.createdAt);
}

class AssetsCompanion extends UpdateCompanion<Asset> {
  final Value<String> id;
  final Value<String?> jobId;
  final Value<String> type;
  final Value<String> role;
  final Value<String> url;
  final Value<String?> thumbnailUrl;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int?> durationSec;
  final Value<String> mimeType;
  final Value<int?> sizeBytes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.type = const Value.absent(),
    this.role = const Value.absent(),
    this.url = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    this.jobId = const Value.absent(),
    required String type,
    required String role,
    required String url,
    this.thumbnailUrl = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.durationSec = const Value.absent(),
    required String mimeType,
    this.sizeBytes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       role = Value(role),
       url = Value(url),
       mimeType = Value(mimeType),
       createdAt = Value(createdAt);
  static Insertable<Asset> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<String>? type,
    Expression<String>? role,
    Expression<String>? url,
    Expression<String>? thumbnailUrl,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? durationSec,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (type != null) 'type': type,
      if (role != null) 'role': role,
      if (url != null) 'url': url,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (durationSec != null) 'duration_sec': durationSec,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith({
    Value<String>? id,
    Value<String?>? jobId,
    Value<String>? type,
    Value<String>? role,
    Value<String>? url,
    Value<String?>? thumbnailUrl,
    Value<int?>? width,
    Value<int?>? height,
    Value<int?>? durationSec,
    Value<String>? mimeType,
    Value<int?>? sizeBytes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AssetsCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      type: type ?? this.type,
      role: role ?? this.role,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      durationSec: durationSec ?? this.durationSec,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
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
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
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
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('type: $type, ')
          ..write('role: $role, ')
          ..write('url: $url, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('durationSec: $durationSec, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillingSnapshotsTable extends BillingSnapshots
    with TableInfo<$BillingSnapshotsTable, BillingSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillingSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coinBalanceMeta = const VerificationMeta(
    'coinBalance',
  );
  @override
  late final GeneratedColumn<int> coinBalance = GeneratedColumn<int>(
    'coin_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reservedCoinsMeta = const VerificationMeta(
    'reservedCoins',
  );
  @override
  late final GeneratedColumn<int> reservedCoins = GeneratedColumn<int>(
    'reserved_coins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _availableCoinsMeta = const VerificationMeta(
    'availableCoins',
  );
  @override
  late final GeneratedColumn<int> availableCoins = GeneratedColumn<int>(
    'available_coins',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    userId,
    coinBalance,
    reservedCoins,
    availableCoins,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'billing_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillingSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('coin_balance')) {
      context.handle(
        _coinBalanceMeta,
        coinBalance.isAcceptableOrUnknown(
          data['coin_balance']!,
          _coinBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coinBalanceMeta);
    }
    if (data.containsKey('reserved_coins')) {
      context.handle(
        _reservedCoinsMeta,
        reservedCoins.isAcceptableOrUnknown(
          data['reserved_coins']!,
          _reservedCoinsMeta,
        ),
      );
    }
    if (data.containsKey('available_coins')) {
      context.handle(
        _availableCoinsMeta,
        availableCoins.isAcceptableOrUnknown(
          data['available_coins']!,
          _availableCoinsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_availableCoinsMeta);
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
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  BillingSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillingSnapshot(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      coinBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coin_balance'],
      )!,
      reservedCoins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reserved_coins'],
      )!,
      availableCoins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}available_coins'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BillingSnapshotsTable createAlias(String alias) {
    return $BillingSnapshotsTable(attachedDatabase, alias);
  }
}

class BillingSnapshot extends DataClass implements Insertable<BillingSnapshot> {
  final String userId;
  final int coinBalance;
  final int reservedCoins;
  final int availableCoins;
  final DateTime updatedAt;
  const BillingSnapshot({
    required this.userId,
    required this.coinBalance,
    required this.reservedCoins,
    required this.availableCoins,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['coin_balance'] = Variable<int>(coinBalance);
    map['reserved_coins'] = Variable<int>(reservedCoins);
    map['available_coins'] = Variable<int>(availableCoins);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BillingSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return BillingSnapshotsCompanion(
      userId: Value(userId),
      coinBalance: Value(coinBalance),
      reservedCoins: Value(reservedCoins),
      availableCoins: Value(availableCoins),
      updatedAt: Value(updatedAt),
    );
  }

  factory BillingSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillingSnapshot(
      userId: serializer.fromJson<String>(json['userId']),
      coinBalance: serializer.fromJson<int>(json['coinBalance']),
      reservedCoins: serializer.fromJson<int>(json['reservedCoins']),
      availableCoins: serializer.fromJson<int>(json['availableCoins']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'coinBalance': serializer.toJson<int>(coinBalance),
      'reservedCoins': serializer.toJson<int>(reservedCoins),
      'availableCoins': serializer.toJson<int>(availableCoins),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BillingSnapshot copyWith({
    String? userId,
    int? coinBalance,
    int? reservedCoins,
    int? availableCoins,
    DateTime? updatedAt,
  }) => BillingSnapshot(
    userId: userId ?? this.userId,
    coinBalance: coinBalance ?? this.coinBalance,
    reservedCoins: reservedCoins ?? this.reservedCoins,
    availableCoins: availableCoins ?? this.availableCoins,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BillingSnapshot copyWithCompanion(BillingSnapshotsCompanion data) {
    return BillingSnapshot(
      userId: data.userId.present ? data.userId.value : this.userId,
      coinBalance: data.coinBalance.present
          ? data.coinBalance.value
          : this.coinBalance,
      reservedCoins: data.reservedCoins.present
          ? data.reservedCoins.value
          : this.reservedCoins,
      availableCoins: data.availableCoins.present
          ? data.availableCoins.value
          : this.availableCoins,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillingSnapshot(')
          ..write('userId: $userId, ')
          ..write('coinBalance: $coinBalance, ')
          ..write('reservedCoins: $reservedCoins, ')
          ..write('availableCoins: $availableCoins, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    coinBalance,
    reservedCoins,
    availableCoins,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillingSnapshot &&
          other.userId == this.userId &&
          other.coinBalance == this.coinBalance &&
          other.reservedCoins == this.reservedCoins &&
          other.availableCoins == this.availableCoins &&
          other.updatedAt == this.updatedAt);
}

class BillingSnapshotsCompanion extends UpdateCompanion<BillingSnapshot> {
  final Value<String> userId;
  final Value<int> coinBalance;
  final Value<int> reservedCoins;
  final Value<int> availableCoins;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BillingSnapshotsCompanion({
    this.userId = const Value.absent(),
    this.coinBalance = const Value.absent(),
    this.reservedCoins = const Value.absent(),
    this.availableCoins = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillingSnapshotsCompanion.insert({
    required String userId,
    required int coinBalance,
    this.reservedCoins = const Value.absent(),
    required int availableCoins,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       coinBalance = Value(coinBalance),
       availableCoins = Value(availableCoins),
       updatedAt = Value(updatedAt);
  static Insertable<BillingSnapshot> custom({
    Expression<String>? userId,
    Expression<int>? coinBalance,
    Expression<int>? reservedCoins,
    Expression<int>? availableCoins,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (coinBalance != null) 'coin_balance': coinBalance,
      if (reservedCoins != null) 'reserved_coins': reservedCoins,
      if (availableCoins != null) 'available_coins': availableCoins,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillingSnapshotsCompanion copyWith({
    Value<String>? userId,
    Value<int>? coinBalance,
    Value<int>? reservedCoins,
    Value<int>? availableCoins,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BillingSnapshotsCompanion(
      userId: userId ?? this.userId,
      coinBalance: coinBalance ?? this.coinBalance,
      reservedCoins: reservedCoins ?? this.reservedCoins,
      availableCoins: availableCoins ?? this.availableCoins,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (coinBalance.present) {
      map['coin_balance'] = Variable<int>(coinBalance.value);
    }
    if (reservedCoins.present) {
      map['reserved_coins'] = Variable<int>(reservedCoins.value);
    }
    if (availableCoins.present) {
      map['available_coins'] = Variable<int>(availableCoins.value);
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
    return (StringBuffer('BillingSnapshotsCompanion(')
          ..write('userId: $userId, ')
          ..write('coinBalance: $coinBalance, ')
          ..write('reservedCoins: $reservedCoins, ')
          ..write('availableCoins: $availableCoins, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CoinPackagesTable extends CoinPackages
    with TableInfo<$CoinPackagesTable, CoinPackage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoinPackagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coinAmountMeta = const VerificationMeta(
    'coinAmount',
  );
  @override
  late final GeneratedColumn<int> coinAmount = GeneratedColumn<int>(
    'coin_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isHighlightedMeta = const VerificationMeta(
    'isHighlighted',
  );
  @override
  late final GeneratedColumn<bool> isHighlighted = GeneratedColumn<bool>(
    'is_highlighted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_highlighted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    coinAmount,
    description,
    isHighlighted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coin_packages';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoinPackage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('coin_amount')) {
      context.handle(
        _coinAmountMeta,
        coinAmount.isAcceptableOrUnknown(data['coin_amount']!, _coinAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_coinAmountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('is_highlighted')) {
      context.handle(
        _isHighlightedMeta,
        isHighlighted.isAcceptableOrUnknown(
          data['is_highlighted']!,
          _isHighlightedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoinPackage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoinPackage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      coinAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coin_amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      isHighlighted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_highlighted'],
      )!,
    );
  }

  @override
  $CoinPackagesTable createAlias(String alias) {
    return $CoinPackagesTable(attachedDatabase, alias);
  }
}

class CoinPackage extends DataClass implements Insertable<CoinPackage> {
  final String id;
  final String name;
  final int coinAmount;
  final String description;
  final bool isHighlighted;
  const CoinPackage({
    required this.id,
    required this.name,
    required this.coinAmount,
    required this.description,
    required this.isHighlighted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['coin_amount'] = Variable<int>(coinAmount);
    map['description'] = Variable<String>(description);
    map['is_highlighted'] = Variable<bool>(isHighlighted);
    return map;
  }

  CoinPackagesCompanion toCompanion(bool nullToAbsent) {
    return CoinPackagesCompanion(
      id: Value(id),
      name: Value(name),
      coinAmount: Value(coinAmount),
      description: Value(description),
      isHighlighted: Value(isHighlighted),
    );
  }

  factory CoinPackage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoinPackage(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      coinAmount: serializer.fromJson<int>(json['coinAmount']),
      description: serializer.fromJson<String>(json['description']),
      isHighlighted: serializer.fromJson<bool>(json['isHighlighted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'coinAmount': serializer.toJson<int>(coinAmount),
      'description': serializer.toJson<String>(description),
      'isHighlighted': serializer.toJson<bool>(isHighlighted),
    };
  }

  CoinPackage copyWith({
    String? id,
    String? name,
    int? coinAmount,
    String? description,
    bool? isHighlighted,
  }) => CoinPackage(
    id: id ?? this.id,
    name: name ?? this.name,
    coinAmount: coinAmount ?? this.coinAmount,
    description: description ?? this.description,
    isHighlighted: isHighlighted ?? this.isHighlighted,
  );
  CoinPackage copyWithCompanion(CoinPackagesCompanion data) {
    return CoinPackage(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      coinAmount: data.coinAmount.present
          ? data.coinAmount.value
          : this.coinAmount,
      description: data.description.present
          ? data.description.value
          : this.description,
      isHighlighted: data.isHighlighted.present
          ? data.isHighlighted.value
          : this.isHighlighted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoinPackage(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coinAmount: $coinAmount, ')
          ..write('description: $description, ')
          ..write('isHighlighted: $isHighlighted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, coinAmount, description, isHighlighted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoinPackage &&
          other.id == this.id &&
          other.name == this.name &&
          other.coinAmount == this.coinAmount &&
          other.description == this.description &&
          other.isHighlighted == this.isHighlighted);
}

class CoinPackagesCompanion extends UpdateCompanion<CoinPackage> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> coinAmount;
  final Value<String> description;
  final Value<bool> isHighlighted;
  final Value<int> rowid;
  const CoinPackagesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.coinAmount = const Value.absent(),
    this.description = const Value.absent(),
    this.isHighlighted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoinPackagesCompanion.insert({
    required String id,
    required String name,
    required int coinAmount,
    required String description,
    this.isHighlighted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       coinAmount = Value(coinAmount),
       description = Value(description);
  static Insertable<CoinPackage> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? coinAmount,
    Expression<String>? description,
    Expression<bool>? isHighlighted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (coinAmount != null) 'coin_amount': coinAmount,
      if (description != null) 'description': description,
      if (isHighlighted != null) 'is_highlighted': isHighlighted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoinPackagesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? coinAmount,
    Value<String>? description,
    Value<bool>? isHighlighted,
    Value<int>? rowid,
  }) {
    return CoinPackagesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      coinAmount: coinAmount ?? this.coinAmount,
      description: description ?? this.description,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (coinAmount.present) {
      map['coin_amount'] = Variable<int>(coinAmount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isHighlighted.present) {
      map['is_highlighted'] = Variable<bool>(isHighlighted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoinPackagesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coinAmount: $coinAmount, ')
          ..write('description: $description, ')
          ..write('isHighlighted: $isHighlighted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CoinTransactionsTable extends CoinTransactions
    with TableInfo<$CoinTransactionsTable, CoinTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoinTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mock'),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedJobIdMeta = const VerificationMeta(
    'relatedJobId',
  );
  @override
  late final GeneratedColumn<String> relatedJobId = GeneratedColumn<String>(
    'related_job_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceAfterMeta = const VerificationMeta(
    'balanceAfter',
  );
  @override
  late final GeneratedColumn<int> balanceAfter = GeneratedColumn<int>(
    'balance_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    type,
    amount,
    title,
    relatedJobId,
    balanceAfter,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coin_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoinTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('related_job_id')) {
      context.handle(
        _relatedJobIdMeta,
        relatedJobId.isAcceptableOrUnknown(
          data['related_job_id']!,
          _relatedJobIdMeta,
        ),
      );
    }
    if (data.containsKey('balance_after')) {
      context.handle(
        _balanceAfterMeta,
        balanceAfter.isAcceptableOrUnknown(
          data['balance_after']!,
          _balanceAfterMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoinTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoinTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      relatedJobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_job_id'],
      ),
      balanceAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_after'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CoinTransactionsTable createAlias(String alias) {
    return $CoinTransactionsTable(attachedDatabase, alias);
  }
}

class CoinTransaction extends DataClass implements Insertable<CoinTransaction> {
  final String id;
  final String type;
  final int amount;
  final String title;
  final String? relatedJobId;
  final int? balanceAfter;
  final DateTime createdAt;
  const CoinTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.title,
    this.relatedJobId,
    this.balanceAfter,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || relatedJobId != null) {
      map['related_job_id'] = Variable<String>(relatedJobId);
    }
    if (!nullToAbsent || balanceAfter != null) {
      map['balance_after'] = Variable<int>(balanceAfter);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CoinTransactionsCompanion toCompanion(bool nullToAbsent) {
    return CoinTransactionsCompanion(
      id: Value(id),
      type: Value(type),
      amount: Value(amount),
      title: Value(title),
      relatedJobId: relatedJobId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedJobId),
      balanceAfter: balanceAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(balanceAfter),
      createdAt: Value(createdAt),
    );
  }

  factory CoinTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoinTransaction(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      title: serializer.fromJson<String>(json['title']),
      relatedJobId: serializer.fromJson<String?>(json['relatedJobId']),
      balanceAfter: serializer.fromJson<int?>(json['balanceAfter']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'title': serializer.toJson<String>(title),
      'relatedJobId': serializer.toJson<String?>(relatedJobId),
      'balanceAfter': serializer.toJson<int?>(balanceAfter),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CoinTransaction copyWith({
    String? id,
    String? type,
    int? amount,
    String? title,
    Value<String?> relatedJobId = const Value.absent(),
    Value<int?> balanceAfter = const Value.absent(),
    DateTime? createdAt,
  }) => CoinTransaction(
    id: id ?? this.id,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    title: title ?? this.title,
    relatedJobId: relatedJobId.present ? relatedJobId.value : this.relatedJobId,
    balanceAfter: balanceAfter.present ? balanceAfter.value : this.balanceAfter,
    createdAt: createdAt ?? this.createdAt,
  );
  CoinTransaction copyWithCompanion(CoinTransactionsCompanion data) {
    return CoinTransaction(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      title: data.title.present ? data.title.value : this.title,
      relatedJobId: data.relatedJobId.present
          ? data.relatedJobId.value
          : this.relatedJobId,
      balanceAfter: data.balanceAfter.present
          ? data.balanceAfter.value
          : this.balanceAfter,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoinTransaction(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('title: $title, ')
          ..write('relatedJobId: $relatedJobId, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    amount,
    title,
    relatedJobId,
    balanceAfter,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoinTransaction &&
          other.id == this.id &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.title == this.title &&
          other.relatedJobId == this.relatedJobId &&
          other.balanceAfter == this.balanceAfter &&
          other.createdAt == this.createdAt);
}

class CoinTransactionsCompanion extends UpdateCompanion<CoinTransaction> {
  final Value<String> id;
  final Value<String> type;
  final Value<int> amount;
  final Value<String> title;
  final Value<String?> relatedJobId;
  final Value<int?> balanceAfter;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CoinTransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.title = const Value.absent(),
    this.relatedJobId = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoinTransactionsCompanion.insert({
    required String id,
    this.type = const Value.absent(),
    required int amount,
    required String title,
    this.relatedJobId = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<CoinTransaction> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<String>? title,
    Expression<String>? relatedJobId,
    Expression<int>? balanceAfter,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (title != null) 'title': title,
      if (relatedJobId != null) 'related_job_id': relatedJobId,
      if (balanceAfter != null) 'balance_after': balanceAfter,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoinTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<int>? amount,
    Value<String>? title,
    Value<String?>? relatedJobId,
    Value<int?>? balanceAfter,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CoinTransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      relatedJobId: relatedJobId ?? this.relatedJobId,
      balanceAfter: balanceAfter ?? this.balanceAfter,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (relatedJobId.present) {
      map['related_job_id'] = Variable<String>(relatedJobId.value);
    }
    if (balanceAfter.present) {
      map['balance_after'] = Variable<int>(balanceAfter.value);
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
    return (StringBuffer('CoinTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('title: $title, ')
          ..write('relatedJobId: $relatedJobId, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppMetadataTable appMetadata = $AppMetadataTable(this);
  late final $CatalogSnapshotsTable catalogSnapshots = $CatalogSnapshotsTable(
    this,
  );
  late final $GenerationJobsTable generationJobs = $GenerationJobsTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $BillingSnapshotsTable billingSnapshots = $BillingSnapshotsTable(
    this,
  );
  late final $CoinPackagesTable coinPackages = $CoinPackagesTable(this);
  late final $CoinTransactionsTable coinTransactions = $CoinTransactionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMetadata,
    catalogSnapshots,
    generationJobs,
    assets,
    billingSnapshots,
    coinPackages,
    coinTransactions,
  ];
}

typedef $$AppMetadataTableCreateCompanionBuilder =
    AppMetadataCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppMetadataTableUpdateCompanionBuilder =
    AppMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetadataTable,
          AppMetadataData,
          $$AppMetadataTableFilterComposer,
          $$AppMetadataTableOrderingComposer,
          $$AppMetadataTableAnnotationComposer,
          $$AppMetadataTableCreateCompanionBuilder,
          $$AppMetadataTableUpdateCompanionBuilder,
          (
            AppMetadataData,
            BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
          ),
          AppMetadataData,
          PrefetchHooks Function()
        > {
  $$AppMetadataTableTableManager(_$AppDatabase db, $AppMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion.insert(
                key: key,
                value: value,
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

typedef $$AppMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetadataTable,
      AppMetadataData,
      $$AppMetadataTableFilterComposer,
      $$AppMetadataTableOrderingComposer,
      $$AppMetadataTableAnnotationComposer,
      $$AppMetadataTableCreateCompanionBuilder,
      $$AppMetadataTableUpdateCompanionBuilder,
      (
        AppMetadataData,
        BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
      ),
      AppMetadataData,
      PrefetchHooks Function()
    >;
typedef $$CatalogSnapshotsTableCreateCompanionBuilder =
    CatalogSnapshotsCompanion Function({
      required String id,
      required String catalogJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CatalogSnapshotsTableUpdateCompanionBuilder =
    CatalogSnapshotsCompanion Function({
      Value<String> id,
      Value<String> catalogJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CatalogSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogSnapshotsTable> {
  $$CatalogSnapshotsTableFilterComposer({
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

  ColumnFilters<String> get catalogJson => $composableBuilder(
    column: $table.catalogJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogSnapshotsTable> {
  $$CatalogSnapshotsTableOrderingComposer({
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

  ColumnOrderings<String> get catalogJson => $composableBuilder(
    column: $table.catalogJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogSnapshotsTable> {
  $$CatalogSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get catalogJson => $composableBuilder(
    column: $table.catalogJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CatalogSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogSnapshotsTable,
          CatalogSnapshot,
          $$CatalogSnapshotsTableFilterComposer,
          $$CatalogSnapshotsTableOrderingComposer,
          $$CatalogSnapshotsTableAnnotationComposer,
          $$CatalogSnapshotsTableCreateCompanionBuilder,
          $$CatalogSnapshotsTableUpdateCompanionBuilder,
          (
            CatalogSnapshot,
            BaseReferences<
              _$AppDatabase,
              $CatalogSnapshotsTable,
              CatalogSnapshot
            >,
          ),
          CatalogSnapshot,
          PrefetchHooks Function()
        > {
  $$CatalogSnapshotsTableTableManager(
    _$AppDatabase db,
    $CatalogSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> catalogJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogSnapshotsCompanion(
                id: id,
                catalogJson: catalogJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String catalogJson,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CatalogSnapshotsCompanion.insert(
                id: id,
                catalogJson: catalogJson,
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

typedef $$CatalogSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogSnapshotsTable,
      CatalogSnapshot,
      $$CatalogSnapshotsTableFilterComposer,
      $$CatalogSnapshotsTableOrderingComposer,
      $$CatalogSnapshotsTableAnnotationComposer,
      $$CatalogSnapshotsTableCreateCompanionBuilder,
      $$CatalogSnapshotsTableUpdateCompanionBuilder,
      (
        CatalogSnapshot,
        BaseReferences<_$AppDatabase, $CatalogSnapshotsTable, CatalogSnapshot>,
      ),
      CatalogSnapshot,
      PrefetchHooks Function()
    >;
typedef $$GenerationJobsTableCreateCompanionBuilder =
    GenerationJobsCompanion Function({
      required String id,
      required String userId,
      required String modelId,
      Value<String?> templateId,
      required String status,
      required String prompt,
      required String inputAssetIdsJson,
      required String outputAssetIdsJson,
      required String settingsJson,
      required int costCoins,
      Value<double?> progress,
      Value<String?> errorCode,
      Value<String?> errorMessage,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GenerationJobsTableUpdateCompanionBuilder =
    GenerationJobsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> modelId,
      Value<String?> templateId,
      Value<String> status,
      Value<String> prompt,
      Value<String> inputAssetIdsJson,
      Value<String> outputAssetIdsJson,
      Value<String> settingsJson,
      Value<int> costCoins,
      Value<double?> progress,
      Value<String?> errorCode,
      Value<String?> errorMessage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GenerationJobsTableFilterComposer
    extends Composer<_$AppDatabase, $GenerationJobsTable> {
  $$GenerationJobsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputAssetIdsJson => $composableBuilder(
    column: $table.inputAssetIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outputAssetIdsJson => $composableBuilder(
    column: $table.outputAssetIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingsJson => $composableBuilder(
    column: $table.settingsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costCoins => $composableBuilder(
    column: $table.costCoins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
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

class $$GenerationJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $GenerationJobsTable> {
  $$GenerationJobsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputAssetIdsJson => $composableBuilder(
    column: $table.inputAssetIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outputAssetIdsJson => $composableBuilder(
    column: $table.outputAssetIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingsJson => $composableBuilder(
    column: $table.settingsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costCoins => $composableBuilder(
    column: $table.costCoins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
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

class $$GenerationJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GenerationJobsTable> {
  $$GenerationJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get inputAssetIdsJson => $composableBuilder(
    column: $table.inputAssetIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outputAssetIdsJson => $composableBuilder(
    column: $table.outputAssetIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingsJson => $composableBuilder(
    column: $table.settingsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costCoins =>
      $composableBuilder(column: $table.costCoins, builder: (column) => column);

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GenerationJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GenerationJobsTable,
          GenerationJob,
          $$GenerationJobsTableFilterComposer,
          $$GenerationJobsTableOrderingComposer,
          $$GenerationJobsTableAnnotationComposer,
          $$GenerationJobsTableCreateCompanionBuilder,
          $$GenerationJobsTableUpdateCompanionBuilder,
          (
            GenerationJob,
            BaseReferences<_$AppDatabase, $GenerationJobsTable, GenerationJob>,
          ),
          GenerationJob,
          PrefetchHooks Function()
        > {
  $$GenerationJobsTableTableManager(
    _$AppDatabase db,
    $GenerationJobsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GenerationJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GenerationJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GenerationJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String> inputAssetIdsJson = const Value.absent(),
                Value<String> outputAssetIdsJson = const Value.absent(),
                Value<String> settingsJson = const Value.absent(),
                Value<int> costCoins = const Value.absent(),
                Value<double?> progress = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GenerationJobsCompanion(
                id: id,
                userId: userId,
                modelId: modelId,
                templateId: templateId,
                status: status,
                prompt: prompt,
                inputAssetIdsJson: inputAssetIdsJson,
                outputAssetIdsJson: outputAssetIdsJson,
                settingsJson: settingsJson,
                costCoins: costCoins,
                progress: progress,
                errorCode: errorCode,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String modelId,
                Value<String?> templateId = const Value.absent(),
                required String status,
                required String prompt,
                required String inputAssetIdsJson,
                required String outputAssetIdsJson,
                required String settingsJson,
                required int costCoins,
                Value<double?> progress = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GenerationJobsCompanion.insert(
                id: id,
                userId: userId,
                modelId: modelId,
                templateId: templateId,
                status: status,
                prompt: prompt,
                inputAssetIdsJson: inputAssetIdsJson,
                outputAssetIdsJson: outputAssetIdsJson,
                settingsJson: settingsJson,
                costCoins: costCoins,
                progress: progress,
                errorCode: errorCode,
                errorMessage: errorMessage,
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

typedef $$GenerationJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GenerationJobsTable,
      GenerationJob,
      $$GenerationJobsTableFilterComposer,
      $$GenerationJobsTableOrderingComposer,
      $$GenerationJobsTableAnnotationComposer,
      $$GenerationJobsTableCreateCompanionBuilder,
      $$GenerationJobsTableUpdateCompanionBuilder,
      (
        GenerationJob,
        BaseReferences<_$AppDatabase, $GenerationJobsTable, GenerationJob>,
      ),
      GenerationJob,
      PrefetchHooks Function()
    >;
typedef $$AssetsTableCreateCompanionBuilder =
    AssetsCompanion Function({
      required String id,
      Value<String?> jobId,
      required String type,
      required String role,
      required String url,
      Value<String?> thumbnailUrl,
      Value<int?> width,
      Value<int?> height,
      Value<int?> durationSec,
      required String mimeType,
      Value<int?> sizeBytes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AssetsTableUpdateCompanionBuilder =
    AssetsCompanion Function({
      Value<String> id,
      Value<String?> jobId,
      Value<String> type,
      Value<String> role,
      Value<String> url,
      Value<String?> thumbnailUrl,
      Value<int?> width,
      Value<int?> height,
      Value<int?> durationSec,
      Value<String> mimeType,
      Value<int?> sizeBytes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
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

  ColumnFilters<String> get jobId => $composableBuilder(
    column: $table.jobId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
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

  ColumnOrderings<String> get jobId => $composableBuilder(
    column: $table.jobId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get jobId =>
      $composableBuilder(column: $table.jobId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetsTable,
          Asset,
          $$AssetsTableFilterComposer,
          $$AssetsTableOrderingComposer,
          $$AssetsTableAnnotationComposer,
          $$AssetsTableCreateCompanionBuilder,
          $$AssetsTableUpdateCompanionBuilder,
          (Asset, BaseReferences<_$AppDatabase, $AssetsTable, Asset>),
          Asset,
          PrefetchHooks Function()
        > {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> jobId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int?> sizeBytes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion(
                id: id,
                jobId: jobId,
                type: type,
                role: role,
                url: url,
                thumbnailUrl: thumbnailUrl,
                width: width,
                height: height,
                durationSec: durationSec,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> jobId = const Value.absent(),
                required String type,
                required String role,
                required String url,
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                required String mimeType,
                Value<int?> sizeBytes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion.insert(
                id: id,
                jobId: jobId,
                type: type,
                role: role,
                url: url,
                thumbnailUrl: thumbnailUrl,
                width: width,
                height: height,
                durationSec: durationSec,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
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

typedef $$AssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetsTable,
      Asset,
      $$AssetsTableFilterComposer,
      $$AssetsTableOrderingComposer,
      $$AssetsTableAnnotationComposer,
      $$AssetsTableCreateCompanionBuilder,
      $$AssetsTableUpdateCompanionBuilder,
      (Asset, BaseReferences<_$AppDatabase, $AssetsTable, Asset>),
      Asset,
      PrefetchHooks Function()
    >;
typedef $$BillingSnapshotsTableCreateCompanionBuilder =
    BillingSnapshotsCompanion Function({
      required String userId,
      required int coinBalance,
      Value<int> reservedCoins,
      required int availableCoins,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BillingSnapshotsTableUpdateCompanionBuilder =
    BillingSnapshotsCompanion Function({
      Value<String> userId,
      Value<int> coinBalance,
      Value<int> reservedCoins,
      Value<int> availableCoins,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BillingSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $BillingSnapshotsTable> {
  $$BillingSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coinBalance => $composableBuilder(
    column: $table.coinBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reservedCoins => $composableBuilder(
    column: $table.reservedCoins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get availableCoins => $composableBuilder(
    column: $table.availableCoins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BillingSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillingSnapshotsTable> {
  $$BillingSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coinBalance => $composableBuilder(
    column: $table.coinBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reservedCoins => $composableBuilder(
    column: $table.reservedCoins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get availableCoins => $composableBuilder(
    column: $table.availableCoins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BillingSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillingSnapshotsTable> {
  $$BillingSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get coinBalance => $composableBuilder(
    column: $table.coinBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reservedCoins => $composableBuilder(
    column: $table.reservedCoins,
    builder: (column) => column,
  );

  GeneratedColumn<int> get availableCoins => $composableBuilder(
    column: $table.availableCoins,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BillingSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillingSnapshotsTable,
          BillingSnapshot,
          $$BillingSnapshotsTableFilterComposer,
          $$BillingSnapshotsTableOrderingComposer,
          $$BillingSnapshotsTableAnnotationComposer,
          $$BillingSnapshotsTableCreateCompanionBuilder,
          $$BillingSnapshotsTableUpdateCompanionBuilder,
          (
            BillingSnapshot,
            BaseReferences<
              _$AppDatabase,
              $BillingSnapshotsTable,
              BillingSnapshot
            >,
          ),
          BillingSnapshot,
          PrefetchHooks Function()
        > {
  $$BillingSnapshotsTableTableManager(
    _$AppDatabase db,
    $BillingSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillingSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillingSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillingSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<int> coinBalance = const Value.absent(),
                Value<int> reservedCoins = const Value.absent(),
                Value<int> availableCoins = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillingSnapshotsCompanion(
                userId: userId,
                coinBalance: coinBalance,
                reservedCoins: reservedCoins,
                availableCoins: availableCoins,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required int coinBalance,
                Value<int> reservedCoins = const Value.absent(),
                required int availableCoins,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BillingSnapshotsCompanion.insert(
                userId: userId,
                coinBalance: coinBalance,
                reservedCoins: reservedCoins,
                availableCoins: availableCoins,
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

typedef $$BillingSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillingSnapshotsTable,
      BillingSnapshot,
      $$BillingSnapshotsTableFilterComposer,
      $$BillingSnapshotsTableOrderingComposer,
      $$BillingSnapshotsTableAnnotationComposer,
      $$BillingSnapshotsTableCreateCompanionBuilder,
      $$BillingSnapshotsTableUpdateCompanionBuilder,
      (
        BillingSnapshot,
        BaseReferences<_$AppDatabase, $BillingSnapshotsTable, BillingSnapshot>,
      ),
      BillingSnapshot,
      PrefetchHooks Function()
    >;
typedef $$CoinPackagesTableCreateCompanionBuilder =
    CoinPackagesCompanion Function({
      required String id,
      required String name,
      required int coinAmount,
      required String description,
      Value<bool> isHighlighted,
      Value<int> rowid,
    });
typedef $$CoinPackagesTableUpdateCompanionBuilder =
    CoinPackagesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> coinAmount,
      Value<String> description,
      Value<bool> isHighlighted,
      Value<int> rowid,
    });

class $$CoinPackagesTableFilterComposer
    extends Composer<_$AppDatabase, $CoinPackagesTable> {
  $$CoinPackagesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coinAmount => $composableBuilder(
    column: $table.coinAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHighlighted => $composableBuilder(
    column: $table.isHighlighted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoinPackagesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoinPackagesTable> {
  $$CoinPackagesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coinAmount => $composableBuilder(
    column: $table.coinAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHighlighted => $composableBuilder(
    column: $table.isHighlighted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoinPackagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoinPackagesTable> {
  $$CoinPackagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get coinAmount => $composableBuilder(
    column: $table.coinAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isHighlighted => $composableBuilder(
    column: $table.isHighlighted,
    builder: (column) => column,
  );
}

class $$CoinPackagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoinPackagesTable,
          CoinPackage,
          $$CoinPackagesTableFilterComposer,
          $$CoinPackagesTableOrderingComposer,
          $$CoinPackagesTableAnnotationComposer,
          $$CoinPackagesTableCreateCompanionBuilder,
          $$CoinPackagesTableUpdateCompanionBuilder,
          (
            CoinPackage,
            BaseReferences<_$AppDatabase, $CoinPackagesTable, CoinPackage>,
          ),
          CoinPackage,
          PrefetchHooks Function()
        > {
  $$CoinPackagesTableTableManager(_$AppDatabase db, $CoinPackagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoinPackagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoinPackagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoinPackagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> coinAmount = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> isHighlighted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoinPackagesCompanion(
                id: id,
                name: name,
                coinAmount: coinAmount,
                description: description,
                isHighlighted: isHighlighted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int coinAmount,
                required String description,
                Value<bool> isHighlighted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoinPackagesCompanion.insert(
                id: id,
                name: name,
                coinAmount: coinAmount,
                description: description,
                isHighlighted: isHighlighted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoinPackagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoinPackagesTable,
      CoinPackage,
      $$CoinPackagesTableFilterComposer,
      $$CoinPackagesTableOrderingComposer,
      $$CoinPackagesTableAnnotationComposer,
      $$CoinPackagesTableCreateCompanionBuilder,
      $$CoinPackagesTableUpdateCompanionBuilder,
      (
        CoinPackage,
        BaseReferences<_$AppDatabase, $CoinPackagesTable, CoinPackage>,
      ),
      CoinPackage,
      PrefetchHooks Function()
    >;
typedef $$CoinTransactionsTableCreateCompanionBuilder =
    CoinTransactionsCompanion Function({
      required String id,
      Value<String> type,
      required int amount,
      required String title,
      Value<String?> relatedJobId,
      Value<int?> balanceAfter,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CoinTransactionsTableUpdateCompanionBuilder =
    CoinTransactionsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<int> amount,
      Value<String> title,
      Value<String?> relatedJobId,
      Value<int?> balanceAfter,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CoinTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $CoinTransactionsTable> {
  $$CoinTransactionsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedJobId => $composableBuilder(
    column: $table.relatedJobId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoinTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CoinTransactionsTable> {
  $$CoinTransactionsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedJobId => $composableBuilder(
    column: $table.relatedJobId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoinTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoinTransactionsTable> {
  $$CoinTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get relatedJobId => $composableBuilder(
    column: $table.relatedJobId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CoinTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoinTransactionsTable,
          CoinTransaction,
          $$CoinTransactionsTableFilterComposer,
          $$CoinTransactionsTableOrderingComposer,
          $$CoinTransactionsTableAnnotationComposer,
          $$CoinTransactionsTableCreateCompanionBuilder,
          $$CoinTransactionsTableUpdateCompanionBuilder,
          (
            CoinTransaction,
            BaseReferences<
              _$AppDatabase,
              $CoinTransactionsTable,
              CoinTransaction
            >,
          ),
          CoinTransaction,
          PrefetchHooks Function()
        > {
  $$CoinTransactionsTableTableManager(
    _$AppDatabase db,
    $CoinTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoinTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoinTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoinTransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> relatedJobId = const Value.absent(),
                Value<int?> balanceAfter = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoinTransactionsCompanion(
                id: id,
                type: type,
                amount: amount,
                title: title,
                relatedJobId: relatedJobId,
                balanceAfter: balanceAfter,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> type = const Value.absent(),
                required int amount,
                required String title,
                Value<String?> relatedJobId = const Value.absent(),
                Value<int?> balanceAfter = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CoinTransactionsCompanion.insert(
                id: id,
                type: type,
                amount: amount,
                title: title,
                relatedJobId: relatedJobId,
                balanceAfter: balanceAfter,
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

typedef $$CoinTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoinTransactionsTable,
      CoinTransaction,
      $$CoinTransactionsTableFilterComposer,
      $$CoinTransactionsTableOrderingComposer,
      $$CoinTransactionsTableAnnotationComposer,
      $$CoinTransactionsTableCreateCompanionBuilder,
      $$CoinTransactionsTableUpdateCompanionBuilder,
      (
        CoinTransaction,
        BaseReferences<_$AppDatabase, $CoinTransactionsTable, CoinTransaction>,
      ),
      CoinTransaction,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppMetadataTableTableManager get appMetadata =>
      $$AppMetadataTableTableManager(_db, _db.appMetadata);
  $$CatalogSnapshotsTableTableManager get catalogSnapshots =>
      $$CatalogSnapshotsTableTableManager(_db, _db.catalogSnapshots);
  $$GenerationJobsTableTableManager get generationJobs =>
      $$GenerationJobsTableTableManager(_db, _db.generationJobs);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$BillingSnapshotsTableTableManager get billingSnapshots =>
      $$BillingSnapshotsTableTableManager(_db, _db.billingSnapshots);
  $$CoinPackagesTableTableManager get coinPackages =>
      $$CoinPackagesTableTableManager(_db, _db.coinPackages);
  $$CoinTransactionsTableTableManager get coinTransactions =>
      $$CoinTransactionsTableTableManager(_db, _db.coinTransactions);
}
