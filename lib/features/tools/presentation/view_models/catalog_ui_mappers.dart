import 'package:flutter/material.dart';

import '../../../generation_jobs/domain/generation_job_models.dart';
import '../../domain/catalog_models.dart';

IconData modelCategoryIcon(AiModelCategory category) => switch (category) {
  AiModelCategory.image => Icons.image_outlined,
  AiModelCategory.video => Icons.video_camera_back_outlined,
  AiModelCategory.upscale => Icons.hd_outlined,
  AiModelCategory.avatar => Icons.person_search_outlined,
  AiModelCategory.motion => Icons.motion_photos_on_outlined,
};

Color modelCategoryColor(AiModelCategory category) => switch (category) {
  AiModelCategory.image => const Color(0xFF2857FF),
  AiModelCategory.video => const Color(0xFFE55C5C),
  AiModelCategory.upscale => const Color(0xFF16B887),
  AiModelCategory.avatar => const Color(0xFF7C4DFF),
  AiModelCategory.motion => const Color(0xFFE6A700),
};

String modelCategoryLabel(AiModelCategory category) => switch (category) {
  AiModelCategory.image => 'Фото',
  AiModelCategory.video => 'Видео',
  AiModelCategory.upscale => 'Апскейл',
  AiModelCategory.avatar => 'Аватары',
  AiModelCategory.motion => 'Движение',
};

IconData templateIcon(TemplateCategory category) => switch (category) {
  TemplateCategory.ugc => Icons.groups_2_outlined,
  TemplateCategory.cinema => Icons.local_movies_outlined,
  TemplateCategory.tryOn => Icons.checkroom_outlined,
  TemplateCategory.unboxing => Icons.inventory_2_outlined,
  TemplateCategory.beauty => Icons.face_retouching_natural,
  TemplateCategory.socialHook => Icons.cut_outlined,
};

Color templateColor(TemplateCategory category) => switch (category) {
  TemplateCategory.ugc => const Color(0xFFE55C5C),
  TemplateCategory.cinema => const Color(0xFF171A20),
  TemplateCategory.tryOn => const Color(0xFF7C4DFF),
  TemplateCategory.unboxing => const Color(0xFF16B887),
  TemplateCategory.beauty => const Color(0xFFE6A700),
  TemplateCategory.socialHook => const Color(0xFF2857FF),
};

String templateBadge(Template template) {
  return template.id == 'cinema' ? 'Demo' : 'P0';
}

String modelAvailabilityLabel(AiModel model) {
  if (model.isAvailable) return 'Готово';
  return model.availabilityReason == null ? 'Скоро' : 'Недоступно';
}

String modelAvailabilityDescription(AiModel model) {
  return model.availabilityReason ??
      'Модель появится после обновления каталога.';
}

String templateAvailabilityLabel(Template template) {
  return template.isAvailable ? templateBadge(template) : 'Скоро';
}

String costLabel(CoinCost cost) {
  if (cost.maxCoins != null) {
    return 'от ${cost.minCoins} до ${cost.maxCoins} койнов';
  }
  return 'от ${cost.minCoins} койнов';
}

String requiredInputLabel(String input) => switch (input) {
  'prompt' => 'Промпт',
  'product_image' => 'Фото продукта',
  'person_image' => 'Фото человека',
  'reference_image' => 'Референс',
  _ => input,
};

String supportedInputLabel(SupportedInput input) => switch (input) {
  SupportedInput.prompt => 'Промпт',
  SupportedInput.image => 'Изображение',
  SupportedInput.video => 'Видео',
  SupportedInput.reference => 'Референс',
};

String supportedOutputLabel(SupportedOutput output) => switch (output) {
  SupportedOutput.image => 'Изображение',
  SupportedOutput.video => 'Видео',
};

IconData assetIcon(AssetType type) => switch (type) {
  AssetType.image => Icons.image_outlined,
  AssetType.video => Icons.play_circle_outline,
};

String assetKindLabel(AssetType type) => switch (type) {
  AssetType.image => 'Фото',
  AssetType.video => 'Видео',
};

String jobStatusLabel(GenerationJobStatus status) => switch (status) {
  GenerationJobStatus.draft => 'Черновик',
  GenerationJobStatus.validating => 'Проверяем',
  GenerationJobStatus.queued => 'В очереди',
  GenerationJobStatus.running => 'Генерируем',
  GenerationJobStatus.processing => 'Сохраняем результат',
  GenerationJobStatus.completed => 'Готово',
  GenerationJobStatus.failed => 'Ошибка',
  GenerationJobStatus.canceled => 'Отменено',
  GenerationJobStatus.refunded => 'Возврат',
};

String formatCoins(int coins) {
  final value = coins.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < value.length; i += 1) {
    final remaining = value.length - i;
    buffer.write(value[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(' ');
  }
  return buffer.toString();
}

String formatDateLabel(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')} $hour:$minute';
}
