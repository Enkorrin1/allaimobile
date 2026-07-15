import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

class ResultActionBar extends StatelessWidget {
  const ResultActionBar({
    required this.onRepeat,
    required this.onUseAsSource,
    required this.onUpscale,
    super.key,
  });

  final VoidCallback onRepeat;
  final VoidCallback onUseAsSource;
  final VoidCallback onUpscale;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ActionChip(
          label: l10n.commonRetry,
          icon: Icons.repeat,
          onPressed: onRepeat,
        ),
        _ActionChip(
          label: l10n.generatorAddImage,
          icon: Icons.add_photo_alternate_outlined,
          onPressed: onUseAsSource,
        ),
        _ActionChip(
          label: l10n.generatorTitleUpscale,
          icon: Icons.hd_outlined,
          onPressed: onUpscale,
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      onPressed: onPressed,
    );
  }
}
