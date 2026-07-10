import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/neon_media_card.dart';
import '../../../tools/presentation/view_models/catalog_ui_mappers.dart';
import '../../domain/library_history_item.dart';
import '../providers/library_providers.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(libraryHistoryProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: historyAsync.when(
          loading: () => LoadingState(label: l10n.projectsLoading),
          error: (error, stackTrace) => ErrorState(
            title: l10n.projectsUnavailableTitle,
            description: l10n.projectsUnavailableDescription,
          ),
          data: (history) {
            if (history.isEmpty) {
              return _EmptyProjects(
                onCreate: () => context.go(AppRoutes.create),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.projectsTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 44,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              ),
                            ),
                            NeonPillButton(
                              label: l10n.projectsNew,
                              icon: Icons.add,
                              expand: false,
                              height: 46,
                              onPressed: () => context.go(AppRoutes.create),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.projectsSavedCount(history.length),
                          style: const TextStyle(
                            color: allAiMuted,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 126),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.72,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ProjectCard(item: history[index]),
                      childCount: history.length,
                    ),
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

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.item});

  final LibraryHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final asset = item.outputAsset;
    final imageUrl =
        asset?.thumbnailUrl ??
        asset?.url ??
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=82';
    final targetId = asset?.id ?? item.job.id;

    return NeonMediaCard(
      title: item.template?.title ?? item.model.name,
      subtitle:
          '${jobStatusLabel(item.job.status)} · ${formatDateLabel(item.job.updatedAt)}',
      imageUrl: imageUrl,
      width: double.infinity,
      height: double.infinity,
      borderRadius: 18,
      onTap: () => context.push(AppRoutes.result(targetId)),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(30, 18, 30, 126),
      children: [
        Text(
          l10n.projectsTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 44,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 32),
        NeonMediaCard(
          title: l10n.projectsEmptyTitle,
          subtitle: l10n.projectsEmptySubtitle,
          imageUrl:
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1000&q=82',
          width: double.infinity,
          height: 520,
          borderRadius: 28,
          centerContent: true,
        ),
        const SizedBox(height: 28),
        NeonPillButton(label: l10n.projectsCreateFirst, onPressed: onCreate),
      ],
    );
  }
}
