import '../database/app_database.dart';
import 'allai_market_catalog_seed.dart';
import 'public_billing_sanitizer.dart';
import 'public_catalog_sanitizer.dart';

class MockApiException implements Exception {
  const MockApiException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'MockApiException($code, $message)';
}

class MockAllAiApi {
  MockAllAiApi({AppDatabase? database, int initialBalance = 1250})
    : this._(database ?? AppDatabase.memory(), initialBalance);

  MockAllAiApi._(this._database, this._initialBalance);

  static const _catalogSnapshotId = 'current';
  static const _demoUserId = 'demo-user';
  static final _baseTime = DateTime.utc(2026, 7, 3, 9);

  final AppDatabase _database;
  final int _initialBalance;
  bool _seeded = false;

  Future<Map<String, dynamic>> getCatalog() async {
    await _ensureSeeded();
    final snapshot = await _database.readCatalogSnapshot(_catalogSnapshotId);
    return sanitizePublicCatalogJson(snapshot ?? _catalogJson);
  }

  Future<Map<String, dynamic>> getBalance() async {
    await _ensureSeeded();
    return sanitizePublicBalanceJson(
      await _readBillingSnapshot(),
      defaultUserId: _demoUserId,
    );
  }

  Future<List<Map<String, dynamic>>> getPackages() async {
    await _ensureSeeded();
    final packages = await _database.readCoinPackages();
    return sanitizePublicPackagesJson(
      packages.isEmpty ? _packagesJson : packages,
    );
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    await _ensureSeeded();
    return _database.readCoinTransactions();
  }

  Future<Map<String, dynamic>> createGenerationJob(
    Map<String, dynamic> request,
  ) async {
    await _ensureSeeded();

    final prompt = (request['prompt'] as String? ?? '').trim();
    if (prompt.isEmpty) {
      throw const MockApiException(
        'invalid_prompt',
        'Добавьте описание изображения',
      );
    }

    final model = await _findModel(request['modelId'] as String);
    if (model['isAvailable'] != true) {
      throw const MockApiException(
        'model_unavailable',
        'Выбранная модель временно недоступна.',
      );
    }
    if (request['templateId'] != null) {
      final template = await _findTemplate(request['templateId'] as String);
      if (template['isAvailable'] == false) {
        throw const MockApiException(
          'template_unavailable',
          'Выбранный шаблон временно недоступен.',
        );
      }
      if (template['defaultModelId'] != model['id']) {
        throw const MockApiException(
          'template_unavailable',
          'Выбранный шаблон не подходит для этой модели.',
        );
      }
    }

    final cost = (model['cost'] as Map<String, dynamic>)['minCoins'] as int;
    final billing = await _readBillingSnapshot();
    final coinBalance = billing['coinBalance'] as int;
    final reservedCoins = billing['reservedCoins'] as int;
    final availableCoins = billing['availableCoins'] as int;

    if (availableCoins < cost) {
      throw const MockApiException(
        'insufficient_balance',
        'Недостаточно коинов для этой генерации',
      );
    }

    final jobNumber = await _nextNumber(
      prefix: 'job-',
      existingIds: await _database.readJobIds(),
      fallback: 99,
    );
    final now = _baseTime.add(Duration(minutes: jobNumber));
    final jobId = 'job-$jobNumber';
    final job = {
      'id': jobId,
      'userId': _demoUserId,
      'modelId': request['modelId'],
      if (request['templateId'] != null) 'templateId': request['templateId'],
      'status': 'validating',
      'prompt': prompt,
      'inputAssetIds': request['inputAssetIds'] ?? <String>[],
      'outputAssetIds': <String>[],
      'settings': request['settings'] ?? <String, Object?>{},
      'costCoins': cost,
      'progress': 0.0,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    };

    await _database.transaction(() async {
      await _database.writeJob(job);
      await _database.writeBillingSnapshot(
        userId: _demoUserId,
        coinBalance: coinBalance,
        reservedCoins: reservedCoins + cost,
        updatedAt: now,
      );
      await _database.writeCoinTransaction({
        'id': 'tx-generation-$jobId',
        'type': 'reserve',
        'title': 'Резерв генерации',
        'amount': -cost,
        'relatedJobId': jobId,
        'balanceAfter': coinBalance,
        'createdAt': now.toIso8601String(),
      });
    });

    return {'job': job, 'reservedCoins': cost};
  }

