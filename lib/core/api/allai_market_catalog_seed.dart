const allAiMarketMedia = _AllAiMarketMedia._();

class _AllAiMarketMedia {
  const _AllAiMarketMedia._();

  final productUgc =
      'https://storage.googleapis.com/allai-media/landing/studio-presets/v5/product-ugc-hook.webp?v=2';
  final sparkleDress =
      'https://storage.googleapis.com/allai-media/landing/studio-presets/v4/glam-sparkle-dress.webp?v=1';
  final movieHeroes =
      'https://storage.googleapis.com/allai-media/landing/studio-presets/v4/movie-heroes-cinema.webp?v=1';
  final virtualTryOn =
      'https://storage.googleapis.com/allai-media/landing/studio-presets/v5/virtual-try-on.webp?v=2';
  final ghostCrowd =
      'https://storage.googleapis.com/allai-media/landing/studio-presets/v5/ghost-crowd.webp?v=2';
  final socialHook =
      'https://storage.googleapis.com/allai-media/landing/studio-presets/v5/social-hook-cut.webp?v=2';
  final ugcCreator =
      'https://storage.googleapis.com/allai-media/landing/creatives/v2/ugc-creator.webp?v=2';
  final ugcBeauty =
      'https://storage.googleapis.com/allai-media/landing/creatives/v2/ugc-beauty.webp?v=2';
  final fashionTryOn =
      'https://storage.googleapis.com/allai-media/landing/creatives/v2/fashion-tryon.webp?v=2';
  final unboxing =
      'https://storage.googleapis.com/allai-media/landing/creatives/v2/unboxing.webp?v=2';
  final zine =
      'https://storage.googleapis.com/allai-media/landing/creatives/v1/zine-photo.webp';
  final stadium =
      'https://storage.googleapis.com/allai-media/landing/creatives/v1/stadium-photo.webp';
  final paparazzi =
      'https://storage.googleapis.com/allai-media/landing/creatives/v1/paparazzi-photo.webp';
  final carousel =
      'https://storage.googleapis.com/allai-media/landing/creatives/v1/carousel-photo.webp';
  final lomo =
      'https://storage.googleapis.com/allai-media/landing/creatives/v1/lomo-photo.webp';
}

