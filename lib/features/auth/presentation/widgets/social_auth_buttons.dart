import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/auth_models.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({
    required this.isSubmitting,
    required this.onProviderSelected,
    this.showDivider = true,
    super.key,
  });

  final bool isSubmitting;
  final ValueChanged<SocialAuthProvider> onProviderSelected;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        if (showDivider) ...[
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                  l10n.authOrContinueWith,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        _SocialAuthButton(
          key: const Key('social-google-button'),
          label: l10n.authContinueWithGoogle,
          icon: const _GoogleMark(),
          onPressed: isSubmitting
              ? null
              : () => onProviderSelected(SocialAuthProvider.google),
        ),
        const SizedBox(height: AppSpacing.sm),
        _SocialAuthButton(
          key: const Key('social-apple-button'),
          label: l10n.authContinueWithApple,
          icon: const Icon(Icons.apple, size: 22),
          onPressed: isSubmitting
              ? null
              : () => onProviderSelected(SocialAuthProvider.apple),
        ),
      ],
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHighest,
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outlineVariant),
          minimumSize: const Size.fromHeight(54),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Flexible(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return Text(
      'G',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
