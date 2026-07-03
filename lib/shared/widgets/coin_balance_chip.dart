import 'package:flutter/material.dart';

class CoinBalanceChip extends StatelessWidget {
  const CoinBalanceChip({
    required this.label,
    this.compactLabel,
    this.onPressed,
    this.compact = false,
    super.key,
  });

  final String label;
  final String? compactLabel;
  final VoidCallback? onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.toll, size: 18),
      label: Text(compact ? compactLabel ?? label : label),
      tooltip: label,
      onPressed: onPressed,
      visualDensity: compact ? VisualDensity.compact : null,
    );
  }
}
