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
    final colorScheme = theme.colorScheme;
    final failed = _isFailedStatus(status);
    final active = _isActiveStatus(status);
    final statusIcon = failed
        ? Icons.error_outline
        : active
        ? Icons.timelapse
        : Icons.check_circle_outline;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      borderColor: failed
          ? colorScheme.error.withValues(alpha: 0.5)
          : accentColor.withValues(alpha: 0.28),
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
                    Center(child: Icon(icon, size: 46, color: accentColor)),
                  Positioned(
                    left: 10,
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        Flexible(
                          child: StatusChip(label: kind, icon: icon),
                        ),
                        const Spacer(),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: StatusChip(label: status, icon: statusIcon),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (active)
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: LinearProgressIndicator(minHeight: 3),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isFailedStatus(String value) {
    final normalized = value.toLowerCase();
    return normalized == 'failed' ||
        normalized.contains('ошиб') ||
        normalized.contains('error');
  }

  bool _isActiveStatus(String value) {
    final normalized = value.toLowerCase();
    return normalized.contains('очеред') ||
        normalized.contains('генер') ||
        normalized.contains('провер') ||
        normalized.contains('сохраня') ||
        normalized.contains('running') ||
        normalized.contains('processing') ||
        normalized.contains('queued');
  }
}
