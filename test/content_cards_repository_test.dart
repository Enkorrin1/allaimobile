import 'package:allai_mobile/core/database/app_database.dart';
import 'package:allai_mobile/features/content_cards/data/content_cards_api_data_source.dart';
import 'package:allai_mobile/features/content_cards/data/content_cards_cache_data_source.dart';
import 'package:allai_mobile/features/content_cards/data/content_cards_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('content cards parse renderable remote sections', () async {
    final database = AppDatabase.memory();
    addTearDown(database.close);
    final repository = CachedContentCardsRepository(
      _FakeCardsApiDataSource(_manifestJson),
      ContentCardsCacheDataSource(database),
    );

    final manifest = await repository.getCards(surface: 'mobile', locale: 'ru');

    expect(manifest.version, '2026-07-15.2');
    expect(manifest.sections, hasLength(1));
    expect(manifest.sections.first.cards, hasLength(1));
    expect(manifest.sections.first.cards.first.title, 'UGC-хук для товара');
  });

  test('content cards fall back to cached manifest when API fails', () async {
    final database = AppDatabase.memory();
    addTearDown(database.close);
    await ContentCardsCacheDataSource(
      database,
    ).writeCards(surface: 'mobile', locale: 'ru', json: _manifestJson);
    final repository = CachedContentCardsRepository(
      const DisabledContentCardsApiDataSource(),
      ContentCardsCacheDataSource(database),
    );

    final manifest = await repository.getCards(surface: 'mobile', locale: 'ru');

    expect(manifest.version, '2026-07-15.2');
    expect(manifest.hasCards, isTrue);
  });
}

class _FakeCardsApiDataSource implements ContentCardsApiDataSource {
  const _FakeCardsApiDataSource(this.response);

  final Map<String, dynamic> response;

  @override
  Future<Map<String, dynamic>> fetchCards({
    required String surface,
    required String locale,
  }) async {
    return response;
  }
}

final _manifestJson = {
  'version': '2026-07-15.2',
  'surface': 'mobile',
  'locale': 'ru',
  'sections': [
    {
      'id': 'home',
      'title': 'Популярные пресеты',
      'cards': [
        {
          'id': 'product-ugc-hook',
          'kind': 'preset',
          'title': 'UGC-хук для товара',
          'description': 'Цепляющая UGC-реклама.',
          'category': 'ugc',
          'modelName': 'AllAI Studio',
          'media': {
            'type': 'video',
            'posterUrl': 'https://storage.googleapis.com/allai-media/card.webp',
            'previewUrl': 'https://storage.googleapis.com/allai-media/card.mp4',
          },
          'action': {'type': 'open_generator', 'presetId': 'product-ugc-hook'},
          'generation': {
            'modelSlug': 'seedream',
            'promptTemplate': 'Create a clean product UGC video.',
          },
        },
        {
          'id': 'video-without-poster',
          'kind': 'creative',
          'title': 'Video without poster',
          'media': {
            'type': 'video',
            'previewUrl': 'https://storage.googleapis.com/allai-media/card.mp4',
          },
          'action': {'type': 'open_generator'},
          'generation': {'promptTemplate': 'Skip empty poster.'},
        },
      ],
    },
  ],
};
