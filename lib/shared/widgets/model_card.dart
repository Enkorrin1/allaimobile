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

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: accentColor.withValues(alpha: 0.12),
                foregroundColor: accentColor,
                child: Icon(icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
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
            style: theme.textTheme.bodyMedium,
          ),
          if (!available && availabilityDescription != null) ...[
            const SizedBox(height: 8),
            Text(
              availabilityDescription!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(costLabel, style: theme.textTheme.labelLarge),
        ],
      ),
    );
  }
}
