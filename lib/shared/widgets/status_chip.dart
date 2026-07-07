import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    required this.icon,
    this.selected = false,
    this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final labelWidget = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (onPressed != null) {
      return FilterChip(
        avatar: Icon(icon, size: 16),
        label: labelWidget,
        selected: selected,
        onSelected: (_) => onPressed?.call(),
        showCheckmark: false,
        visualDensity: VisualDensity.compact,
        selectedColor: colorScheme.primaryContainer,
        side: BorderSide(
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
        ),
      );
    }

    return Chip(
      avatar: Icon(icon, size: 16),
      label: labelWidget,
      visualDensity: VisualDensity.compact,
      backgroundColor: selected ? colorScheme.primaryContainer : null,
      side: BorderSide(
        color: selected ? colorScheme.primary : colorScheme.outlineVariant,
      ),
    );
  }
}
