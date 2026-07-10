import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import 'app_button.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.title,
    required this.description,
    this.onRetry,
    this.actionLabel,
    this.actionIcon = Icons.refresh,
    super.key,
  });

  final String title;
  final String description;
  final VoidCallback? onRetry;
  final String? actionLabel;
  final IconData actionIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.error_outline,
                size: 30,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              AppButton(
                label: actionLabel ?? context.l10n.commonRetry,
                icon: actionIcon,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
