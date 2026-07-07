import 'package:flutter/material.dart';

import 'app_card.dart';

class UploadPlaceholder extends StatelessWidget {
  const UploadPlaceholder({
    required this.title,
    required this.description,
    this.onPressed,
    super.key,
  });

  final String title;
  final String description;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final enabled = onPressed != null;

    return AppCard(
      onTap: onPressed,
      borderColor: enabled
          ? colorScheme.primary.withValues(alpha: 0.32)
          : colorScheme.outlineVariant,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: enabled
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              enabled ? Icons.cloud_upload_outlined : Icons.lock_outline,
              color: enabled
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            enabled ? Icons.chevron_right : Icons.schedule,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
