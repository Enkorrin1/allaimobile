import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final card = Card(
      color: color ?? theme.colorScheme.surface,
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) return card;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: card,
    );
  }
}
