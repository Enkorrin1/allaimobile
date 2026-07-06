import 'package:allai_mobile/core/api/mock_allai_api.dart';
import 'package:allai_mobile/core/database/app_database.dart';
import 'package:allai_mobile/features/billing/data/billing_api_data_source.dart';
import 'package:allai_mobile/features/billing/data/billing_cache_data_source.dart';
import 'package:allai_mobile/features/billing/data/billing_repository.dart';
import 'package:allai_mobile/features/tools/data/catalog_api_data_source.dart';
import 'package:allai_mobile/features/tools/data/catalog_cache_data_source.dart';
import 'package:allai_mobile/features/tools/data/catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase memoryDatabase() {
  final database = AppDatabase.memory();
  addTearDown(database.close);
  return database;
}

void main() {
  test(
    'catalog repository uses mock adapter and writes sanitized cache',
    () async {
      final database = memoryDatabase();
      final repository = MockCatalogRepository(
        _StaticCatalogApiDataSource(_catalogJsonWithPrivateFields()),
        CatalogCacheDataSource(database),
      );

      final state = await repository.getCatalogState(forceRefresh: true);
      final cached = await database.readCatalogSnapshot(
        CatalogCacheDataSource.currentSnapshotId,
      );
      final providerRoutingKey = 'provider${'Key'}';

      expect(state.isFromCache, isFalse);
      expect(state.catalog.models.single.id, 'photo-public');
      expect(cached.toString(), isNot(contains(providerRoutingKey)));
      expect(cached.toString(), isNot(contains('routing')));
      expect(cached.toString(), isNot(contains('internalMargin')));
    },
  );

  test('catalog repository falls back to cache on refresh failure', () async {
    final database = memoryDatabase();
    final cache = CatalogCacheDataSource(database);
    await cache.writeCatalog(_validCatalogJson());
    final repository = MockCatalogRepository(
      const DisabledLiveCatalogApiDataSource(),
      cache,
    );

    final state = await repository.getCatalogState(forceRefresh: true);

    expect(state.isFromCache, isTrue);
    expect(state.refreshError?.code, 'network_unavailable');
    expect(state.catalog.templates.single.id, 'starter-template');
  });

  test('catalog repository maps invalid catalog to safe error', () async {
    final repository = MockCatalogRepository(
      _StaticCatalogApiDataSource({
        ..._validCatalogJson(),
        'models': <Map<String, dynamic>>[],
      }),
      CatalogCacheDataSource(memoryDatabase()),
    );

    expect(
      () => repository.getCatalogState(forceRefresh: true),
      throwsA(
        isA<CatalogRepositoryException>().having(
          (error) => error.code,
          'code',
          'catalog_empty',
        ),
      ),
    );
  });

  test('billing repository preserves cached balance and packages', () async {
    final database = memoryDatabase();
    final cache = BillingCacheDataSource(database);
    final firstRepository = MockBillingRepository(
      MockBillingApiDataSource(MockAllAiApi(database: database)),
      cache,
    );

    final firstBalance = await firstRepository.getBalanceState();
    final firstPackages = await firstRepository.getPackagesState();

    final restoredRepository = MockBillingRepository(
      const DisabledLiveBillingApiDataSource(),
      cache,
    );
    final restoredBalance = await restoredRepository.getBalanceState();
    final restoredPackages = await restoredRepository.getPackagesState();

    expect(restoredBalance.isFromCache, isTrue);
    expect(restoredBalance.data.coinBalance, firstBalance.data.coinBalance);
    expect(
      restoredBalance.data.availableCoins,
      firstBalance.data.availableCoins,
    );
    expect(restoredBalance.data.reservedCoins, firstBalance.data.reservedCoins);
    expect(
      restoredPackages.data.map((package) => package.id),
      firstPackages.data.map((package) => package.id),
    );
  });

  test(
    'billing cache preserves package metadata and replaces stale packages',
    () async {
      final database = memoryDatabase();
      final cache = BillingCacheDataSource(database);
      await cache.writePackages([
        {
          'id': 'stale',
          'name': 'Old package',
          'coinAmount': 100,
          'description': 'Should disappear',
          'isHighlighted': false,
          'isAvailable': true,
          'displayOrder': 99,
        },
      ]);
      final repository = MockBillingRepository(
        const _StaticBillingApiDataSource(
          packages: [
            {
              'id': 'starter',
              'name': 'Starter',
              'coinAmount': 200,
              'description': 'Small top-up',
              'isHighlighted': false,
              'isAvailable': false,
              'priceLabel': 'Будет доступно позже',
              'displayOrder': 2,
            },
            {
              'id': 'pro',
              'name': 'Pro',
              'coinAmount': 1200,
              'description': 'Main package',
              'isHighlighted': true,
              'isAvailable': true,
              'priceLabel': 'Покупки позже',
              'displayOrder': 1,
            },
          ],
        ),
        cache,
      );

      final freshPackages = await repository.getPackagesState(
        forceRefresh: true,
      );
      final restoredRepository = MockBillingRepository(
        const DisabledLiveBillingApiDataSource(),
        cache,
      );
      final restoredPackages = await restoredRepository.getPackagesState();

      expect(freshPackages.data.map((package) => package.id), [
        'pro',
        'starter',
      ]);
      expect(restoredPackages.isFromCache, isTrue);
      expect(restoredPackages.data.map((package) => package.id), [
        'pro',
        'starter',
      ]);
      expect(restoredPackages.data.first.priceLabel, 'Покупки позже');
      expect(restoredPackages.data.last.isAvailable, isFalse);
      expect(restoredPackages.data.last.displayOrder, 2);
    },
  );
}

