import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/billing/presentation/providers/billing_providers.dart';
import '../../../../features/library/presentation/providers/library_providers.dart';
import '../../../../features/tools/domain/catalog_models.dart';
import '../../../../features/tools/presentation/providers/catalog_providers.dart';
import '../../../../features/tools/presentation/view_models/catalog_ui_mappers.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/neon_media_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider).value;
    final catalogAsync = ref.watch(catalogProvider);
    final history = ref.watch(libraryHistoryProvider).value ?? const [];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: catalogAsync.when(
          loading: () => const LoadingState(label: 'Loading effects'),
          error: (error, stackTrace) => const ErrorState(
            title: 'Effects are unavailable',
            description: 'Try refreshing the catalog a little later.',
          ),
          data: (catalog) {
            final recentProjects = history.take(3).toList();
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
                    title: heroTemplate?.title ?? 'Product UGC Hook',
                    imageUrl:
                        heroTemplate?.previewUrl ??
                        _FallbackImages.projectFallback,
                    onTap: () => heroTemplate == null
                        ? context.go(AppRoutes.create)
                        : context.push(
                            AppRoutes.templateDetail(heroTemplate.id),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                NeonSectionHeader(
                  title: 'Готовые сценарии',
                  subtitle: 'Выберите формат и начните создавать',
                  actionLabel: 'All',
                  onActionPressed: () => context.push(AppRoutes.tools),
                ),
                const SizedBox(height: 14),
                _EffectStrip(
                  items: studioPresets,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 26),
                const NeonSectionHeader(
                  title: 'Маркетинг студия',
                  subtitle: 'UGC, анбоксинг, примерка, демо',
                ),
                const SizedBox(height: 14),
                _EffectStrip(
                  items: marketingPresets,
                  compact: true,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 26),
                const NeonSectionHeader(
                  title: 'ИИ-видео студия',
                  subtitle: 'Seedance, zine-ритм и cinematic presets',
                ),
                const SizedBox(height: 14),
                _EffectStrip(
                  items: videoPresets,
                  compact: true,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 28),
                NeonSectionHeader(
                  title: 'Create Your Magic',
                  subtitle: 'Bring your imagination to life!',
                  actionLabel: 'Open',
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
                if (recentProjects.isNotEmpty) ...[
                  const SizedBox(height: 26),
                  NeonSectionHeader(
                    title: 'Recent Projects',
                    actionLabel: 'Open',
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
    context.go(AppRoutes.create);
  }

  void _showHomeMenu(BuildContext context) {
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
                title: 'All effects',
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(AppRoutes.tools);
                },
              ),
              _MenuTile(
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.profile);
                },
              ),
              _MenuTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
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
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Videos',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
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
          tooltip: 'Menu',
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
      borderRadius: 26,
      centerContent: true,
      ctaLabel: 'Try Now',
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
            borderRadius: 16,
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
    return SizedBox(
      height: 256,
      child: ListView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        children: [
          NeonMediaCard(
            title: primary?.title ?? 'Video Generation',
            imageUrl: primary?.previewUrl ?? _FallbackImages.projectFallback,
            width: 330,
            height: 256,
            borderRadius: 16,
            onTap: primary == null ? onCreate : () => onTemplate(primary!),
          ),
          const SizedBox(width: 14),
          NeonMediaCard(
            title: secondary?.title ?? 'Image Generation',
            imageUrl: secondary?.previewUrl ?? _FallbackImages.projectFallback,
            width: 210,
            height: 256,
            borderRadius: 16,
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
  const _EffectItem({required this.title, required this.imageUrl, this.route});

  final String title;
  final String imageUrl;
  final String? route;
}

class _FallbackImages {
  const _FallbackImages._();

  static const projectFallback =
      'https://storage.googleapis.com/allai-media/landing/studio-presets/v5/product-ugc-hook.webp?v=2';
}