final Map<String, dynamic> allAiMarketCatalogJson = {
  'modes': [
    {'id': 'photo', 'title': 'Фото', 'category': 'image', 'order': 1},
    {'id': 'video', 'title': 'Видео', 'category': 'video', 'order': 2},
    {'id': 'upscale', 'title': 'Апскейл', 'category': 'upscale', 'order': 3},
    {'id': 'avatar', 'title': 'Аватары', 'category': 'avatar', 'order': 4},
    {
      'id': 'motion',
      'title': 'Движение',
      'category': 'motion',
      'order': 5,
      'isEnabled': true,
    },
  ],
  'models': [
    _imageModel(
      id: 'photo-studio',
      name: 'NanoBanana',
      shortLabel: 'Редактура - ремикс',
      description:
          'Лучшее всего для редактуры, ремикса и управляемых вариаций изображения.',
      thumbnailUrl: allAiMarketMedia.productUgc,
      minCoins: 80,
      referenceStrength: true,
      negativePrompt: true,
    ),
    _imageModel(
      id: 'seedream',
      name: 'Seedream',
      shortLabel: 'Быстро - чистый кадр',
      description:
          'Быстрые чистые кадры для рекламы, портретов и продуктовых сцен.',
      thumbnailUrl: allAiMarketMedia.sparkleDress,
      minCoins: 80,
      referenceStrength: true,
    ),
    _imageModel(
      id: 'grok-image',
      name: 'Grok Image',
      shortLabel: 'Дерзко - stylized',
      description:
          'Выразительные stylized-кадры, когда нужен характер и визуальный удар.',
      thumbnailUrl: allAiMarketMedia.movieHeroes,
      minCoins: 80,
      negativePrompt: true,
    ),
    _imageModel(
      id: 'flux',
      name: 'Flux',
      shortLabel: 'Контроль - детали',
      description:
          'Гибкий промптинг с более точным контролем композиции и деталей.',
      thumbnailUrl: allAiMarketMedia.virtualTryOn,
      minCoins: 80,
      negativePrompt: true,
      seed: true,
    ),
    _imageModel(
      id: 'wan-image',
      name: 'Wan Image',
      shortLabel: 'Киношный реализм',
      description:
          'Киношный реализм, сложный свет и премиальный вид итогового кадра.',
      thumbnailUrl: allAiMarketMedia.ghostCrowd,
      minCoins: 80,
      referenceStrength: true,
    ),
    _imageModel(
      id: 'gpt-image',
      name: 'GPT Image',
      shortLabel: 'Универсал - правки',
      description:
          'Универсальная генерация и редактура изображений с сильным пониманием промпта.',
      thumbnailUrl: allAiMarketMedia.socialHook,
      minCoins: 80,
      referenceStrength: true,
    ),
    _videoModel(
      id: 'video-hook',
      name: 'Kling',
      shortLabel: 'Киновидео',
      description:
          'Кинематографичное AI-видео по промпту или стартовому кадру.',
      thumbnailUrl: allAiMarketMedia.productUgc,
      minCoins: 240,
    ),
    _videoModel(
      id: 'seedance',
      name: 'Seedance',
      shortLabel: 'Ритм - темп',
      description:
          'Клиповая динамика и ритмичные сцены, когда важен темп и вайб.',
      thumbnailUrl: allAiMarketMedia.zine,
      minCoins: 180,
    ),
    _videoModel(
      id: 'grok-video',
      name: 'Grok Video',
      shortLabel: 'Дерзко - stylized',
      description:
          'Яркие stylized-видео с более дерзким визуальным характером.',
      thumbnailUrl: allAiMarketMedia.stadium,
      minCoins: 180,
    ),
    _videoModel(
      id: 'gemini-omni',
      name: 'Gemini Omni',
      shortLabel: 'Мультимодал',
      description:
          'Мультимодальный video-workflow, когда нужна гибкость входных данных.',
      thumbnailUrl: allAiMarketMedia.paparazzi,
      minCoins: 220,
      referenceStrength: true,
      highQuality: true,
    ),
    _videoModel(
      id: 'wan-text-video',
      name: 'Wan Text to Video',
      shortLabel: 'Text/Image - видео',
      description:
          'Видео Wan 2.7: text/image/reference-to-video и редактирование видео.',
      thumbnailUrl: allAiMarketMedia.carousel,
      minCoins: 220,
      referenceStrength: true,
      highQuality: true,
    ),
    _videoModel(
      id: 'hailuo',
      name: 'Hailuo',
      shortLabel: 'Быстрые клипы',
      description:
          'Быстрая генерация видео для простого движения и коротких сцен.',
      thumbnailUrl: allAiMarketMedia.lomo,
      minCoins: 160,
    ),
    _videoModel(
      id: 'veo',
      name: 'Veo',
      shortLabel: 'Polished motion',
      description:
          'Качественный video-output с более polished кинематографичным видом.',
      thumbnailUrl: allAiMarketMedia.ugcCreator,
      minCoins: 260,
      highQuality: true,
      durations: [4, 6, 8],
    ),
    _videoModel(
      id: 'runway',
      name: 'Runway',
      shortLabel: 'Motion-дизайн',
      description:
          'Сильный вариант для motion-дизайна, продуктовых сцен и controlled movement.',
      thumbnailUrl: allAiMarketMedia.ugcBeauty,
      minCoins: 240,
      highQuality: true,
    ),
    _videoModel(
      id: 'sora',
      name: 'Sora',
      shortLabel: 'Премиум-сцены',
      description: 'Премиальное видео для более режиссёрских и сложных сцен.',
      thumbnailUrl: allAiMarketMedia.fashionTryOn,
      minCoins: 300,
      highQuality: true,
      durations: [4, 6, 8],
    ),
    {
      'id': 'upscale-clean',
      'name': 'Topaz Image Upscale',
      'providerLabel': 'AllAi',
      'shortLabel': 'Резкость - детали',
      'thumbnailUrl': allAiMarketMedia.virtualTryOn,
      'category': 'upscale',
      'description':
          'Апскейл фото, когда важнее всего резкость и восстановление деталей.',
      'supportedInputs': ['image'],
      'supportedOutputs': ['image'],
      'capabilities': {
        'qualityLevels': ['standard', 'high'],
      },
      'isAvailable': true,
      'cost': {'minCoins': 60},
    },
    {
      'id': 'topaz-video-upscale',
      'name': 'Topaz Video Upscale',
      'providerLabel': 'AllAi',
      'shortLabel': 'Апскейл видео',
      'thumbnailUrl': allAiMarketMedia.zine,
      'category': 'upscale',
      'description':
          'Апскейл видео для более чистой детализации, фактуры и ясности.',
      'supportedInputs': ['video'],
      'supportedOutputs': ['video'],
      'capabilities': {
        'qualityLevels': ['standard', 'high'],
      },
      'isAvailable': true,
      'cost': {'minCoins': 180},
    },
    {
      'id': 'avatar-try-on',
      'name': 'Kling Talking Avatar',
      'providerLabel': 'AllAi',
      'shortLabel': 'Говорящие аватары',
      'thumbnailUrl': allAiMarketMedia.fashionTryOn,
      'category': 'avatar',
      'description':
          'Говорящие аватары с lip-sync и подачей в стиле digital-presenter.',
      'supportedInputs': ['prompt', 'reference'],
      'supportedOutputs': ['image'],
      'capabilities': {
        'aspectRatios': ['4:5', '1:1'],
        'qualityLevels': ['standard'],
        'referenceStrength': true,
      },
      'isAvailable': true,
      'cost': {'minCoins': 140},
    },
    {
      'id': 'motion-lite',
      'name': 'Wan Motion Transfer',
      'providerLabel': 'AllAi',
      'shortLabel': 'Перенос движения',
      'thumbnailUrl': allAiMarketMedia.carousel,
      'category': 'motion',
      'description':
          'Перенос движения на персонажа или объект, когда важна motion-логика.',
      'supportedInputs': ['image', 'prompt'],
      'supportedOutputs': ['video'],
      'capabilities': {
        'aspectRatios': ['9:16'],
        'durations': [4],
      },
      'isAvailable': true,
      'cost': {'minCoins': 180},
    },
    {
      'id': 'kling-motion-control',
      'name': 'Kling Motion Control',
      'providerLabel': 'AllAi',
      'shortLabel': 'Контроль движения',
      'thumbnailUrl': allAiMarketMedia.stadium,
      'category': 'motion',
      'description':
          'Перенос движения с видео-донора на персонажа — точный motion control.',
      'supportedInputs': ['image', 'video', 'prompt'],
      'supportedOutputs': ['video'],
      'capabilities': {
        'aspectRatios': ['9:16'],
        'durations': [4, 6],
        'referenceStrength': true,
      },
      'isAvailable': true,
      'cost': {'minCoins': 220},
    },
  ],
  'templates': [
    _template(
      id: 'product-ugc-hook',
      title: 'Product UGC Hook',
      category: 'ugc',
      description:
          'Цепляющая UGC-реклама — твой продукт в живых руках, хук в первую секунду.',
      previewUrl: allAiMarketMedia.productUgc,
      defaultModelId: 'video-hook',
      defaultPrompt:
          'Сделай короткий UGC-ролик: продукт в руках, сильный хук в первую секунду, понятный CTA.',
      requiredInputs: ['prompt', 'product_image'],
      outputFormat: 'video',
      targetAspectRatio: '9:16',
      order: 1,
    ),
    _template(
      id: 'sparkle-dress',
      title: 'Sparkle Dress',
      category: 'cinema',
      description:
          'Глянцевый портрет с вечеринки как с обложки — ты, снятая как для Vogue.',
      previewUrl: allAiMarketMedia.sparkleDress,
      defaultModelId: 'photo-studio',
      defaultPrompt:
          'Глянцевый портрет с вечеринки, fashion editorial, вспышка, блеск ткани, обложечный look.',
      requiredInputs: ['prompt', 'person_image'],
      outputFormat: 'image',
      targetAspectRatio: '9:16',
      order: 2,
    ),
    _template(
      id: 'movie-heroes-cinema',
      title: 'Movie Heroes Cinema',
      category: 'cinema',
      description:
          'Ты в кинозале рядом с героями мультика — будто случайный кадр на телефон.',
      previewUrl: allAiMarketMedia.movieHeroes,
      defaultModelId: 'photo-studio',
      defaultPrompt:
          'Кинозал, случайный кадр на телефон, человек рядом с героями мультфильма, теплый экранный свет.',
      requiredInputs: ['prompt', 'person_image'],
      outputFormat: 'image',
      targetAspectRatio: '9:16',
      order: 3,
    ),
    _template(
      id: 'virtual-try-on',
      title: 'Virtual Try-On',
      category: 'try_on',
      description:
          'Твой продукт в естественной носке — чистый lifestyle-кадр примерки.',
      previewUrl: allAiMarketMedia.virtualTryOn,
      defaultModelId: 'avatar-try-on',
      defaultPrompt:
          'Покажи продукт в естественной носке, чистый lifestyle-кадр, реалистичная примерка.',
      requiredInputs: ['prompt', 'product_image', 'person_image'],
      outputFormat: 'image',
      targetAspectRatio: '4:5',
      order: 4,
    ),
    _template(
      id: 'ghost-crowd',
      title: 'Ghost Crowd',
      category: 'cinema',
      description:
          'Ты чёткий и неподвижный, толпа размыта вокруг — кинематографично и одиноко.',
      previewUrl: allAiMarketMedia.ghostCrowd,
      defaultModelId: 'photo-studio',
      defaultPrompt:
          'Четкий неподвижный герой, толпа вокруг размыта движением, кинематографичный одинокий кадр.',
      requiredInputs: ['prompt', 'person_image'],
      outputFormat: 'image',
      targetAspectRatio: '9:16',
      order: 5,
    ),
    _template(
      id: 'social-hook-cut',
      title: 'Social Hook Cut',
      category: 'social_hook',
      description:
          'Быстрый клиповый social-ролик — сильный хук, показ продукта, чёткий финал.',
      previewUrl: allAiMarketMedia.socialHook,
      defaultModelId: 'video-hook',
      defaultPrompt:
          'Собери быстрый social hook: открывающий кадр, продукт, короткий финальный CTA.',
      requiredInputs: ['prompt', 'product_image'],
      outputFormat: 'video',
      targetAspectRatio: '9:16',
      order: 6,
    ),
    _template(
      id: 'ugc',
      title: 'UGC',
      category: 'ugc',
      description: 'Натуральный creator-style кадр для performance creatives.',
      previewUrl: allAiMarketMedia.ugcCreator,
      defaultModelId: 'video-hook',
      defaultPrompt:
          'Натуральный creator-style UGC-ролик для продукта, живые руки, простой монтаж.',
      requiredInputs: ['prompt', 'product_image'],
      outputFormat: 'video',
      targetAspectRatio: '9:16',
      order: 7,
    ),
    _template(
      id: 'beauty-hook',
      title: 'Beauty Hook',
      category: 'beauty',
      description: 'Первый кадр для beauty-продукта с чистым premium look.',
      previewUrl: allAiMarketMedia.ugcBeauty,
      defaultModelId: 'photo-studio',
      defaultPrompt:
          'Beauty hero shot с мягким светом, premium look, чистый продуктовый кадр.',
      requiredInputs: ['prompt', 'product_image'],
      outputFormat: 'image',
      targetAspectRatio: '4:5',
      order: 8,
    ),
    _template(
      id: 'try-on',
      title: 'Try-On',
      category: 'try_on',
      description: 'Примерка образа или продукта в fashion/lifestyle подаче.',
      previewUrl: allAiMarketMedia.fashionTryOn,
      defaultModelId: 'avatar-try-on',
      defaultPrompt:
          'Покажи образ на модели в fashion/lifestyle подаче, чистый свет и естественная посадка.',
      requiredInputs: ['prompt', 'product_image', 'person_image'],
      outputFormat: 'image',
      targetAspectRatio: '4:5',
      order: 9,
    ),
    _template(
      id: 'unboxing',
      title: 'Unboxing',
      category: 'unboxing',
      description: 'Сцена распаковки с фокусом на детали и ощущение покупки.',
      previewUrl: allAiMarketMedia.unboxing,
      defaultModelId: 'photo-studio',
      defaultPrompt:
          'Сцена распаковки продукта с акцентом на детали, руки, упаковку и ощущение покупки.',
      requiredInputs: ['prompt', 'product_image'],
      outputFormat: 'image',
      targetAspectRatio: '9:16',
      order: 10,
    ),
    _template(
      id: 'zine-rhythm',
      title: 'Zine-ритм',
      category: 'social_hook',
      description: 'Коллажные склейки, постерные кадры, клиповый темп.',
      previewUrl: allAiMarketMedia.zine,
      defaultModelId: 'seedance',
      defaultPrompt:
          'Быстрый zine-клип с контрастными вырезками, постерными кадрами и клиповым темпом.',
      requiredInputs: ['prompt', 'source_image'],
      outputFormat: 'video',
      targetAspectRatio: '9:16',
      order: 11,
    ),
    _template(
      id: 'stadium-fan-cam',
      title: 'Стадионная fan-cam',
      category: 'cinema',
      description:
          'Кадр в стиле стадионной fan-cam: человек в светящейся толпе.',
      previewUrl: allAiMarketMedia.stadium,
      defaultModelId: 'seedance',
      defaultPrompt:
          'Стадионная fan-cam, человек в светящейся толпе, живой шум и handheld-энергия.',
      requiredInputs: ['prompt', 'source_image'],
      outputFormat: 'video',
      targetAspectRatio: '9:16',
      order: 12,
    ),
    _template(
      id: 'airport-paparazzi',
      title: 'Папарацци в аэропорту',
      category: 'cinema',
      description:
          'Кадр в стиле папарацци: человек идет через терминал аэропорта.',
      previewUrl: allAiMarketMedia.paparazzi,
      defaultModelId: 'seedance',
      defaultPrompt:
          'Папарацци в аэропорту, человек идет через терминал, вспышки, быстрый handheld-кадр.',
      requiredInputs: ['prompt', 'source_image'],
      outputFormat: 'video',
      targetAspectRatio: '9:16',
      order: 13,
    ),
    _template(
      id: 'yard-carousel',
      title: 'Дворовая карусель',
      category: 'cinema',
      description: 'Облет камеры вокруг друзей во дворе.',
      previewUrl: allAiMarketMedia.carousel,
      defaultModelId: 'seedance',
      defaultPrompt:
          'Облет камеры вокруг друзей во дворе, теплый вечер, естественная динамика и круговое движение.',
      requiredInputs: ['prompt', 'source_image'],
      outputFormat: 'video',
      targetAspectRatio: '9:16',
      order: 14,
    ),
    _template(
      id: 'lomo-home-movie',
      title: 'Ломо home movie',
      category: 'cinema',
      description: 'Кадр в стиле ностальгичного lomo home movie.',
      previewUrl: allAiMarketMedia.lomo,
      defaultModelId: 'seedance',
      defaultPrompt:
          'Ностальгичный lomo home movie, мягкое зерно, теплые цвета и домашняя камера.',
      requiredInputs: ['prompt', 'source_image'],
      outputFormat: 'video',
      targetAspectRatio: '9:16',
      order: 15,
    ),
  ],
  'categories': [
    {'id': 'image', 'title': 'Фото', 'order': 1},
    {'id': 'video', 'title': 'Видео', 'order': 2},
    {'id': 'upscale', 'title': 'Апскейл', 'order': 3},
    {'id': 'avatar', 'title': 'Аватары', 'order': 4},
    {'id': 'motion', 'title': 'Движение', 'order': 5},
  ],
  'version': 'allai-market-landing-2026-07-09',
  'updatedAt': '2026-07-09T00:00:00.000Z',
};

