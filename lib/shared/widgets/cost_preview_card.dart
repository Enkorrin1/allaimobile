import 'package:flutter/material.dart';

import 'app_card.dart';

class CostPreviewCard extends StatelessWidget {
  const CostPreviewCard({
    required this.costLabel,
    required this.reserveCopy,
    this.warning,
    super.key,
  });

  final String costLabel;
  final String reserveCopy;
  final String? warning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.toll, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(costLabel, style: theme.textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reserveCopy,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (warning != null) ...[
            const SizedBox(height: 10),
            Text(
              warning!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
