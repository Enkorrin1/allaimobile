class PublicCatalogSanitizationException implements Exception {
  const PublicCatalogSanitizationException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'PublicCatalogSanitizationException($code, $message)';
}

Map<String, dynamic> sanitizePublicCatalogJson(Map<String, dynamic> raw) {
  final modes = _list(raw, 'modes').map(_sanitizeMode).toList();
  final models = _list(raw, 'models').map(_sanitizeModel).toList();
  final templates = _list(raw, 'templates').map(_sanitizeTemplate).toList();
  final categories = _list(raw, 'categories').map(_sanitizeCategory).toList();
  final updatedAt = _string(raw, 'updatedAt');

  final sanitized = <String, dynamic>{
    'modes': modes,
    'models': models,
    'templates': templates,
    'categories': categories,
    'updatedAt': updatedAt,
  };
  if (raw['expiresAt'] is String) sanitized['expiresAt'] = raw['expiresAt'];
  if (raw['version'] is String) sanitized['version'] = raw['version'];

  _validateCatalog(sanitized);
  return sanitized;
}

Map<String, dynamic> _sanitizeMode(Map<String, dynamic> raw) {
  final mode = <String, dynamic>{
    'id': _string(raw, 'id'),
    'title': _string(raw, 'title'),
    'category': _enumValue(raw, 'category', _modelCategories),
    'order': _int(raw, 'order'),
  };
  if (raw['isEnabled'] is bool) mode['isEnabled'] = raw['isEnabled'];
  return mode;
}

Map<String, dynamic> _sanitizeModel(Map<String, dynamic> raw) {
  final model = <String, dynamic>{
    'id': _string(raw, 'id'),
    'name': _string(raw, 'name'),
    'category': _enumValue(raw, 'category', _modelCategories),
    'description': _string(raw, 'description'),
    'supportedInputs': _stringList(raw, 'supportedInputs')
        .map((value) => _allowed(value, _supportedInputs, 'supportedInputs'))
        .toList(),
    'supportedOutputs': _stringList(raw, 'supportedOutputs')
        .map((value) => _allowed(value, _supportedOutputs, 'supportedOutputs'))
        .toList(),
    'capabilities': _sanitizeCapabilities(_map(raw, 'capabilities')),
    'isAvailable': _bool(raw, 'isAvailable'),
    'cost': _sanitizeCost(_map(raw, 'cost')),
  };
  if (raw['providerLabel'] is String) {
    model['providerLabel'] = raw['providerLabel'];
  }
  if (raw['shortLabel'] is String) {
    model['shortLabel'] = raw['shortLabel'];
  }
  if (raw['thumbnailUrl'] is String) {
    model['thumbnailUrl'] = raw['thumbnailUrl'];
  }
  if (raw['availabilityReason'] is String) {
    model['availabilityReason'] = raw['availabilityReason'];
  }
  return model;
}

Map<String, dynamic> _sanitizeCapabilities(Map<String, dynamic> raw) {
  return <String, dynamic>{
    if (raw['aspectRatios'] != null)
      'aspectRatios': _stringList(raw, 'aspectRatios'),
    if (raw['durations'] != null) 'durations': _intList(raw, 'durations'),
    if (raw['qualityLevels'] != null)
      'qualityLevels': _stringList(raw, 'qualityLevels'),
    if (raw['seed'] is bool) 'seed': raw['seed'],
    if (raw['negativePrompt'] is bool) 'negativePrompt': raw['negativePrompt'],
    if (raw['referenceStrength'] is bool)
      'referenceStrength': raw['referenceStrength'],
  };
}

Map<String, dynamic> _sanitizeCost(Map<String, dynamic> raw) {
  final minCoins = _int(raw, 'minCoins');
  if (minCoins < 0) {
    _fail('backend_contract_violation', 'Catalog cost cannot be negative.');
  }
  final cost = <String, dynamic>{'minCoins': minCoins};
  if (raw['maxCoins'] != null) {
    final maxCoins = _int(raw, 'maxCoins');
    if (maxCoins < minCoins) {
      _fail(
        'backend_contract_violation',
        'Catalog max cost cannot be below min cost.',
      );
    }
    cost['maxCoins'] = maxCoins;
  }
  return cost;
}

Map<String, dynamic> _sanitizeTemplate(Map<String, dynamic> raw) {
  final template = <String, dynamic>{
    'id': _string(raw, 'id'),
    'title': _string(raw, 'title'),
    'category': _enumValue(raw, 'category', _templateCategories),
    'description': _string(raw, 'description'),
    'previewUrl': _string(raw, 'previewUrl'),
    'defaultModelId': _string(raw, 'defaultModelId'),
    'defaultPrompt': _string(raw, 'defaultPrompt'),
    'requiredInputs': _stringList(raw, 'requiredInputs'),
    'outputFormat': _enumValue(raw, 'outputFormat', _outputFormats),
  };
  if (raw['targetAspectRatio'] is String) {
    template['targetAspectRatio'] = raw['targetAspectRatio'];
  }
  if (raw['isAvailable'] is bool) {
    template['isAvailable'] = raw['isAvailable'];
  }
  if (raw['order'] is int) {
    template['order'] = raw['order'];
  }
  return template;
}

