import 'package:flutter/material.dart';

class DemoJob {
  const DemoJob({
    required this.id,
    required this.title,
    required this.status,
    required this.progress,
    required this.description,
  });

  final String id;
  final String title;
  final String status;
  final double progress;
  final String description;
}

class DemoLibraryAsset {
  const DemoLibraryAsset({
    required this.id,
    required this.title,
    required this.kind,
    required this.status,
    required this.prompt,
    required this.toolName,
    required this.createdAtLabel,
    required this.costLabel,
    required this.icon,
    required this.accentColor,
    this.isVideo = false,
  });

  final String id;
  final String title;
  final String kind;
  final String status;
  final String prompt;
  final String toolName;
  final String createdAtLabel;
  final String costLabel;
  final IconData icon;
  final Color accentColor;
  final bool isVideo;
}

const demoActiveJob = DemoJob(
  id: 'job-ugc-hook',
  title: 'Product UGC Hook',
  status: 'В работе',
  progress: 0.62,
  description:
      'Готовим vertical video mock. Можно продолжать работу в приложении.',
);

const demoLibraryAssets = [
  DemoLibraryAsset(
    id: 'asset-product-shot',
    title: 'Product hero shot',
    kind: 'Фото',
    status: 'Готово',
    prompt: 'Чистый product shot на стеклянном столе с мягким дневным светом.',
    toolName: 'AllAI Photo Studio',
    createdAtLabel: 'Сегодня, 14:20',
    costLabel: '80 койнов',
    icon: Icons.image_outlined,
    accentColor: Color(0xFF2857FF),
  ),
  DemoLibraryAsset(
    id: 'asset-hook-video',
    title: 'Social hook cut',
    kind: 'Видео',
    status: 'Готово',
    prompt: 'Быстрый UGC hook с close-up продукта и реакцией creator.',
    toolName: 'Video Hook Maker',
    createdAtLabel: 'Сегодня, 12:05',
    costLabel: '240 койнов',
    icon: Icons.play_circle_outline,
    accentColor: Color(0xFFE55C5C),
    isVideo: true,
  ),
  DemoLibraryAsset(
    id: 'asset-try-on',
    title: 'Try-on preview',
    kind: 'Аватар',
    status: 'Готово',
    prompt: 'Premium ecommerce модель с продуктом в студийном свете.',
    toolName: 'Avatar Try-On',
    createdAtLabel: 'Вчера, 18:44',
    costLabel: '140 койнов',
    icon: Icons.person_search_outlined,
    accentColor: Color(0xFF7C4DFF),
  ),
  DemoLibraryAsset(
    id: 'asset-failed-motion',
    title: 'Motion draft',
    kind: 'Движение',
    status: 'Ошибка',
    prompt: 'Оживить упаковку продукта с мягким движением камеры.',
    toolName: 'Motion Lite',
    createdAtLabel: 'Вчера, 10:16',
    costLabel: 'Койны возвращены',
    icon: Icons.motion_photos_on_outlined,
    accentColor: Color(0xFFE6A700),
    isVideo: true,
  ),
];

DemoLibraryAsset? demoAssetById(String id) {
  for (final asset in demoLibraryAssets) {
    if (asset.id == id) return asset;
  }
  return null;
}
