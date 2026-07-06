import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class AppMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class CatalogSnapshots extends Table {
  TextColumn get id => text()();
  TextColumn get catalogJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class GenerationJobs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get modelId => text()();
  TextColumn get templateId => text().nullable()();
  TextColumn get status => text()();
  TextColumn get prompt => text()();
  TextColumn get inputAssetIdsJson => text()();
  TextColumn get outputAssetIdsJson => text()();
  TextColumn get settingsJson => text()();
  IntColumn get costCoins => integer()();
  RealColumn get progress => real().nullable()();
  TextColumn get errorCode => text().nullable()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get role => text()();
  TextColumn get url => text()();
  TextColumn get thumbnailUrl => text().nullable()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  IntColumn get durationSec => integer().nullable()();
  TextColumn get mimeType => text()();
  IntColumn get sizeBytes => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BillingSnapshots extends Table {
  TextColumn get userId => text()();
  IntColumn get coinBalance => integer()();
  IntColumn get reservedCoins => integer().withDefault(const Constant(0))();
  IntColumn get availableCoins => integer()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {userId};
}

class CoinPackages extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get coinAmount => integer()();
  TextColumn get description => text()();
  BoolColumn get isHighlighted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  TextColumn get priceLabel => text().nullable()();
  IntColumn get displayOrder => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CoinTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get type => text().withDefault(const Constant('mock'))();
  IntColumn get amount => integer()();
  TextColumn get title => text()();
  TextColumn get relatedJobId => text().nullable()();
  IntColumn get balanceAfter => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    AppMetadata,
    CatalogSnapshots,
    GenerationJobs,
    Assets,
    BillingSnapshots,
    CoinPackages,
    CoinTransactions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.open() {
    return AppDatabase(
      LazyDatabase(() async {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(p.join(dir.path, 'allai_mock.sqlite'));
        return NativeDatabase.createInBackground(file);
      }),
    );
  }

  factory AppDatabase.memory() {
    return AppDatabase(NativeDatabase.memory());
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(coinPackages, coinPackages.isAvailable);
        await migrator.addColumn(coinPackages, coinPackages.priceLabel);
        await migrator.addColumn(coinPackages, coinPackages.displayOrder);
      }
    },
  );

  Future<String?> readMetadata(String key) async {
    final row = await (select(
      appMetadata,
    )..where((table) => table.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> writeMetadata(String key, String value, DateTime updatedAt) {
    return into(appMetadata).insertOnConflictUpdate(
      AppMetadataCompanion.insert(key: key, value: value, updatedAt: updatedAt),
    );
  }

  Future<bool> hasCatalogSnapshot(String id) async {
    final snapshot = await (select(
      catalogSnapshots,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return snapshot != null;
  }

  Future<Map<String, dynamic>?> readCatalogSnapshot(String id) async {
    final snapshot = await (select(
      catalogSnapshots,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    if (snapshot == null) return null;
    return jsonDecode(snapshot.catalogJson) as Map<String, dynamic>;
  }

  Future<void> writeCatalogSnapshot(
    String id,
    Map<String, dynamic> catalogJson,
  ) async {
    final updatedAt = DateTime.parse(catalogJson['updatedAt'] as String);
    await into(catalogSnapshots).insertOnConflictUpdate(
      CatalogSnapshotsCompanion.insert(
        id: id,
        catalogJson: jsonEncode(catalogJson),
        updatedAt: updatedAt,
      ),
    );
  }

  Future<List<Map<String, dynamic>>> readJobs() async {
    final rows =
        await (select(generationJobs)..orderBy([
              (table) => OrderingTerm(
                expression: table.updatedAt,
                mode: OrderingMode.desc,
              ),
            ]))
            .get();
    return rows.map(_jobToJson).toList();
  }

  Future<Map<String, dynamic>?> readJob(String id) async {
    final row = await (select(
      generationJobs,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _jobToJson(row);
  }

  Future<void> writeJob(Map<String, dynamic> jobJson) async {
    await into(generationJobs).insertOnConflictUpdate(
      GenerationJobsCompanion.insert(
        id: jobJson['id'] as String,
        userId: jobJson['userId'] as String,
        modelId: jobJson['modelId'] as String,
        templateId: Value(jobJson['templateId'] as String?),
        status: jobJson['status'] as String,
        prompt: jobJson['prompt'] as String,
        inputAssetIdsJson: jsonEncode(jobJson['inputAssetIds']),
        outputAssetIdsJson: jsonEncode(jobJson['outputAssetIds']),
        settingsJson: jsonEncode(jobJson['settings']),
        costCoins: jobJson['costCoins'] as int,
        progress: Value((jobJson['progress'] as num?)?.toDouble()),
        errorCode: Value(jobJson['errorCode'] as String?),
        errorMessage: Value(jobJson['errorMessage'] as String?),
        createdAt: DateTime.parse(jobJson['createdAt'] as String),
        updatedAt: DateTime.parse(jobJson['updatedAt'] as String),
      ),
    );
  }

  Future<List<String>> readJobIds() async {
    final query = selectOnly(generationJobs)..addColumns([generationJobs.id]);
    final rows = await query.get();
    return rows.map((row) => row.read(generationJobs.id)!).toList();
  }

  Future<Map<String, dynamic>?> readAsset(String id) async {
    final row = await (select(
      assets,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _assetToJson(row);
  }

  Future<List<String>> readAssetIds() async {
    final query = selectOnly(assets)..addColumns([assets.id]);
    final rows = await query.get();
    return rows.map((row) => row.read(assets.id)!).toList();
  }

  Future<void> writeAsset(Map<String, dynamic> assetJson) async {
    await into(assets).insertOnConflictUpdate(
      AssetsCompanion.insert(
        id: assetJson['id'] as String,
        jobId: Value(assetJson['jobId'] as String?),
        type: assetJson['type'] as String,
        role: assetJson['role'] as String,
        url: assetJson['url'] as String,
        thumbnailUrl: Value(assetJson['thumbnailUrl'] as String?),
        width: Value(assetJson['width'] as int?),
        height: Value(assetJson['height'] as int?),
        durationSec: Value(assetJson['durationSec'] as int?),
        mimeType: assetJson['mimeType'] as String,
        sizeBytes: Value(assetJson['sizeBytes'] as int?),
        createdAt: DateTime.parse(assetJson['createdAt'] as String),
      ),
    );
  }

  Future<Map<String, dynamic>?> readBillingSnapshot(String userId) async {
    final row = await (select(
      billingSnapshots,
    )..where((table) => table.userId.equals(userId))).getSingleOrNull();
    if (row == null) return null;
    return {
      'coinBalance': row.coinBalance,
      'reservedCoins': row.reservedCoins,
      'availableCoins': row.availableCoins,
      'updatedAt': row.updatedAt.toIso8601String(),
    };
  }

  Future<void> writeBillingSnapshot({
    required String userId,
    required int coinBalance,
    required DateTime updatedAt,
    int reservedCoins = 0,
  }) async {
    final availableCoins = coinBalance - reservedCoins;
    await into(billingSnapshots).insertOnConflictUpdate(
      BillingSnapshotsCompanion.insert(
        userId: userId,
        coinBalance: coinBalance,
        reservedCoins: Value(reservedCoins),
        availableCoins: availableCoins,
        updatedAt: updatedAt,
      ),
    );
  }

  Future<List<Map<String, dynamic>>> readCoinPackages() async {
    final rows = await select(coinPackages).get();
    final packages = rows
        .map(
          (row) => {
            'id': row.id,
            'name': row.name,
            'coinAmount': row.coinAmount,
            'description': row.description,
            'isHighlighted': row.isHighlighted,
            'isAvailable': row.isAvailable,
            if (row.priceLabel != null) 'priceLabel': row.priceLabel,
            if (row.displayOrder != null) 'displayOrder': row.displayOrder,
          },
        )
        .toList();
    packages.sort((a, b) {
      final orderA = a['displayOrder'] as int?;
      final orderB = b['displayOrder'] as int?;
      if (orderA != null && orderB != null) return orderA.compareTo(orderB);
      if (orderA != null) return -1;
      if (orderB != null) return 1;
      return (a['coinAmount'] as int).compareTo(b['coinAmount'] as int);
    });
    return packages;
  }

  Future<void> writeCoinPackage(Map<String, dynamic> packageJson) async {
    await into(coinPackages).insertOnConflictUpdate(
      CoinPackagesCompanion.insert(
        id: packageJson['id'] as String,
        name: packageJson['name'] as String,
        coinAmount: packageJson['coinAmount'] as int,
        description: packageJson['description'] as String,
        isHighlighted: Value(packageJson['isHighlighted'] as bool? ?? false),
        isAvailable: Value(packageJson['isAvailable'] as bool? ?? true),
        priceLabel: Value(packageJson['priceLabel'] as String?),
        displayOrder: Value(packageJson['displayOrder'] as int?),
      ),
    );
  }

  Future<void> replaceCoinPackages(
    List<Map<String, dynamic>> packagesJson,
  ) async {
    await transaction(() async {
      await delete(coinPackages).go();
      for (final packageJson in packagesJson) {
        await writeCoinPackage(packageJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> readCoinTransactions() async {
    final rows =
        await (select(coinTransactions)..orderBy([
              (table) => OrderingTerm(
                expression: table.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
            .get();
    return rows
        .map(
          (row) => {
            'id': row.id,
            'type': row.type,
            'title': row.title,
            'amount': row.amount,
            if (row.relatedJobId != null) 'relatedJobId': row.relatedJobId,
            if (row.balanceAfter != null) 'balanceAfter': row.balanceAfter,
            'createdAt': row.createdAt.toIso8601String(),
          },
        )
        .toList();
  }

  Future<void> writeCoinTransaction(
    Map<String, dynamic> transactionJson,
  ) async {
    await into(coinTransactions).insertOnConflictUpdate(
      CoinTransactionsCompanion.insert(
        id: transactionJson['id'] as String,
        type: Value(transactionJson['type'] as String? ?? 'mock'),
        amount: transactionJson['amount'] as int,
        title: transactionJson['title'] as String,
        relatedJobId: Value(transactionJson['relatedJobId'] as String?),
        balanceAfter: Value(transactionJson['balanceAfter'] as int?),
        createdAt: DateTime.parse(transactionJson['createdAt'] as String),
      ),
    );
  }

  Future<void> clearAllDataForTests() async {
    await transaction(() async {
      await delete(coinTransactions).go();
      await delete(coinPackages).go();
      await delete(billingSnapshots).go();
      await delete(assets).go();
      await delete(generationJobs).go();
      await delete(catalogSnapshots).go();
      await delete(appMetadata).go();
    });
  }

  Map<String, dynamic> _jobToJson(GenerationJob row) {
    return {
      'id': row.id,
      'userId': row.userId,
      'modelId': row.modelId,
      if (row.templateId != null) 'templateId': row.templateId,
      'status': row.status,
      'prompt': row.prompt,
      'inputAssetIds': jsonDecode(row.inputAssetIdsJson),
      'outputAssetIds': jsonDecode(row.outputAssetIdsJson),
      'settings': jsonDecode(row.settingsJson),
      'costCoins': row.costCoins,
      if (row.progress != null) 'progress': row.progress,
      if (row.errorCode != null) 'errorCode': row.errorCode,
      if (row.errorMessage != null) 'errorMessage': row.errorMessage,
      'createdAt': row.createdAt.toIso8601String(),
      'updatedAt': row.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _assetToJson(Asset row) {
    return {
      'id': row.id,
      if (row.jobId != null) 'jobId': row.jobId,
      'type': row.type,
      'role': row.role,
      'url': row.url,
      if (row.thumbnailUrl != null) 'thumbnailUrl': row.thumbnailUrl,
      if (row.width != null) 'width': row.width,
      if (row.height != null) 'height': row.height,
      if (row.durationSec != null) 'durationSec': row.durationSec,
      'mimeType': row.mimeType,
      if (row.sizeBytes != null) 'sizeBytes': row.sizeBytes,
      'createdAt': row.createdAt.toIso8601String(),
    };
  }
}
