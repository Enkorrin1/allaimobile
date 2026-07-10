enum AiModelCategory { image, video, upscale, avatar, motion }

enum SupportedInput { prompt, image, video, reference }

enum SupportedOutput { image, video }

enum TemplateCategory { ugc, cinema, tryOn, unboxing, beauty, socialHook }

enum OutputFormat { image, video }

class GenerationMode {
  const GenerationMode({
    required this.id,
    required this.title,
    required this.category,
    required this.order,
    required this.isEnabled,
  });

  final String id;
  final String title;
  final AiModelCategory category;
  final int order;
  final bool isEnabled;

  factory GenerationMode.fromJson(Map<String, dynamic> json) {
    return GenerationMode(
      id: json['id'] as String,
      title: json['title'] as String,
      category: _modelCategoryFromWire(json['category'] as String),
      order: json['order'] as int,
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category.wireValue,
    'order': order,
    'isEnabled': isEnabled,
  };
}

class CoinCost {
  const CoinCost({required this.minCoins, this.maxCoins});

  final int minCoins;
  final int? maxCoins;

  factory CoinCost.fromJson(Map<String, dynamic> json) {
    return CoinCost(
      minCoins: json['minCoins'] as int,
      maxCoins: json['maxCoins'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'minCoins': minCoins,
    if (maxCoins != null) 'maxCoins': maxCoins,
  };
}

class ModelCapabilities {
  const ModelCapabilities({
    this.aspectRatios,
    this.durations,
    this.qualityLevels,
    this.seed = false,
    this.negativePrompt = false,
    this.referenceStrength = false,
  });

  final List<String>? aspectRatios;
  final List<int>? durations;
  final List<String>? qualityLevels;
  final bool seed;
  final bool negativePrompt;
  final bool referenceStrength;

  factory ModelCapabilities.fromJson(Map<String, dynamic> json) {
    return ModelCapabilities(
      aspectRatios: (json['aspectRatios'] as List<dynamic>?)?.cast<String>(),
      durations: (json['durations'] as List<dynamic>?)?.cast<int>(),
      qualityLevels: (json['qualityLevels'] as List<dynamic>?)?.cast<String>(),
      seed: json['seed'] as bool? ?? false,
      negativePrompt: json['negativePrompt'] as bool? ?? false,
      referenceStrength: json['referenceStrength'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    if (aspectRatios != null) 'aspectRatios': aspectRatios,
    if (durations != null) 'durations': durations,
    if (qualityLevels != null) 'qualityLevels': qualityLevels,
    'seed': seed,
    'negativePrompt': negativePrompt,
    'referenceStrength': referenceStrength,
  };
}

class AiModel {
  const AiModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.supportedInputs,
    required this.supportedOutputs,
    required this.capabilities,
    required this.isAvailable,
    required this.cost,
    this.providerLabel,
    this.shortLabel,
    this.thumbnailUrl,
    this.availabilityReason,
  });

  final String id;
  final String name;
  final String? providerLabel;
  final String? shortLabel;
  final String? thumbnailUrl;
  final String? availabilityReason;
  final AiModelCategory category;
  final String description;
  final List<SupportedInput> supportedInputs;
  final List<SupportedOutput> supportedOutputs;
  final ModelCapabilities capabilities;
  final bool isAvailable;
  final CoinCost cost;

  factory AiModel.fromJson(Map<String, dynamic> json) {
    return AiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      providerLabel: json['providerLabel'] as String?,
      shortLabel: json['shortLabel'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      category: _modelCategoryFromWire(json['category'] as String),
      description: json['description'] as String,
      supportedInputs: (json['supportedInputs'] as List<dynamic>)
          .cast<String>()
          .map(_supportedInputFromWire)
          .toList(),
      supportedOutputs: (json['supportedOutputs'] as List<dynamic>)
          .cast<String>()
          .map(_supportedOutputFromWire)
          .toList(),
      capabilities: ModelCapabilities.fromJson(
        json['capabilities'] as Map<String, dynamic>,
      ),
      isAvailable: json['isAvailable'] as bool,
      cost: CoinCost.fromJson(json['cost'] as Map<String, dynamic>),
      availabilityReason: json['availabilityReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (providerLabel != null) 'providerLabel': providerLabel,
    if (shortLabel != null) 'shortLabel': shortLabel,
    if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
    'category': category.wireValue,
    'description': description,
    'supportedInputs': supportedInputs.map((input) => input.wireValue).toList(),
    'supportedOutputs': supportedOutputs
        .map((output) => output.wireValue)
        .toList(),
    'capabilities': capabilities.toJson(),
    'isAvailable': isAvailable,
    if (availabilityReason != null) 'availabilityReason': availabilityReason,
    'cost': cost.toJson(),
  };
}

class Template {
  const Template({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.previewUrl,
    required this.defaultModelId,
    required this.defaultPrompt,
    required this.requiredInputs,
    required this.outputFormat,
    this.targetAspectRatio,
    this.isAvailable = true,
    this.order,
  });

  final String id;
  final String title;
  final TemplateCategory category;
  final String description;
  final String previewUrl;
  final String defaultModelId;
  final String defaultPrompt;
  final List<String> requiredInputs;
  final OutputFormat outputFormat;
  final String? targetAspectRatio;
  final bool isAvailable;
  final int? order;

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'] as String,
      title: json['title'] as String,
      category: _templateCategoryFromWire(json['category'] as String),
      description: json['description'] as String,
      previewUrl: json['previewUrl'] as String,
      defaultModelId: json['defaultModelId'] as String,
      defaultPrompt: json['defaultPrompt'] as String,
      requiredInputs: (json['requiredInputs'] as List<dynamic>).cast<String>(),
      outputFormat: _outputFormatFromWire(json['outputFormat'] as String),
      targetAspectRatio: json['targetAspectRatio'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      order: json['order'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category.wireValue,
    'description': description,
    'previewUrl': previewUrl,
    'defaultModelId': defaultModelId,
    'defaultPrompt': defaultPrompt,
    'requiredInputs': requiredInputs,
    'outputFormat': outputFormat.wireValue,
    if (targetAspectRatio != null) 'targetAspectRatio': targetAspectRatio,
    'isAvailable': isAvailable,
    if (order != null) 'order': order,
  };
}

class CatalogCategory {
  const CatalogCategory({
    required this.id,
    required this.title,
    required this.order,
  });

  final String id;
  final String title;
  final int order;

  factory CatalogCategory.fromJson(Map<String, dynamic> json) {
    return CatalogCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'order': order};
}

class CatalogResponse {
  const CatalogResponse({
    required this.modes,
    required this.models,
    required this.templates,
    required this.categories,
    required this.updatedAt,
  });

  final List<GenerationMode> modes;
  final List<AiModel> models;
  final List<Template> templates;
  final List<CatalogCategory> categories;
  final DateTime updatedAt;

  factory CatalogResponse.fromJson(Map<String, dynamic> json) {
    return CatalogResponse(
      modes: (json['modes'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(GenerationMode.fromJson)
          .toList(),
      models: (json['models'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(AiModel.fromJson)
          .toList(),
      templates: (json['templates'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(Template.fromJson)
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(CatalogCategory.fromJson)
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'modes': modes.map((mode) => mode.toJson()).toList(),
    'models': models.map((model) => model.toJson()).toList(),
    'templates': templates.map((template) => template.toJson()).toList(),
    'categories': categories.map((category) => category.toJson()).toList(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

extension AiModelCategoryWire on AiModelCategory {
  String get wireValue => switch (this) {
    AiModelCategory.image => 'image',
    AiModelCategory.video => 'video',
    AiModelCategory.upscale => 'upscale',
    AiModelCategory.avatar => 'avatar',
    AiModelCategory.motion => 'motion',
  };
}

extension SupportedInputWire on SupportedInput {
  String get wireValue => switch (this) {
    SupportedInput.prompt => 'prompt',
    SupportedInput.image => 'image',
    SupportedInput.video => 'video',
    SupportedInput.reference => 'reference',
  };
}

extension SupportedOutputWire on SupportedOutput {
  String get wireValue => switch (this) {
    SupportedOutput.image => 'image',
    SupportedOutput.video => 'video',
  };
}

extension TemplateCategoryWire on TemplateCategory {
  String get wireValue => switch (this) {
    TemplateCategory.ugc => 'ugc',
    TemplateCategory.cinema => 'cinema',
    TemplateCategory.tryOn => 'try_on',
    TemplateCategory.unboxing => 'unboxing',
    TemplateCategory.beauty => 'beauty',
    TemplateCategory.socialHook => 'social_hook',
  };
}

extension OutputFormatWire on OutputFormat {
  String get wireValue => switch (this) {
    OutputFormat.image => 'image',
    OutputFormat.video => 'video',
  };
}

AiModelCategory _modelCategoryFromWire(String value) => switch (value) {
  'image' => AiModelCategory.image,
  'video' => AiModelCategory.video,
  'upscale' => AiModelCategory.upscale,
  'avatar' => AiModelCategory.avatar,
  'motion' => AiModelCategory.motion,
  _ => throw FormatException('Unknown model category: $value'),
};

SupportedInput _supportedInputFromWire(String value) => switch (value) {
  'prompt' => SupportedInput.prompt,
  'image' => SupportedInput.image,
  'video' => SupportedInput.video,
  'reference' => SupportedInput.reference,
  _ => throw FormatException('Unknown supported input: $value'),
};

SupportedOutput _supportedOutputFromWire(String value) => switch (value) {
  'image' => SupportedOutput.image,
  'video' => SupportedOutput.video,
  _ => throw FormatException('Unknown supported output: $value'),
};

TemplateCategory _templateCategoryFromWire(String value) => switch (value) {
  'ugc' => TemplateCategory.ugc,
  'cinema' => TemplateCategory.cinema,
  'try_on' => TemplateCategory.tryOn,
  'unboxing' => TemplateCategory.unboxing,
  'beauty' => TemplateCategory.beauty,
  'social_hook' => TemplateCategory.socialHook,
  _ => throw FormatException('Unknown template category: $value'),
};

OutputFormat _outputFormatFromWire(String value) => switch (value) {
  'image' => OutputFormat.image,
  'video' => OutputFormat.video,
  _ => throw FormatException('Unknown output format: $value'),
};
