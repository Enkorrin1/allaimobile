import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/mock_api_providers.dart';
import '../../../../core/database/database_providers.dart';
import '../../data/catalog_api_data_source.dart';
import '../../data/catalog_cache_data_source.dart';
import '../../data/catalog_repository.dart';
import '../../domain/catalog_models.dart';

final catalogApiDataSourceProvider = Provider<CatalogApiDataSource>((ref) {
  return MockCatalogApiDataSource(ref.watch(mockAllAiApiProvider));
});

final catalogCacheDataSourceProvider = Provider<CatalogCacheDataSource>((ref) {
  return CatalogCacheDataSource(ref.watch(appDatabaseProvider));
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return MockCatalogRepository(
    ref.watch(catalogApiDataSourceProvider),
    ref.watch(catalogCacheDataSourceProvider),
  );
});

final catalogStateProvider = FutureProvider<CatalogRepositoryResult>((ref) {
  return ref.watch(catalogRepositoryProvider).getCatalogState();
});

final catalogProvider = FutureProvider<CatalogResponse>((ref) async {
  return (await ref.watch(catalogStateProvider.future)).catalog;
});