Map<String, dynamic> _sanitizeCategory(Map<String, dynamic> raw) {
  return <String, dynamic>{
    'id': _string(raw, 'id'),
    'title': _string(raw, 'title'),
    'order': _int(raw, 'order'),
  };
}

void _validateCatalog(Map<String, dynamic> catalog) {
  final modelIds = _uniqueIds(
    _list(catalog, 'models'),
    'model',
    allowEmpty: false,
  );
  _uniqueIds(_list(catalog, 'modes'), 'mode');
  _uniqueIds(_list(catalog, 'templates'), 'template');
  _uniqueIds(_list(catalog, 'categories'), 'category');

  for (final template in _list(catalog, 'templates')) {
    final defaultModelId = _string(template, 'defaultModelId');
    if (!modelIds.contains(defaultModelId)) {
      _fail(
        'backend_contract_violation',
        'Template points to an unknown default model.',
      );
    }
  }

  try {
    DateTime.parse(_string(catalog, 'updatedAt'));
    if (catalog['expiresAt'] is String) {
      DateTime.parse(catalog['expiresAt'] as String);
    }
  } on FormatException {
    _fail('catalog_parse_failed', 'Catalog timestamp is invalid.');
  }
}

Set<String> _uniqueIds(
  List<Map<String, dynamic>> items,
  String entity, {
  bool allowEmpty = true,
}) {
  if (!allowEmpty && items.isEmpty) {
    _fail('catalog_empty', 'Catalog $entity list is empty.');
  }

  final ids = <String>{};
  for (final item in items) {
    final id = _string(item, 'id');
    if (!ids.add(id)) {
      _fail('backend_contract_violation', 'Catalog $entity id is duplicated.');
    }
  }
  return ids;
}

List<Map<String, dynamic>> _list(Map<String, dynamic> raw, String key) {
  final value = raw[key];
  if (value is! List) {
    _fail('catalog_parse_failed', 'Catalog field "$key" must be a list.');
  }
  return value.map((item) {
    if (item is Map<String, dynamic>) return item;
    if (item is Map) return Map<String, dynamic>.from(item);
    _fail('catalog_parse_failed', 'Catalog list "$key" contains invalid item.');
  }).toList();
}

Map<String, dynamic> _map(Map<String, dynamic> raw, String key) {
  final value = raw[key];
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  _fail('catalog_parse_failed', 'Catalog field "$key" must be an object.');
}

String _string(Map<String, dynamic> raw, String key) {
  final value = raw[key];
  if (value is String && value.isNotEmpty) return value;
  _fail('catalog_parse_failed', 'Catalog field "$key" must be a string.');
}

int _int(Map<String, dynamic> raw, String key) {
  final value = raw[key];
  if (value is int) return value;
  _fail('catalog_parse_failed', 'Catalog field "$key" must be an integer.');
}

bool _bool(Map<String, dynamic> raw, String key) {
  final value = raw[key];
  if (value is bool) return value;
  _fail('catalog_parse_failed', 'Catalog field "$key" must be a boolean.');
}

List<String> _stringList(Map<String, dynamic> raw, String key) {
  final value = raw[key];
  if (value is List && value.every((item) => item is String)) {
    return value.cast<String>();
  }
  _fail('catalog_parse_failed', 'Catalog field "$key" must be a string list.');
}

List<int> _intList(Map<String, dynamic> raw, String key) {
  final value = raw[key];
  if (value is List && value.every((item) => item is int)) {
    return value.cast<int>();
  }
  _fail(
    'catalog_parse_failed',
    'Catalog field "$key" must be an integer list.',
  );
}

String _enumValue(Map<String, dynamic> raw, String key, Set<String> allowed) {
  return _allowed(_string(raw, key), allowed, key);
}

String _allowed(String value, Set<String> allowed, String key) {
  if (allowed.contains(value)) return value;
  _fail('catalog_parse_failed', 'Catalog field "$key" has unknown value.');
}

Never _fail(String code, String message) {
  throw PublicCatalogSanitizationException(code, message);
}

const _modelCategories = {'image', 'video', 'upscale', 'avatar', 'motion'};
const _supportedInputs = {'prompt', 'image', 'video', 'reference'};
const _supportedOutputs = {'image', 'video'};
const _templateCategories = {
  'ugc',
  'cinema',
  'try_on',
  'unboxing',
  'beauty',
  'social_hook',
};
const _outputFormats = {'image', 'video'};
