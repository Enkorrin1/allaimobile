enum GenerationJobStatus {
  draft,
  validating,
  queued,
  running,
  processing,
  completed,
  failed,
  canceled,
  refunded,
}

enum AssetType { image, video }

enum AssetRole { input, output, thumbnail }

class GenerationJob {
  const GenerationJob({
    required this.id,
    required this.userId,
    required this.modelId,
    required this.status,
    required this.prompt,
    required this.inputAssetIds,
    required this.outputAssetIds,
    required this.settings,
    required this.costCoins,
    required this.createdAt,
    required this.updatedAt,
    this.templateId,
    this.progress,
    this.errorCode,
    this.errorMessage,
  });

  final String id;
  final String userId;
  final String modelId;
  final String? templateId;
  final GenerationJobStatus status;
  final String prompt;
  final List<String> inputAssetIds;
  final List<String> outputAssetIds;
  final Map<String, Object?> settings;
  final int costCoins;
  final double? progress;
  final String? errorCode;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isTerminal =>
      status == GenerationJobStatus.completed ||
      status == GenerationJobStatus.failed ||
      status == GenerationJobStatus.canceled ||
      status == GenerationJobStatus.refunded;

  GenerationJob copyWith({
    GenerationJobStatus? status,
    List<String>? outputAssetIds,
    double? progress,
    String? errorCode,
    String? errorMessage,
    DateTime? updatedAt,
  }) {
    return GenerationJob(
      id: id,
      userId: userId,
      modelId: modelId,
      templateId: templateId,
      status: status ?? this.status,
      prompt: prompt,
      inputAssetIds: inputAssetIds,
      outputAssetIds: outputAssetIds ?? this.outputAssetIds,
      settings: settings,
      costCoins: costCoins,
      progress: progress ?? this.progress,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory GenerationJob.fromJson(Map<String, dynamic> json) {
    return GenerationJob(
      id: json['id'] as String,
      userId: json['userId'] as String,
      modelId: json['modelId'] as String,
      templateId: json['templateId'] as String?,
      status: _jobStatusFromWire(json['status'] as String),
      prompt: json['prompt'] as String,
      inputAssetIds: (json['inputAssetIds'] as List<dynamic>).cast<String>(),
      outputAssetIds: (json['outputAssetIds'] as List<dynamic>).cast<String>(),
      settings: (json['settings'] as Map<String, dynamic>)
          .cast<String, Object?>(),
      costCoins: json['costCoins'] as int,
      progress: (json['progress'] as num?)?.toDouble(),
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'modelId': modelId,
    if (templateId != null) 'templateId': templateId,
    'status': status.wireValue,
    'prompt': prompt,
    'inputAssetIds': inputAssetIds,
    'outputAssetIds': outputAssetIds,
    'settings': settings,
    'costCoins': costCoins,
    if (progress != null) 'progress': progress,
    if (errorCode != null) 'errorCode': errorCode,
    if (errorMessage != null) 'errorMessage': errorMessage,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class Asset {
  const Asset({
    required this.id,
    required this.type,
    required this.role,
    required this.url,
    required this.mimeType,
    required this.createdAt,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.durationSec,
    this.sizeBytes,
  });

  final String id;
  final AssetType type;
  final AssetRole role;
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final int? durationSec;
  final String mimeType;
  final int? sizeBytes;
  final DateTime createdAt;

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String,
      type: _assetTypeFromWire(json['type'] as String),
      role: _assetRoleFromWire(json['role'] as String),
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      durationSec: json['durationSec'] as int?,
      mimeType: json['mimeType'] as String,
      sizeBytes: json['sizeBytes'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.wireValue,
    'role': role.wireValue,
    'url': url,
    if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
    if (width != null) 'width': width,
    if (height != null) 'height': height,
    if (durationSec != null) 'durationSec': durationSec,
    'mimeType': mimeType,
    if (sizeBytes != null) 'sizeBytes': sizeBytes,
    'createdAt': createdAt.toIso8601String(),
  };
}

class CreateGenerationJobInput {
  const CreateGenerationJobInput({
    required this.modelId,
    required this.prompt,
    required this.settings,
    required this.clientRequestId,
    this.templateId,
    this.inputAssetIds = const [],
  });

  final String modelId;
  final String? templateId;
  final String prompt;
  final List<String> inputAssetIds;
  final Map<String, Object?> settings;
  final String clientRequestId;

  Map<String, dynamic> toJson() => {
    'modelId': modelId,
    if (templateId != null) 'templateId': templateId,
    'prompt': prompt,
    'inputAssetIds': inputAssetIds,
    'settings': settings,
    'clientRequestId': clientRequestId,
  };
}

class CreateGenerationJobResponse {
  const CreateGenerationJobResponse({
    required this.job,
    required this.reservedCoins,
  });

  final GenerationJob job;
  final int reservedCoins;

  factory CreateGenerationJobResponse.fromJson(Map<String, dynamic> json) {
    return CreateGenerationJobResponse(
      job: GenerationJob.fromJson(json['job'] as Map<String, dynamic>),
      reservedCoins: json['reservedCoins'] as int,
    );
  }
}

class GenerationJobResponse {
  const GenerationJobResponse({required this.job, required this.assets});

  final GenerationJob job;
  final List<Asset> assets;

  factory GenerationJobResponse.fromJson(Map<String, dynamic> json) {
    return GenerationJobResponse(
      job: GenerationJob.fromJson(json['job'] as Map<String, dynamic>),
      assets: (json['assets'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(Asset.fromJson)
          .toList(),
    );
  }
}

extension GenerationJobStatusWire on GenerationJobStatus {
  String get wireValue => switch (this) {
    GenerationJobStatus.draft => 'draft',
    GenerationJobStatus.validating => 'validating',
    GenerationJobStatus.queued => 'queued',
    GenerationJobStatus.running => 'running',
    GenerationJobStatus.processing => 'processing',
    GenerationJobStatus.completed => 'completed',
    GenerationJobStatus.failed => 'failed',
    GenerationJobStatus.canceled => 'canceled',
    GenerationJobStatus.refunded => 'refunded',
  };
}

extension AssetTypeWire on AssetType {
  String get wireValue => switch (this) {
    AssetType.image => 'image',
    AssetType.video => 'video',
  };
}

extension AssetRoleWire on AssetRole {
  String get wireValue => switch (this) {
    AssetRole.input => 'input',
    AssetRole.output => 'output',
    AssetRole.thumbnail => 'thumbnail',
  };
}

GenerationJobStatus _jobStatusFromWire(String value) => switch (value) {
  'draft' => GenerationJobStatus.draft,
  'validating' => GenerationJobStatus.validating,
  'queued' => GenerationJobStatus.queued,
  'running' => GenerationJobStatus.running,
  'processing' => GenerationJobStatus.processing,
  'completed' => GenerationJobStatus.completed,
  'failed' => GenerationJobStatus.failed,
  'canceled' => GenerationJobStatus.canceled,
  'refunded' => GenerationJobStatus.refunded,
  _ => throw FormatException('Unknown generation job status: $value'),
};

AssetType _assetTypeFromWire(String value) => switch (value) {
  'image' => AssetType.image,
  'video' => AssetType.video,
  _ => throw FormatException('Unknown asset type: $value'),
};

AssetRole _assetRoleFromWire(String value) => switch (value) {
  'input' => AssetRole.input,
  'output' => AssetRole.output,
  'thumbnail' => AssetRole.thumbnail,
  _ => throw FormatException('Unknown asset role: $value'),
};
