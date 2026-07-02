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
  status: 'Running',
  progress: 0.62,
  description:
      'Готовим vertical video mock. Можно продолжать работу в приложении.',
);

const demoLibraryAssets = [
  DemoLibraryAsset(
    id: 'asset-product-shot',
    title: 'Product hero shot',
    kind: 'Photo',
    status: 'Completed',
    prompt: 'Clean product shot on glass table with soft daylight.',
    toolName: 'AllAI Photo Studio',
    createdAtLabel: 'Сегодня, 14:20',
    costLabel: '80 койнов',
    icon: Icons.image_outlined,
    accentColor: Color(0xFF2857FF),
  ),
  DemoLibraryAsset(
    id: 'asset-hook-video',
    title: 'Social hook cut',
    kind: 'Video',
    status: 'Completed',
    prompt: 'Fast UGC hook with product close-up and creator reaction.',
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
    kind: 'Avatar',
    status: 'Completed',
    prompt: 'Premium ecommerce model wearing the product in studio light.',
    toolName: 'Avatar Try-On',
    createdAtLabel: 'Вчера, 18:44',
    costLabel: '140 койнов',
    icon: Icons.person_search_outlined,
    accentColor: Color(0xFF7C4DFF),
  ),
  DemoLibraryAsset(
    id: 'asset-failed-motion',
    title: 'Motion draft',
    kind: 'Motion',
    status: 'Failed',
    prompt: 'Animate product package with subtle camera orbit.',
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
