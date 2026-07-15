import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/env.dart';
import '../../../../core/database/database_providers.dart';
import '../../data/content_cards_api_data_source.dart';
import '../../data/content_cards_cache_data_source.dart';
import '../../data/content_cards_repository.dart';
import '../../domain/content_card_models.dart';

final contentCardsApiDataSourceProvider = Provider<ContentCardsApiDataSource>((
  ref,
) {
  if (Env.apiBaseUrl.isEmpty) return const DisabledContentCardsApiDataSource();
  return LiveContentCardsApiDataSource(
    Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 7),
        receiveTimeout: const Duration(seconds: 12),
      ),
    ),
  );
});

final contentCardsCacheDataSourceProvider =
    Provider<ContentCardsCacheDataSource>((ref) {
      return ContentCardsCacheDataSource(ref.watch(appDatabaseProvider));
    });

final contentCardsRepositoryProvider = Provider<ContentCardsRepository>((ref) {
  return CachedContentCardsRepository(
    ref.watch(contentCardsApiDataSourceProvider),
    ref.watch(contentCardsCacheDataSourceProvider),
  );
});

final mobileContentCardsProvider = FutureProvider<ContentCardManifest>((ref) {
  return ref
      .watch(contentCardsRepositoryProvider)
      .getCards(surface: 'mobile', locale: 'ru');
});
