import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/mock_api_providers.dart';
import '../../data/library_repository.dart';
import '../../domain/library_history_item.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return MockLibraryRepository(ref.watch(mockAllAiApiProvider));
});

final libraryHistoryProvider = FutureProvider<List<LibraryHistoryItem>>((
  ref,
) async {
  return ref.watch(libraryRepositoryProvider).getHistory();
});

final libraryItemByAssetProvider =
    FutureProvider.family<LibraryHistoryItem?, String>((ref, assetId) async {
      return ref.watch(libraryRepositoryProvider).getByAssetId(assetId);
    });
