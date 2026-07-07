import 'package:flutter/material.dart';

class ResultActionBar extends StatelessWidget {
  const ResultActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        _ActionChip(
          label: 'Сохранить',
          icon: Icons.download_outlined,
          feedback: 'Сохранение появится в следующем обновлении',
        ),
        _ActionChip(
          label: 'Поделиться',
          icon: Icons.ios_share_outlined,
          feedback: 'Поделиться результатом можно будет в следующем обновлении',
        ),
        _ActionChip(
          label: 'Повторить',
          icon: Icons.repeat,
          feedback: 'Повтор генерации появится в следующем обновлении',
        ),
        _ActionChip(
          label: 'Источник скоро',
          icon: Icons.add_photo_alternate_outlined,
          enabled: false,
        ),
        _ActionChip(
          label: 'Улучшить скоро',
          icon: Icons.hd_outlined,
          enabled: false,
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    this.feedback,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final String? feedback;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      onPressed: enabled
          ? () {
              final message = feedback;
              if (message == null) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(message)));
            }
          : null,
    );
  }
}
