import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/mock_api_providers.dart';
import '../../../../core/database/database_providers.dart';
import '../../data/billing_api_data_source.dart';
import '../../data/billing_cache_data_source.dart';
import '../../data/billing_repository.dart';
import '../../domain/billing_models.dart';

final billingApiDataSourceProvider = Provider<BillingApiDataSource>((ref) {
  return MockBillingApiDataSource(ref.watch(mockAllAiApiProvider));
});

final billingCacheDataSourceProvider = Provider<BillingCacheDataSource>((ref) {
  return BillingCacheDataSource(ref.watch(appDatabaseProvider));
});

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return MockBillingRepository(
    ref.watch(billingApiDataSourceProvider),
    ref.watch(billingCacheDataSourceProvider),
  );
});

final balanceStateProvider =
    FutureProvider<BillingRepositoryResult<BillingBalance>>((ref) {
      return ref.watch(billingRepositoryProvider).getBalanceState();
    });

final balanceProvider = FutureProvider<BillingBalance>((ref) async {
  return (await ref.watch(balanceStateProvider.future)).data;
});

final coinPackagesStateProvider =
    FutureProvider<BillingRepositoryResult<List<CoinPackage>>>((ref) {
      return ref.watch(billingRepositoryProvider).getPackagesState();
    });

final coinPackagesProvider = FutureProvider<List<CoinPackage>>((ref) async {
  return (await ref.watch(coinPackagesStateProvider.future)).data;
});

final coinTransactionsStateProvider =
    FutureProvider<BillingRepositoryResult<List<CoinTransaction>>>((ref) {
      return ref.watch(billingRepositoryProvider).getTransactionsState();
    });

final coinTransactionsProvider = FutureProvider<List<CoinTransaction>>((
  ref,
) async {
  return (await ref.watch(coinTransactionsStateProvider.future)).data;
});