Map<String, dynamic> _imageModel({
  required String id,
  required String name,
  required String shortLabel,
  required String description,
  required String thumbnailUrl,
  required int minCoins,
  bool referenceStrength = false,
  bool negativePrompt = false,
  bool seed = false,
}) {
  return {
    'id': id,
    'name': name,
    'providerLabel': 'AllAi',
    'shortLabel': shortLabel,
    'thumbnailUrl': thumbnailUrl,
    'category': 'image',
    'description': description,
    'supportedInputs': ['prompt', 'reference'],
    'supportedOutputs': ['image'],
    'capabilities': {
      'aspectRatios': ['9:16', '1:1', '4:5'],
      'qualityLevels': ['standard', 'high'],
      if (negativePrompt) 'negativePrompt': true,
      if (referenceStrength) 'referenceStrength': true,
      if (seed) 'seed': true,
    },
    'isAvailable': true,
    'cost': {'minCoins': minCoins},
  };
}

Map<String, dynamic> _videoModel({
  required String id,
  required String name,
  required String shortLabel,
  required String description,
  required String thumbnailUrl,
  required int minCoins,
  bool referenceStrength = false,
  bool highQuality = false,
  List<int> durations = const [4, 6],
}) {
  return {
    'id': id,
    'name': name,
    'providerLabel': 'AllAi',
    'shortLabel': shortLabel,
    'thumbnailUrl': thumbnailUrl,
    'category': 'video',
    'description': description,
    'supportedInputs': referenceStrength
        ? ['prompt', 'image', 'reference']
        : ['prompt', 'image'],
    'supportedOutputs': ['video'],
    'capabilities': {
      'aspectRatios': ['9:16', '1:1', '16:9'],
      'durations': durations,
      'qualityLevels': highQuality ? ['standard', 'high'] : ['standard'],
      if (referenceStrength) 'referenceStrength': true,
    },
    'isAvailable': true,
    'cost': {'minCoins': minCoins},
  };
}

Map<String, dynamic> _template({
  required String id,
  required String title,
  required String category,
  required String description,
  required String previewUrl,
  required String defaultModelId,
  required String defaultPrompt,
  required List<String> requiredInputs,
  required String outputFormat,
  required String targetAspectRatio,
  required int order,
}) {
  return {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'previewUrl': previewUrl,
    'defaultModelId': defaultModelId,
    'defaultPrompt': defaultPrompt,
    'requiredInputs': requiredInputs,
    'outputFormat': outputFormat,
    'targetAspectRatio': targetAspectRatio,
    'order': order,
    'isAvailable': true,
  };
}
