import 'package:flutter/material.dart';

class ResultActionBar extends StatelessWidget {
  const ResultActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ActionChip(label: 'Save', icon: Icons.download_outlined),
        _ActionChip(label: 'Share', icon: Icons.ios_share_outlined),
        _ActionChip(label: 'Repeat', icon: Icons.repeat),
        _ActionChip(label: 'Edit', icon: Icons.edit_outlined),
        _ActionChip(label: 'Upscale', icon: Icons.hd_outlined),
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
