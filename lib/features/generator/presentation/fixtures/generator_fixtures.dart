import 'package:flutter/material.dart';

class DemoGenerationMode {
  const DemoGenerationMode({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.estimatedCost,
  });

  final String id;
  final String label;
  final String description;
  final IconData icon;
  final int estimatedCost;
}

const demoGenerationModes = [
  DemoGenerationMode(
    id: 'photo',
    label: 'Photo',
    description: 'Изображения для товаров, объявлений и соцсетей.',
    icon: Icons.image_outlined,
    estimatedCost: 80,
  ),
  DemoGenerationMode(
    id: 'video',
    label: 'Video',
    description: 'Короткие ролики и vertical creatives.',
    icon: Icons.video_camera_back_outlined,
    estimatedCost: 240,
  ),
  DemoGenerationMode(
    id: 'upscale',
    label: 'Upscale',
    description: 'Улучшение детализации и размера результата.',
    icon: Icons.hd_outlined,
    estimatedCost: 60,
  ),
  DemoGenerationMode(
    id: 'avatars',
    label: 'Avatars',
    description: 'Персонажи и try-on сценарии для бренда.',
    icon: Icons.person_search_outlined,
    estimatedCost: 140,
  ),
  DemoGenerationMode(
    id: 'motion',
    label: 'Motion',
    description: 'Оживление изображения и простая анимация.',
    icon: Icons.motion_photos_on_outlined,
    estimatedCost: 180,
  ),
];

const demoAdvancedSettings = [
  'Aspect 9:16',
  'Quality high',
  'Safe commercial style',
  'Notify when ready',
];
