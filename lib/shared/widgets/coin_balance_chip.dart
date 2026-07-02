import 'package:flutter/material.dart';

class CoinBalanceChip extends StatelessWidget {
  const CoinBalanceChip({required this.label, this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.toll, size: 18),
      label: Text(label),
      tooltip: 'Coin balance',
      onPressed: onPressed,
    );
  }
}
