import 'package:flutter/material.dart';

import 'app_card.dart';
import 'status_chip.dart';

class TemplateCard extends StatelessWidget {
  const TemplateCard({
    required this.title,
    required this.badge,
    required this.description,
    required this.costLabel,
    required this.icon,
    required this.accentColor,
    this.onTap,
    super.key,
  });

  final String title;
  final String badge;
  final String description;
  final String costLabel;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final enabled = onTap != null;

    return AppCard(
      onTap: onTap,
      borderColor: enabled
          ? accentColor.withValues(alpha: 0.34)
          : colorScheme.outlineVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: enabled ? 0.14 : 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: enabled ? accentColor : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 8),
              StatusChip(
                label: badge,
                icon: enabled ? Icons.auto_awesome_outlined : Icons.schedule,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.toll, size: 17, color: accentColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  costLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge,
                ),
              ),
              if (enabled)
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
