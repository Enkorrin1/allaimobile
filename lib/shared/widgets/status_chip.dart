import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({required this.label, required this.icon, super.key});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: theme.colorScheme.outlineVariant),
    );
  }
}
