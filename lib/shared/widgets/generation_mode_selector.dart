import 'package:flutter/material.dart';

class GenerationModeOption {
  const GenerationModeOption({
    required this.id,
    required this.label,
    required this.icon,
    required this.description,
  });

  final String id;
  final String label;
  final IconData icon;
  final String description;
}

class GenerationModeSelector extends StatelessWidget {
  const GenerationModeSelector({
    required this.options,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final List<GenerationModeOption> options;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final option = options[index];
          final selected = option.id == selectedId;

          return SizedBox(
            width: 132,
            child: ChoiceChip(
              selected: selected,
              onSelected: (_) => onSelected(option.id),
              avatar: Icon(option.icon, size: 18),
              label: SizedBox(
                width: 82,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      option.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
