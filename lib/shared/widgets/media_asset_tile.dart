import 'package:flutter/material.dart';

import 'app_card.dart';
import 'status_chip.dart';

class MediaAssetTile extends StatelessWidget {
  const MediaAssetTile({
    required this.title,
    required this.kind,
    required this.status,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.onTap,
    this.preview,
    super.key,
  });

  final String title;
  final String kind;
  final String status;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;
  final Widget? preview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.25,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Stack(
                children: [
                  if (preview != null)
                    Positioned.fill(child: preview!)
                  else
                    Center(child: Icon(icon, size: 42, color: accentColor)),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: StatusChip(label: kind, icon: icon),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                StatusChip(
                  label: status,
                  icon:
                      status == 'Failed' ||
                          status == 'Ошибка' ||
                          status == 'РћС€РёР±РєР°'
                      ? Icons.error_outline
                      : Icons.check_circle_outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
