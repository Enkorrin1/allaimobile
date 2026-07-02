import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/media_asset_tile.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../fixtures/library_fixtures.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 560 ? 2 : 1;

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.list(
                    children: [
                      Text(
                        'History and reuse',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Static library preview with completed, failed and video jobs.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusChip(label: 'All', icon: Icons.all_inclusive),
                          StatusChip(
                            label: 'Photo',
                            icon: Icons.image_outlined,
                          ),
                          StatusChip(
                            label: 'Video',
                            icon: Icons.video_camera_back_outlined,
                          ),
                          StatusChip(
                            label: 'Failed',
                            icon: Icons.error_outline,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const SectionHeader(title: 'Generated assets'),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: columns == 1 ? 1.18 : 0.86,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final asset = demoLibraryAssets[index];
                      return MediaAssetTile(
                        title: asset.title,
                        kind: asset.kind,
                        status: asset.status,
                        subtitle:
                            '${asset.createdAtLabel} • ${asset.costLabel}',
                        icon: asset.icon,
                        accentColor: asset.accentColor,
                        onTap: () => context.go(AppRoutes.result(asset.id)),
                      );
                    }, childCount: demoLibraryAssets.length),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
