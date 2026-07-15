class ContentCardManifest {
  const ContentCardManifest({
    required this.version,
    required this.surface,
    required this.locale,
    required this.sections,
  });

  final String version;
  final String surface;
  final String locale;
  final List<ContentCardSection> sections;

  bool get hasCards => sections.any((section) => section.cards.isNotEmpty);

  factory ContentCardManifest.fromJson(Map<String, dynamic> json) {
    return ContentCardManifest(
      version: json['version'] as String? ?? 'unknown',
      surface: json['surface'] as String? ?? 'mobile',
      locale: json['locale'] as String? ?? 'ru',
      sections: _list(json['sections'])
          .map(ContentCardSection.fromJson)
          .where((section) => section.cards.isNotEmpty)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'surface': surface,
    'locale': locale,
    'sections': sections.map((section) => section.toJson()).toList(),
  };
}

class ContentCardSection {
  const ContentCardSection({
    required this.id,
    required this.title,
    required this.cards,
  });

  final String id;
  final String title;
  final List<ContentCard> cards;

  factory ContentCardSection.fromJson(Map<String, dynamic> json) {
    return ContentCardSection(
      id: json['id'] as String? ?? 'section',
      title: json['title'] as String? ?? '',
      cards: _list(
        json['cards'],
      ).map(ContentCard.fromJson).where((card) => card.isRenderable).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'cards': cards.map((card) => card.toJson()).toList(),
  };
}

class ContentCard {
  const ContentCard({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.category,
    required this.modelName,
    required this.media,
    required this.action,
    required this.generation,
  });

  final String id;
  final String kind;
  final String title;
  final String description;
  final String category;
  final String modelName;
  final ContentCardMedia media;
  final ContentCardAction action;
  final ContentCardGeneration generation;

  bool get isRenderable => id.isNotEmpty && title.isNotEmpty && media.hasPoster;

  String get displayImageUrl =>
      media.posterUrl.isNotEmpty ? media.posterUrl : media.previewUrl;

  String get routeFormat {
    if (media.type == 'image') return 'image';
    if (media.type == 'video') return 'video';
    return category == 'motion' ? 'motion' : 'image';
  }

  factory ContentCard.fromJson(Map<String, dynamic> json) {
    return ContentCard(
      id: json['id'] as String? ?? '',
      kind: json['kind'] as String? ?? 'creative',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      modelName: json['modelName'] as String? ?? '',
      media: ContentCardMedia.fromJson(_map(json['media'])),
      action: ContentCardAction.fromJson(_map(json['action'])),
      generation: ContentCardGeneration.fromJson(_map(json['generation'])),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind,
    'title': title,
    'description': description,
    'category': category,
    'modelName': modelName,
    'media': media.toJson(),
    'action': action.toJson(),
    'generation': generation.toJson(),
  };
}

class ContentCardMedia {
  const ContentCardMedia({
    required this.type,
    required this.posterUrl,
    required this.previewUrl,
  });

  final String type;
  final String posterUrl;
  final String previewUrl;

  bool get hasPoster =>
      posterUrl.isNotEmpty || type == 'image' && previewUrl.isNotEmpty;

  factory ContentCardMedia.fromJson(Map<String, dynamic> json) {
    return ContentCardMedia(
      type: json['type'] as String? ?? 'image',
      posterUrl: json['posterUrl'] as String? ?? '',
      previewUrl: json['previewUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'posterUrl': posterUrl,
    if (previewUrl.isNotEmpty) 'previewUrl': previewUrl,
  };
}

class ContentCardAction {
  const ContentCardAction({required this.type, required this.presetId});

  final String type;
  final String presetId;

  factory ContentCardAction.fromJson(Map<String, dynamic> json) {
    return ContentCardAction(
      type: json['type'] as String? ?? '',
      presetId: json['presetId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    if (presetId.isNotEmpty) 'presetId': presetId,
  };
}

class ContentCardGeneration {
  const ContentCardGeneration({
    required this.modelSlug,
    required this.promptTemplate,
  });

  final String modelSlug;
  final String promptTemplate;

  factory ContentCardGeneration.fromJson(Map<String, dynamic> json) {
    return ContentCardGeneration(
      modelSlug: json['modelSlug'] as String? ?? '',
      promptTemplate: json['promptTemplate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    if (modelSlug.isNotEmpty) 'modelSlug': modelSlug,
    if (promptTemplate.isNotEmpty) 'promptTemplate': promptTemplate,
  };
}

List<Map<String, dynamic>> _list(Object? value) {
  if (value is! List) return const [];
  return [
    for (final item in value)
      if (item is Map<String, dynamic>)
        item
      else if (item is Map)
        Map<String, dynamic>.from(item),
  ];
}

Map<String, dynamic> _map(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const {};
}
