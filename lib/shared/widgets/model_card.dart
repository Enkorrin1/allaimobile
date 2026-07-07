import 'package:flutter/material.dart';

import 'app_card.dart';
import 'status_chip.dart';

class ModelCard extends StatelessWidget {
  const ModelCard({
    required this.name,
    required this.category,
    required this.description,
    required this.costLabel,
    required this.icon,
    required this.accentColor,
    required this.available,
    this.availabilityLabel,
    this.availabilityDescription,
    this.onTap,
    super.key,
  });

  final String name;
  final String category;
  final String description;
  final String costLabel;
  final IconData icon;
  final Color accentColor;
  final bool available;
  final String? availabilityLabel;
  final String? availabilityDescription;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      borderColor: available
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
                  color: accentColor.withValues(alpha: available ? 0.14 : 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: available ? accentColor : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusChip(
                label: availabilityLabel ?? (available ? 'Готово' : 'Скоро'),
                icon: available ? Icons.check_circle_outline : Icons.schedule,
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
          if (!available && availabilityDescription != null) ...[
            const SizedBox(height: 8),
            Text(
              availabilityDescription!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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
              if (onTap != null)
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
