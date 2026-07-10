import 'package:flutter/material.dart';

class DemoTool {
  const DemoTool({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.supportedInputs,
    required this.outputType,
    required this.estimatedCost,
    required this.available,
    required this.icon,
    required this.accentColor,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final List<String> supportedInputs;
  final String outputType;
  final int estimatedCost;
  final bool available;
  final IconData icon;
  final Color accentColor;
}

class DemoTemplate {
  const DemoTemplate({
    required this.id,
    required this.title,
    required this.badge,
    required this.description,
    required this.requiredInputs,
    required this.defaultToolId,
    required this.estimatedCost,
    required this.icon,
    required this.accentColor,
  });

  final String id;
  final String title;
  final String badge;
  final String description;
  final List<String> requiredInputs;
  final String defaultToolId;
  final int estimatedCost;
  final IconData icon;
  final Color accentColor;
}

const demoTools = [
  DemoTool(
    id: 'photo-studio',
    name: 'NanoBanana',
    category: 'Фото',
    description: 'Редактура, ремикс и управляемые вариации изображения.',
    supportedInputs: ['Промпт', 'Референс'],
    outputType: 'Изображение',
    estimatedCost: 80,
    available: true,
    icon: Icons.image_outlined,
    accentColor: Color(0xFF2857FF),
  ),
  DemoTool(
    id: 'video-hook',
    name: 'Kling',
    category: 'Видео',
    description: 'Кинематографичное AI-видео по промпту или стартовому кадру.',
    supportedInputs: ['Промпт', 'Фото-источник'],
    outputType: 'Видео',
    estimatedCost: 240,
    available: true,
    icon: Icons.video_camera_back_outlined,
    accentColor: Color(0xFFE55C5C),
  ),
  DemoTool(
    id: 'upscale-clean',
    name: 'Topaz Image Upscale',
    category: 'Апскейл',
    description: 'Апскейл фото с фокусом на резкость и восстановление деталей.',
    supportedInputs: ['Изображение'],
    outputType: 'Изображение',
    estimatedCost: 60,
    available: true,
    icon: Icons.hd_outlined,
    accentColor: Color(0xFF16B887),
  ),
  DemoTool(
    id: 'avatar-try-on',
    name: 'Kling Talking Avatar',
    category: 'Аватары',
    description: 'Говорящие аватары с lip-sync и digital-presenter подачей.',
    supportedInputs: ['Промпт', 'Референс'],
    outputType: 'Серия изображений',
    estimatedCost: 140,
    available: true,
    icon: Icons.person_search_outlined,
    accentColor: Color(0xFF7C4DFF),
  ),
  DemoTool(
    id: 'motion-lite',
    name: 'Wan Motion Transfer',
    category: 'Движение',
    description: 'Перенос движения на персонажа или объект.',
    supportedInputs: ['Изображение', 'Motion prompt'],
    outputType: 'Видео',
    estimatedCost: 180,
    available: true,
    icon: Icons.motion_photos_on_outlined,
    accentColor: Color(0xFFE6A700),
  ),
];

const demoTemplates = [
  DemoTemplate(
    id: 'product-ugc-hook',
    title: 'Product UGC Hook',
    badge: 'P0',
    description: 'Вертикальный hook с продуктом, коротким обещанием и CTA.',
    requiredInputs: ['Фото продукта', 'Преимущество', 'Аудитория'],
    defaultToolId: 'video-hook',
    estimatedCost: 240,
    icon: Icons.movie_creation_outlined,
    accentColor: Color(0xFFE55C5C),
  ),
  DemoTemplate(
    id: 'social-hook-cut',
    title: 'Social Hook Cut',
    badge: 'P0',
    description: 'Быстрый opening кадр для TikTok, Reels и Shorts.',
    requiredInputs: ['Промпт', 'Формат', 'Главный claim'],
    defaultToolId: 'video-hook',
    estimatedCost: 220,
    icon: Icons.cut_outlined,
    accentColor: Color(0xFF2857FF),
  ),
  DemoTemplate(
    id: 'try-on',
    title: 'Try-On',
    badge: 'P0',
    description: 'Визуальная примерка товара или образа на модели.',
    requiredInputs: ['Референс продукта', 'Стиль модели'],
    defaultToolId: 'avatar-try-on',
    estimatedCost: 140,
    icon: Icons.checkroom_outlined,
    accentColor: Color(0xFF7C4DFF),
  ),
  DemoTemplate(
    id: 'unboxing',
    title: 'Unboxing',
    badge: 'P0',
    description: 'Сцена распаковки с фокусом на детали и ощущение покупки.',
    requiredInputs: ['Фото продукта', 'Настроение', 'Сцена'],
    defaultToolId: 'photo-studio',
    estimatedCost: 100,
    icon: Icons.inventory_2_outlined,
    accentColor: Color(0xFF16B887),
  ),
  DemoTemplate(
    id: 'beauty-hook',
    title: 'Beauty Hook',
    badge: 'P0',
    description: 'Первый кадр для beauty-продукта с чистым premium look.',
    requiredInputs: ['Продукт', 'Тон кожи', 'Преимущество'],
    defaultToolId: 'photo-studio',
    estimatedCost: 120,
    icon: Icons.face_retouching_natural,
    accentColor: Color(0xFFE6A700),
  ),
  DemoTemplate(
    id: 'ugc',
    title: 'UGC',
    badge: 'P0',
    description: 'Натуральный creator-style кадр для performance creatives.',
    requiredInputs: ['Продукт', 'Аудитория', 'Hook'],
    defaultToolId: 'video-hook',
    estimatedCost: 180,
    icon: Icons.groups_2_outlined,
    accentColor: Color(0xFF2857FF),
  ),
  DemoTemplate(
    id: 'movie-heroes-cinema',
    title: 'Movie Heroes Cinema',
    badge: 'Demo',
    description: 'Кадр в кинозале рядом с героями мультика.',
    requiredInputs: ['Промпт', 'Фото человека', 'Кинозал'],
    defaultToolId: 'photo-studio',
    estimatedCost: 160,
    icon: Icons.local_movies_outlined,
    accentColor: Color(0xFF171A20),
  ),
];

DemoTool? demoToolById(String id) {
  for (final tool in demoTools) {
    if (tool.id == id) return tool;
  }
  return null;
}

DemoTemplate? demoTemplateById(String id) {
  for (final template in demoTemplates) {
    if (template.id == id) return template;
  }
  return null;
}