  Future<Map<String, dynamic>> advanceGenerationJob(String jobId) async {
    await _ensureSeeded();

    final job = await _database.readJob(jobId);
    if (job == null) {
      throw MockApiException('job_not_found', 'Job not found: $jobId');
    }

    final status = job['status'] as String;
    if (status == 'completed' || status == 'failed' || status == 'refunded') {
      return _jobResponse(jobId);
    }

    final prompt = (job['prompt'] as String).toLowerCase();
    final shouldFail = prompt.contains('fail') || prompt.contains('ошибка');
    final next = switch (status) {
      'validating' => ('queued', 0.15),
      'queued' => ('running', 0.45),
      'running' => ('processing', 0.80),
      'processing' when shouldFail => ('failed', 0.80),
      'processing' => ('completed', 1.0),
      _ => ('failed', job['progress'] as double? ?? 0.0),
    };

    final now = DateTime.parse(
      job['updatedAt'] as String,
    ).add(const Duration(seconds: 45));
    job['status'] = next.$1;
    job['progress'] = next.$2;
    job['updatedAt'] = now.toIso8601String();

    if (next.$1 == 'completed') {
      final asset = await _createOutputAsset(job, now);
      job['outputAssetIds'] = [asset['id']];
      final cost = job['costCoins'] as int;
      final billing = await _readBillingSnapshot();
      final updatedBalance = (billing['coinBalance'] as int) - cost;
      final updatedReservedCoins = _releaseReservedCoins(
        billing['reservedCoins'] as int,
        cost,
      );
      await _database.transaction(() async {
        await _database.writeAsset(asset);
        await _database.writeJob(job);
        await _database.writeBillingSnapshot(
          userId: _demoUserId,
          coinBalance: updatedBalance,
          reservedCoins: updatedReservedCoins,
          updatedAt: now,
        );
        await _database.writeCoinTransaction({
          'id': 'tx-generation-$jobId',
          'type': 'generation',
          'title': 'Списание за генерацию',
          'amount': -cost,
          'relatedJobId': jobId,
          'balanceAfter': updatedBalance,
          'createdAt': now.toIso8601String(),
        });
      });
      return _jobResponse(jobId);
    }

    if (next.$1 == 'failed') {
      job['errorCode'] = 'mock_generation_failed';
      job['errorMessage'] =
          'Генерация не удалась. Коины возвращены автоматически.';
      final cost = job['costCoins'] as int;
      final billing = await _readBillingSnapshot();
      final updatedBalance = billing['coinBalance'] as int;
      final updatedReservedCoins = _releaseReservedCoins(
        billing['reservedCoins'] as int,
        cost,
      );
      await _database.transaction(() async {
        await _database.writeJob(job);
        await _database.writeBillingSnapshot(
          userId: _demoUserId,
          coinBalance: updatedBalance,
          reservedCoins: updatedReservedCoins,
          updatedAt: now,
        );
        await _database.writeCoinTransaction({
          'id': 'tx-generation-$jobId',
          'type': 'refund',
          'title': 'Возврат за ошибку',
          'amount': cost,
          'relatedJobId': jobId,
          'balanceAfter': updatedBalance,
          'createdAt': now.toIso8601String(),
        });
      });
      return _jobResponse(jobId);
    }

    await _database.writeJob(job);
    return _jobResponse(jobId);
  }

  Future<Map<String, dynamic>> getGenerationJob(String jobId) async {
    await _ensureSeeded();
    return _jobResponse(jobId);
  }

  Future<List<Map<String, dynamic>>> getJobs() async {
    await _ensureSeeded();
    return _database.readJobs();
  }

  Future<Map<String, dynamic>?> getAsset(String assetId) async {
    await _ensureSeeded();
    return _database.readAsset(assetId);
  }

  Future<Map<String, dynamic>> _jobResponse(String jobId) async {
    final job = await _database.readJob(jobId);
    if (job == null) {
      throw MockApiException('job_not_found', 'Job not found: $jobId');
    }
    final outputIds = (job['outputAssetIds'] as List<dynamic>).cast<String>();
    final assets = <Map<String, dynamic>>[];
    for (final id in outputIds) {
      final asset = await _database.readAsset(id);
      if (asset != null) assets.add(asset);
    }
    return {'job': job, 'assets': assets};
  }

