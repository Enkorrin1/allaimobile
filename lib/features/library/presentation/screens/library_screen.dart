import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/neon_media_card.dart';
import '../../../generation_jobs/domain/generation_job_models.dart';
import '../../../tools/domain/catalog_models.dart';
import '../../../tools/presentation/view_models/catalog_ui_mappers.dart';
import '../../domain/library_history_item.dart';
import '../providers/library_providers.dart';

enum _LibraryFilter { all, image, video, upscale, avatar, motion, failed }

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _searchController = TextEditingController();
  _LibraryFilter _filter = _LibraryFilter.all;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

            final visibleHistory = history.where(_matches).toList();

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
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
                                  fontSize: 34,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          key: const Key('library-search-field'),
                          controller: _searchController,
                          onChanged: (value) => setState(() => _query = value),
                          decoration: InputDecoration(
                            hintText: l10n.projectsTitle,
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _query.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: l10n.commonClose,
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _query = '');
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 42,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _LibraryFilter.values.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final filter = _LibraryFilter.values[index];
                              return FilterChip(
                                key: Key('library-filter-${filter.name}'),
                                selected: _filter == filter,
                                showCheckmark: false,
                                avatar: Icon(_filterIcon(filter), size: 17),
                                label: Text(_filterLabel(context, filter)),
                                onSelected: (_) =>
                                    setState(() => _filter = filter),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 126),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.76,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _ProjectCard(item: visibleHistory[index]),
                      childCount: visibleHistory.length,
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

  bool _matches(LibraryHistoryItem item) {
    final filterMatches = switch (_filter) {
      _LibraryFilter.all => true,
      _LibraryFilter.failed => item.job.status == GenerationJobStatus.failed,
      _LibraryFilter.image => item.model.category == AiModelCategory.image,
      _LibraryFilter.video => item.model.category == AiModelCategory.video,
      _LibraryFilter.upscale => item.model.category == AiModelCategory.upscale,
      _LibraryFilter.avatar => item.model.category == AiModelCategory.avatar,
      _LibraryFilter.motion => item.model.category == AiModelCategory.motion,
    };
    if (!filterMatches) return false;
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return true;
    return item.job.prompt.toLowerCase().contains(query) ||
        item.model.name.toLowerCase().contains(query) ||
        (item.template?.title.toLowerCase().contains(query) ?? false);
  }

  IconData _filterIcon(_LibraryFilter filter) => switch (filter) {
    _LibraryFilter.all => Icons.grid_view_rounded,
    _LibraryFilter.image => Icons.image_outlined,
    _LibraryFilter.video => Icons.videocam_outlined,
    _LibraryFilter.upscale => Icons.hd_outlined,
    _LibraryFilter.avatar => Icons.person_outline,
    _LibraryFilter.motion => Icons.motion_photos_on_outlined,
    _LibraryFilter.failed => Icons.error_outline,
  };

  String _filterLabel(BuildContext context, _LibraryFilter filter) {
    final l10n = context.l10n;
    return switch (filter) {
      _LibraryFilter.all => l10n.projectsTitle,
      _LibraryFilter.image => l10n.generatorTitleImage,
      _LibraryFilter.video => l10n.generatorTitleVideo,
      _LibraryFilter.upscale => l10n.generatorTitleUpscale,
      _LibraryFilter.avatar => l10n.generatorTitleAvatar,
      _LibraryFilter.motion => l10n.generatorTitleMotion,
      _LibraryFilter.failed => l10n.generatorFailedTitle,
    };
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
      borderRadius: 8,
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 126),
      children: [
        Text(
          l10n.projectsTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 24),
        NeonMediaCard(
          title: l10n.projectsEmptyTitle,
          subtitle: l10n.projectsEmptySubtitle,
          imageUrl:
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1000&q=82',
          width: double.infinity,
          height: 390,
          borderRadius: 8,
          centerContent: true,
        ),
        const SizedBox(height: 28),
        NeonPillButton(label: l10n.projectsCreateFirst, onPressed: onCreate),
      ],
    );
  }
}