class _StaticCatalogApiDataSource implements CatalogApiDataSource {
  const _StaticCatalogApiDataSource(this._catalog);

  final Map<String, dynamic> _catalog;

  @override
  Future<Map<String, dynamic>> fetchCatalog() async {
    return _catalog;
  }
}

class _StaticBillingApiDataSource implements BillingApiDataSource {
  const _StaticBillingApiDataSource({required this.packages});

  final List<Map<String, dynamic>> packages;

  @override
  Future<Map<String, dynamic>> fetchBalance() async {
    return {
      'userId': 'demo-user',
      'coinBalance': 1000,
      'reservedCoins': 0,
      'availableCoins': 1000,
      'updatedAt': '2026-07-03T09:00:00.000Z',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPackages() async {
    return packages;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    return const [];
  }
}

Map<String, dynamic> _validCatalogJson() {
  return {
    'modes': [
      {'id': 'photo', 'title': 'Фото', 'category': 'image', 'order': 1},
    ],
    'models': [
      {
        'id': 'photo-public',
        'name': 'Public Photo',
        'providerLabel': 'AllAI',
        'category': 'image',
        'description': 'Public model',
        'supportedInputs': ['prompt'],
        'supportedOutputs': ['image'],
        'capabilities': {
          'aspectRatios': ['1:1'],
          'qualityLevels': ['standard'],
        },
        'isAvailable': true,
        'cost': {'minCoins': 80},
      },
    ],
    'templates': [
      {
        'id': 'starter-template',
        'title': 'Starter',
        'category': 'ugc',
        'description': 'Starter template',
        'previewUrl': 'mock://templates/starter',
        'defaultModelId': 'photo-public',
        'defaultPrompt': 'Create a starter image',
        'requiredInputs': ['prompt'],
        'outputFormat': 'image',
      },
    ],
    'categories': [
      {'id': 'image', 'title': 'Фото', 'order': 1},
    ],
    'updatedAt': '2026-07-03T09:00:00.000Z',
  };
}

Map<String, dynamic> _catalogJsonWithPrivateFields() {
  final catalog = _validCatalogJson();
  final providerRoutingKey = 'provider${'Key'}';
  catalog[providerRoutingKey] = 'must-not-be-cached';
  catalog['routing'] = {'provider': 'internal'};
  final model = (catalog['models'] as List<Map<String, dynamic>>).first;
  model[providerRoutingKey] = 'must-not-be-cached';
  model['internalMargin'] = 42;
  return catalog;
}
