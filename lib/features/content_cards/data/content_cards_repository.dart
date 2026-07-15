import '../domain/content_card_models.dart';
import 'content_cards_api_data_source.dart';
import 'content_cards_cache_data_source.dart';

abstract class ContentCardsRepository {
  Future<ContentCardManifest> getCards({
    required String surface,
    required String locale,
  });
}

class CachedContentCardsRepository implements ContentCardsRepository {
  const CachedContentCardsRepository(this._api, this._cache);

  final ContentCardsApiDataSource _api;
  final ContentCardsCacheDataSource _cache;

  @override
  Future<ContentCardManifest> getCards({
    required String surface,
    required String locale,
  }) async {
    final cached = await _readCached(surface: surface, locale: locale);
    try {
      final json = await _api.fetchCards(surface: surface, locale: locale);
      final manifest = ContentCardManifest.fromJson(json);
      if (!manifest.hasCards) {
        throw const ContentCardsRepositoryException(
          'empty_cards',
          'Content cards response contains no renderable cards.',
        );
      }
      await _cache.writeCards(surface: surface, locale: locale, json: json);
      return manifest;
    } on Object {
      if (cached != null) return cached;
      return ContentCardManifest(
        version: 'empty',
        surface: surface,
        locale: locale,
        sections: const [],
      );
    }
  }

  Future<ContentCardManifest?> _readCached({
    required String surface,
    required String locale,
  }) async {
    final json = await _cache.readCards(surface: surface, locale: locale);
    if (json == null) return null;
    final manifest = ContentCardManifest.fromJson(json);
    return manifest.hasCards ? manifest : null;
  }
}

class ContentCardsRepositoryException implements Exception {
  const ContentCardsRepositoryException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'ContentCardsRepositoryException($code, $message)';
}