  Future<Map<String, dynamic>> _findModel(String modelId) async {
    final catalog = sanitizePublicCatalogJson(
      await _database.readCatalogSnapshot(_catalogSnapshotId) ?? _catalogJson,
    );
    final models = (catalog['models'] as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
    return models.firstWhere(
      (model) => model['id'] == modelId,
      orElse: () => throw MockApiException(
        'model_not_found',
        'Model not found: $modelId',
      ),
    );
  }

  Future<Map<String, dynamic>> _findTemplate(String templateId) async {
    final catalog = sanitizePublicCatalogJson(
      await _database.readCatalogSnapshot(_catalogSnapshotId) ?? _catalogJson,
    );
    final templates = (catalog['templates'] as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
    return templates.firstWhere(
      (template) => template['id'] == templateId,
      orElse: () => throw MockApiException(
        'template_unavailable',
        'Template not found: $templateId',
      ),
    );
  }

  Future<Map<String, dynamic>> _createOutputAsset(
    Map<String, dynamic> job,
    DateTime createdAt,
  ) async {
    final model = await _findModel(job['modelId'] as String);
    final outputs = (model['supportedOutputs'] as List<dynamic>).cast<String>();
    final type = outputs.contains('video') ? 'video' : 'image';
    final assetNumber = await _nextNumber(
      prefix: 'asset-',
      existingIds: await _database.readAssetIds(),
      fallback: 99,
    );
    final assetId = 'asset-$assetNumber';
    return {
      'id': assetId,
      'jobId': job['id'],
      'type': type,
      'role': 'output',
      'url': 'mock://assets/$assetId',
      'thumbnailUrl': 'mock://assets/$assetId/thumb',
      'width': type == 'image' ? 1536 : 1080,
      'height': 1920,
      if (type == 'video') 'durationSec': 6,
      'mimeType': type == 'image' ? 'image/png' : 'video/mp4',
      'sizeBytes': type == 'image' ? 1480000 : 6800000,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> _readBillingSnapshot() async {
    final snapshot = await _database.readBillingSnapshot(_demoUserId);
    if (snapshot != null) return snapshot;
    return {
      'coinBalance': _initialBalance,
      'reservedCoins': 0,
      'availableCoins': _initialBalance,
      'updatedAt': _baseTime.toIso8601String(),
    };
  }

  int _releaseReservedCoins(int reservedCoins, int cost) {
    final updatedReservedCoins = reservedCoins - cost;
    return updatedReservedCoins < 0 ? 0 : updatedReservedCoins;
  }

  Future<int> _nextNumber({
    required String prefix,
    required List<String> existingIds,
    required int fallback,
  }) async {
    var maxNumber = fallback;
    for (final id in existingIds) {
      if (!id.startsWith(prefix)) continue;
      final number = int.tryParse(id.substring(prefix.length));
      if (number != null && number > maxNumber) maxNumber = number;
    }
    return maxNumber + 1;
  }

  Future<void> _ensureSeeded() async {
    if (_seeded) return;

    const targetSeedVersion = '4';
    final currentSeedVersion = await _database.readMetadata('seed_version');
    if (currentSeedVersion == targetSeedVersion) {
      _seeded = true;
      return;
    }

    await _database.transaction(() async {
      await _database.writeCatalogSnapshot(
        _catalogSnapshotId,
        sanitizePublicCatalogJson(_catalogJson),
      );
      for (final package in _packagesJson) {
        await _database.writeCoinPackage(sanitizePublicPackageJson(package));
      }
      final existingBalance = await _database.readBillingSnapshot(_demoUserId);
      if (existingBalance == null) {
        await _database.writeBillingSnapshot(
          userId: _demoUserId,
          coinBalance: _initialBalance,
          updatedAt: _baseTime,
        );
        await _database.writeCoinTransaction({
          'id': 'tx-demo-balance',
          'type': 'grant',
          'title': 'Демо-баланс',
          'amount': _initialBalance,
          'balanceAfter': _initialBalance,
          'createdAt': _baseTime.toIso8601String(),
        });
      }
      await _database.writeMetadata(
        'seed_version',
        targetSeedVersion,
        _baseTime,
      );
    });
    _seeded = true;
  }
}

final Map<String, dynamic> _catalogJson = allAiMarketCatalogJson;
final List<Map<String, dynamic>> _packagesJson = [
  {
    'id': 'start',
    'name': 'Start',
    'coinAmount': 1000,
    'description': 'Для первых тестов и prompt-only изображений.',
  },
  {
    'id': 'creator',
    'name': 'Creator',
    'coinAmount': 5000,
    'description': 'Оптимальный пакет для регулярных social creatives.',
    'isHighlighted': true,
  },
  {
    'id': 'pro',
    'name': 'Pro',
    'coinAmount': 12000,
    'description': 'Для видео, try-on и серийных вариаций.',
  },
  {
    'id': 'studio',
    'name': 'Studio',
    'coinAmount': 30000,
    'description': 'Для командного контент-пайплайна и high-volume задач.',
  },
];
