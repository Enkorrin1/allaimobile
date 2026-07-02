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
              Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
              StatusChip(label: badge, icon: Icons.auto_awesome_outlined),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(costLabel, style: theme.textTheme.labelLarge),
        ],
      ),
    );
  }
}
