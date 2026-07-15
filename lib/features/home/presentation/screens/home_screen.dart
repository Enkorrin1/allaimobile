import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/billing/presentation/providers/billing_providers.dart';
import '../../../../features/content_cards/domain/content_card_models.dart';
import '../../../../features/content_cards/presentation/providers/content_cards_providers.dart';
import '../../../../features/favorites/presentation/providers/favorites_providers.dart';
import '../../../../features/library/domain/library_history_item.dart';
import '../../../../features/library/presentation/providers/library_providers.dart';
import '../../../../features/tools/domain/catalog_models.dart';
import '../../../../features/tools/presentation/providers/catalog_providers.dart';
import '../../../../features/tools/presentation/view_models/catalog_ui_mappers.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/neon_media_card.dart';
import '../view_models/home_library_sections.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider).value;
    final catalogAsync = ref.watch(catalogProvider);
    final contentCardsAsync = ref.watch(mobileContentCardsProvider);
    final history = ref.watch(libraryHistoryProvider).value ?? const [];
    final favorites = ref.watch(favoritesControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: catalogAsync.when(
          loading: () => LoadingState(label: l10n.homeLoadingEffects),
          error: (error, stackTrace) => ErrorState(
            title: l10n.homeEffectsUnavailableTitle,
            description: l10n.homeEffectsUnavailableDescription,
          ),
          data: (catalog) {
            final librarySections = HomeLibrarySections.fromHistory(history);
            final activeJobs = librarySections.active;
            final recentProjects = librarySections.recentResults;
            final contentManifest = contentCardsAsync.asData?.value;
            final contentSections = contentManifest?.sections ?? const [];
            final remoteHome = _contentSection(contentSections, 'home');
            final remoteShowcase = _contentSection(contentSections, 'showcase');
            final remoteExplore = _contentSection(contentSections, 'explore');
            final remoteHero = remoteHome == null || remoteHome.cards.isEmpty
                ? null
                : remoteHome.cards.first;
            final remoteHomeItems = _itemsForContentCards(
              remoteHome?.cards.skip(1).toList() ?? const [],
              limit: 8,
            );
            final remoteShowcaseItems = _itemsForContentCards(
              remoteShowcase?.cards ?? const [],
              limit: 12,
            );
            final remoteExploreItems = _itemsForContentCards(
              remoteExplore?.cards ?? const [],
              limit: 12,
            );
            final favoriteItems = <_EffectItem>[
              for (final template in catalog.templates)
                if (favorites.hasTemplate(template.id))
                  _EffectItem(
                    title: template.title,
                    imageUrl: template.previewUrl,
                    route: AppRoutes.templateDetail(template.id),
                  ),
              for (final model in catalog.models)
                if (favorites.hasModel(model.id))
                  _EffectItem(
                    title: model.name,
                    imageUrl:
                        model.thumbnailUrl ?? _FallbackImages.projectFallback,
                    route: AppRoutes.toolDetail(model.id),
                  ),
            ];
            final heroTemplate =
                _templateById(catalog, 'product-ugc-hook') ??
                (catalog.templates.isEmpty ? null : catalog.templates.first);
            final studioPresets = _itemsForTemplates(catalog, const [
              'product-ugc-hook',
              'sparkle-dress',
              'movie-heroes-cinema',
              'virtual-try-on',
              'ghost-crowd',
              'social-hook-cut',
            ]);
            final marketingPresets = _itemsForTemplates(catalog, const [
              'ugc',
              'beauty-hook',
              'try-on',
              'unboxing',
            ]);
            final videoPresets = _itemsForTemplates(catalog, const [
              'zine-rhythm',
              'stadium-fan-cam',
              'airport-paparazzi',
              'yard-carousel',
              'lomo-home-movie',
            ]);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 0, 116),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: _TopBar(
                    balanceLabel: balance == null
                        ? 'PRO'
                        : formatCoins(balance.availableCoins),
                    onPro: () => context.push(AppRoutes.pricing),
                    onMenu: () => _showHomeMenu(context),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: _HeroShowcase(
                    title:
                        remoteHero?.title ??
                        heroTemplate?.title ??
                        'Product UGC Hook',
                    imageUrl:
                        remoteHero?.displayImageUrl ??
                        heroTemplate?.previewUrl ??
                        _FallbackImages.projectFallback,
                    onTap: () {
                      if (remoteHero != null) {
                        _openEffect(context, _itemForContentCard(remoteHero));
                        return;
                      }
                      if (heroTemplate == null) {
                        context.go(AppRoutes.create);
                        return;
                      }
                      context.push(AppRoutes.templateDetail(heroTemplate.id));
                    },
                  ),
                ),
                const SizedBox(height: 24),
                NeonSectionHeader(
                  title: remoteHome?.title.isNotEmpty == true
                      ? remoteHome!.title
                      : l10n.homeReadyScenariosTitle,
                  subtitle: l10n.homeReadyScenariosSubtitle,
                  actionLabel: l10n.homeActionAll,
                  onActionPressed: () => context.push(AppRoutes.tools),
                ),
                const SizedBox(height: 14),
                _EffectStrip(
                  items: remoteHomeItems.isNotEmpty
                      ? remoteHomeItems
                      : studioPresets,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 26),
                NeonSectionHeader(
                  title: remoteShowcase?.title.isNotEmpty == true
                      ? remoteShowcase!.title
                      : l10n.homeMarketingTitle,
                  subtitle: l10n.homeMarketingSubtitle,
                ),
                const SizedBox(height: 14),
                _EffectStrip(
                  items: remoteShowcaseItems.isNotEmpty
                      ? remoteShowcaseItems
                      : marketingPresets,
                  compact: true,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 26),
                NeonSectionHeader(
                  title: remoteExplore?.title.isNotEmpty == true
                      ? remoteExplore!.title
                      : l10n.homeVideoStudioTitle,
                  subtitle: l10n.homeVideoStudioSubtitle,
                ),
                const SizedBox(height: 14),
                _EffectStrip(
                  items: remoteExploreItems.isNotEmpty
                      ? remoteExploreItems
                      : videoPresets,
                  compact: true,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 28),
                NeonSectionHeader(
                  title: l10n.homeMagicTitle,
                  subtitle: l10n.homeMagicSubtitle,
                  actionLabel: l10n.homeActionOpen,
                  onActionPressed: () => context.go(AppRoutes.create),
                ),
                const SizedBox(height: 16),
                _MagicStrip(
                  primary: _templateById(catalog, 'zine-rhythm'),
                  secondary: _templateById(catalog, 'virtual-try-on'),
                  onCreate: () => context.go(AppRoutes.create),
                  onTemplate: (template) =>
                      context.push(AppRoutes.templateDetail(template.id)),
                ),
                if (favoriteItems.isNotEmpty) ...[
                  const SizedBox(height: 26),
                  NeonSectionHeader(
                    title: l10n.favoritesTitle,
                    actionLabel: l10n.homeActionAll,
                    onActionPressed: () => context.push(AppRoutes.tools),
                  ),
                  const SizedBox(height: 14),
                  _EffectStrip(
                    items: favoriteItems,
                    compact: true,
                    onTap: (item) => _openEffect(context, item),
                  ),
                ],
                if (activeJobs.isNotEmpty) ...[
                  const SizedBox(height: 26),
                  NeonSectionHeader(
                    title: l10n.homeActiveJobsTitle,
                    subtitle: l10n.homeActiveJobsSubtitle,
                    actionLabel: l10n.homeActionOpen,
                    onActionPressed: () => context.go(AppRoutes.library),
                  ),
                  const SizedBox(height: 14),
                  _ActiveJobStrip(
                    jobs: activeJobs,
                    onTap: (jobId) => context.push(AppRoutes.result(jobId)),
                  ),
                ],
                if (recentProjects.isNotEmpty) ...[
                  const SizedBox(height: 26),
                  NeonSectionHeader(
                    title: l10n.homeRecentProjectsTitle,
                    actionLabel: l10n.homeActionOpen,
                    onActionPressed: () => context.go(AppRoutes.library),
                  ),
                  const SizedBox(height: 14),
                  _EffectStrip(
                    items: [
                      for (final project in recentProjects)
                        _EffectItem(
                          title: project.template?.title ?? project.model.name,
                          imageUrl:
                              project.outputAsset?.thumbnailUrl ??
                              project.outputAsset?.url ??
                              _FallbackImages.projectFallback,
                          route: AppRoutes.result(
                            project.outputAsset?.id ?? project.job.id,
                          ),
                        ),
                    ],
                    compact: true,
                    onTap: (item) => context.push(item.route!),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  void _openEffect(BuildContext context, _EffectItem item) {
    if (item.route != null) {
      context.push(item.route!);
      return;
    }
    if (item.prompt != null && item.prompt!.trim().isNotEmpty) {
      context.go(
        AppRoutes.createDraft(
          format: item.format ?? 'video',
          modelId: item.modelId,
          prompt: item.prompt,
        ),
      );
      return;
    }
    context.go(AppRoutes.create);
  }

  void _showHomeMenu(BuildContext context) {
    final l10n = context.l10n;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF111113),
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MenuTile(
                icon: Icons.widgets_outlined,
                title: l10n.homeAllEffects,
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(AppRoutes.tools);
                },
              ),
              _MenuTile(
                icon: Icons.person_outline,
                title: l10n.profileTitle,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.profile);
                },
              ),
              _MenuTile(
                icon: Icons.settings_outlined,
                title: l10n.settingsTitle,
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(AppRoutes.settings);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Template? _templateById(CatalogResponse catalog, String id) {
    for (final template in catalog.templates) {
      if (template.id == id) return template;
    }
    return null;
  }

  List<_EffectItem> _itemsForTemplates(
    CatalogResponse catalog,
    List<String> ids,
  ) {
    final byId = {
      for (final template in catalog.templates) template.id: template,
    };
    return [
      for (final id in ids)
        if (byId[id] case final template?)
          _EffectItem(
            title: template.title,
            imageUrl: template.previewUrl,
            route: AppRoutes.templateDetail(template.id),
          ),
    ];
  }

  ContentCardSection? _contentSection(
    List<ContentCardSection> sections,
    String id,
  ) {
    for (final section in sections) {
      if (section.id == id && section.cards.isNotEmpty) return section;
    }
    return null;
  }

  List<_EffectItem> _itemsForContentCards(
    List<ContentCard> cards, {
    required int limit,
  }) {
    return cards.take(limit).map(_itemForContentCard).toList();
  }

  _EffectItem _itemForContentCard(ContentCard card) {
    return _EffectItem(
      title: card.title,
      imageUrl: card.displayImageUrl,
      format: card.routeFormat,
      modelId: _normalizeModelId(card.generation.modelSlug),
      prompt: card.generation.promptTemplate,
    );
  }

  String? _normalizeModelId(String value) {
    final normalized = value.trim().toLowerCase().replaceAll(' ', '-');
    return normalized.isEmpty ? null : normalized;
  }
}

class _ActiveJobStrip extends StatelessWidget {
  const _ActiveJobStrip({required this.jobs, required this.onTap});

  final List<LibraryHistoryItem> jobs;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 138,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: jobs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = jobs[index];
          final progress = (item.job.progress ?? 0).clamp(0.0, 1.0);
          final accent = modelCategoryColor(item.model.category);
          return Material(
            color: const Color(0xFF151517),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              key: Key('home-active-job-${item.job.id}'),
              borderRadius: BorderRadius.circular(8),
              onTap: () => onTap(item.job.id),
              child: SizedBox(
                width: 262,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: accent, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.template?.title ?? item.model.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            context.l10n.homeJobProgress(
                              (progress * 100).round(),
                            ),
                            style: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        item.job.prompt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: allAiMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        color: accent,
                        backgroundColor: Colors.white12,
                        borderRadius: BorderRadius.circular(2),
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

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.balanceLabel,
    required this.onPro,
    required this.onMenu,
  });

  final String balanceLabel;
  final VoidCallback onPro;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.homeTitleVideos,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ),
        Material(
          color: allAiNeon,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onPro,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.black, size: 17),
                  const SizedBox(width: 5),
                  Text(
                    balanceLabel == 'PRO' ? 'PRO' : balanceLabel,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        IconButton(
          tooltip: l10n.commonMenu,
          onPressed: onMenu,
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 32),
        ),
      ],
    );
  }
}

