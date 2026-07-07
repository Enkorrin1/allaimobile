import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/billing/presentation/providers/billing_providers.dart';
import '../../../../features/library/presentation/providers/library_providers.dart';
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
            final firstTemplate = catalog.templates.isEmpty
                ? null
                : catalog.templates.first;

            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 0, 126),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: _TopBar(
                    balanceLabel: balance == null
                        ? 'PRO'
                        : formatCoins(balance.availableCoins),
                    onPro: () => context.push(AppRoutes.pricing),
                    onMenu: () => _showHomeMenu(context),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: _HeroShowcase(
                    title: 'Mermaid',
                    imageUrl: _Images.heroMermaid,
                    onTap: () => firstTemplate == null
                        ? context.go(AppRoutes.create)
                        : context.push(
                            AppRoutes.templateDetail(firstTemplate.id),
                          ),
                  ),
                ),
                const SizedBox(height: 28),
                NeonSectionHeader(
                  title: 'Most Popular',
                  subtitle: 'Animate your photos with viral effects',
                  actionLabel: 'All',
                  onActionPressed: () => context.push(AppRoutes.tools),
                ),
                const SizedBox(height: 16),
                _EffectStrip(
                  items: _popularEffects,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 30),
                NeonSectionHeader(title: 'Crazy Effects'),
                const SizedBox(height: 16),
                _EffectStrip(
                  items: _crazyEffects,
                  compact: true,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 30),
                const NeonSectionHeader(
                  title: 'Trending Effects',
                  subtitle: 'Transform your photos into masterpieces',
                ),
                const SizedBox(height: 16),
                _EffectStrip(
                  items: _trendingEffects,
                  compact: true,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 30),
                NeonSectionHeader(title: 'Motion Control'),
                const SizedBox(height: 16),
                _EffectStrip(
                  items: _motionEffects,
                  compact: true,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 30),
                NeonSectionHeader(title: 'Hyper Transform'),
                const SizedBox(height: 16),
                _EffectStrip(
                  items: _hyperEffects,
                  compact: true,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 30),
                NeonSectionHeader(title: 'New Effects'),
                const SizedBox(height: 16),
                _EffectStrip(
                  items: _newEffects,
                  compact: true,
                  onTap: (item) => _openEffect(context, item),
                ),
                const SizedBox(height: 32),
                const NeonSectionHeader(
                  title: 'Create Your Magic',
                  subtitle: 'Bring your imagination to life!',
                ),
                const SizedBox(height: 18),
                _MagicStrip(onCreate: () => context.go(AppRoutes.create)),
                if (recentProjects.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  NeonSectionHeader(
                    title: 'Recent Projects',
                    actionLabel: 'Open',
                    onActionPressed: () => context.go(AppRoutes.library),
                  ),
                  const SizedBox(height: 16),
                  _EffectStrip(
                    items: [
                      for (final project in recentProjects)
                        _EffectItem(
                          title: project.template?.title ?? project.model.name,
                          imageUrl:
                              project.outputAsset?.thumbnailUrl ??
                              project.outputAsset?.url ??
                              _Images.projectFallback,
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
              fontSize: 44,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ),
        Material(
          color: allAiNeon,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onPro,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.black, size: 17),
                  const SizedBox(width: 5),
                  Text(
                    balanceLabel == 'PRO' ? 'PRO' : balanceLabel,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 18),
        IconButton(
          tooltip: 'Menu',
          onPressed: onMenu,
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 36),
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
      subtitle: 'Try a cinematic AI video effect',
      imageUrl: imageUrl,
      width: double.infinity,
      height: 414,
      borderRadius: 28,
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
      height: compact ? 166 : 316,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final item = items[index];
          return NeonMediaCard(
            title: item.title,
            imageUrl: item.imageUrl,
            width: compact ? 186 : 238,
            height: compact ? 166 : 316,
            borderRadius: compact ? 16 : 18,
            onTap: () => onTap(item),
          );
        },
      ),
    );
  }
}

class _MagicStrip extends StatelessWidget {
  const _MagicStrip({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 314,
      child: ListView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        children: [
          NeonMediaCard(
            title: 'Video Generation',
            imageUrl: _Images.magicVideo,
            width: 406,
            height: 314,
            borderRadius: 18,
            onTap: onCreate,
          ),
          const SizedBox(width: 18),
          NeonMediaCard(
            title: 'Image Generation',
            imageUrl: _Images.magicImage,
            width: 258,
            height: 314,
            borderRadius: 18,
            onTap: onCreate,
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

class _Images {
  const _Images._();

  static const heroMermaid =
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1200&q=82';
  static const projectFallback =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=82';
  static const magicVideo =
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=82';
  static const magicImage =
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=900&q=82';
}

const _popularEffects = [
  _EffectItem(
    title: 'Face Punch',
    imageUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Steel Glow',
    imageUrl:
        'https://images.unsplash.com/photo-1495385794356-15371f348c31?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Flame',
    imageUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=700&q=82',
  ),
];

const _crazyEffects = [
  _EffectItem(
    title: 'Ghost Face',
    imageUrl:
        'https://images.unsplash.com/photo-1504703395950-b89145a5425b?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Dissolve',
    imageUrl:
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Inflate',
    imageUrl:
        'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?auto=format&fit=crop&w=700&q=82',
  ),
];

const _trendingEffects = [
  _EffectItem(
    title: 'Void',
    imageUrl:
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Bloom',
    imageUrl:
        'https://images.unsplash.com/photo-1524503033411-c9566986fc8f?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Sand',
    imageUrl:
        'https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?auto=format&fit=crop&w=700&q=82',
  ),
];

const _motionEffects = [
  _EffectItem(
    title: 'Zoom In',
    imageUrl:
        'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Arc Right',
    imageUrl:
        'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: '360 Orbit',
    imageUrl:
        'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?auto=format&fit=crop&w=700&q=82',
  ),
];

const _hyperEffects = [
  _EffectItem(
    title: 'Jokers Mist',
    imageUrl:
        'https://images.unsplash.com/photo-1512316609839-ce289d3eba0a?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Pony Tail',
    imageUrl:
        'https://images.unsplash.com/photo-1524502397800-2eeaad7c3fe5?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Long Hair',
    imageUrl:
        'https://images.unsplash.com/photo-1513379733131-47fc74b45fc7?auto=format&fit=crop&w=700&q=82',
  ),
];

const _newEffects = [
  _EffectItem(
    title: 'Hot Dance',
    imageUrl:
        'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Ghost Flame',
    imageUrl:
        'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=700&q=82',
  ),
  _EffectItem(
    title: 'Water Pour',
    imageUrl:
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=700&q=82',
  ),
];
