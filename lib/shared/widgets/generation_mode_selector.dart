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
    final colorScheme = theme.colorScheme;

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
            child: Material(
              color: selected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onSelected(option.id),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(option.icon, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              option.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        option.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