class _HeroShowcase extends StatelessWidget {
  const _HeroShowcase({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NeonMediaCard(
      title: title,
      imageUrl: imageUrl,
      width: double.infinity,
      height: 330,
      borderRadius: 8,
      centerContent: true,
      ctaLabel: context.l10n.homeTryNow,
      onTap: onTap,
    );
  }
}

class _EffectStrip extends StatelessWidget {
  const _EffectStrip({
    required this.items,
    required this.onTap,
    this.compact = false,
  });

  final List<_EffectItem> items;
  final ValueChanged<_EffectItem> onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 145 : 248,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = items[index];
          return NeonMediaCard(
            title: item.title,
            imageUrl: item.imageUrl,
            width: compact ? 154 : 198,
            height: compact ? 145 : 248,
            borderRadius: 8,
            onTap: () => onTap(item),
          );
        },
      ),
    );
  }
}

class _MagicStrip extends StatelessWidget {
  const _MagicStrip({
    required this.primary,
    required this.secondary,
    required this.onCreate,
    required this.onTemplate,
  });

  final Template? primary;
  final Template? secondary;
  final VoidCallback onCreate;
  final ValueChanged<Template> onTemplate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: 256,
      child: ListView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        children: [
          NeonMediaCard(
            title: primary?.title ?? l10n.generatorTitleVideo,
            imageUrl: primary?.previewUrl ?? _FallbackImages.projectFallback,
            width: 330,
            height: 256,
            borderRadius: 8,
            onTap: primary == null ? onCreate : () => onTemplate(primary!),
          ),
          const SizedBox(width: 14),
          NeonMediaCard(
            title: secondary?.title ?? l10n.generatorTitleImage,
            imageUrl: secondary?.previewUrl ?? _FallbackImages.projectFallback,
            width: 210,
            height: 256,
            borderRadius: 8,
            onTap: secondary == null ? onCreate : () => onTemplate(secondary!),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: allAiNeon),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
    );
  }
}

class _EffectItem {
  const _EffectItem({
    required this.title,
    required this.imageUrl,
    this.route,
    this.format,
    this.modelId,
    this.prompt,
  });

  final String title;
  final String imageUrl;
  final String? route;
  final String? format;
  final String? modelId;
  final String? prompt;
}

class _FallbackImages {
  const _FallbackImages._();

  static const projectFallback =
      'https://storage.googleapis.com/allai-media/landing/studio-presets/v5/product-ugc-hook.webp?v=2';
}
