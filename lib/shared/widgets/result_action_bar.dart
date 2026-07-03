import 'package:flutter/material.dart';

class ResultActionBar extends StatelessWidget {
  const ResultActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ActionChip(label: 'Сохранить', icon: Icons.download_outlined),
        _ActionChip(label: 'Поделиться', icon: Icons.ios_share_outlined),
        _ActionChip(label: 'Повторить', icon: Icons.repeat),
        _ActionChip(label: 'Редактировать', icon: Icons.edit_outlined),
        _ActionChip(label: 'Улучшить', icon: Icons.hd_outlined),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {},
    );
  }
}
