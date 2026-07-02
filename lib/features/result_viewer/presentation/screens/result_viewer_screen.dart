import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/result_action_bar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../library/presentation/fixtures/library_fixtures.dart';

class ResultViewerScreen extends StatelessWidget {
  const ResultViewerScreen({required this.assetId, super.key});

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final asset = demoAssetById(assetId);
    if (asset == null) {
      return const Scaffold(
        body: ErrorState(
          title: 'Result not found',
          description: 'This static result is not available in fixtures.',
        ),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(asset.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AspectRatio(
              aspectRatio: asset.isVideo ? 9 / 14 : 1,
              child: AppCard(
                color: asset.accentColor.withValues(alpha: 0.12),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        asset.icon,
                        size: 84,
                        color: asset.accentColor,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: StatusChip(label: asset.kind, icon: asset.icon),
                    ),
                    if (asset.isVideo)
                      const Center(
                        child: CircleAvatar(
                          radius: 28,
                          child: Icon(Icons.play_arrow),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(asset.title, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              asset.prompt,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            const ResultActionBar(),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Metadata'),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  _MetadataRow(label: 'Tool', value: asset.toolName),
                  _MetadataRow(label: 'Status', value: asset.status),
                  _MetadataRow(label: 'Created', value: asset.createdAtLabel),
                  _MetadataRow(label: 'Cost', value: asset.costLabel),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Row(
                children: [
                  Icon(
                    Icons.compare_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Source/result comparison placeholder for image-to-image and upscale flows.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
