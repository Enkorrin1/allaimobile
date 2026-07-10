import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/l10n.dart';
import '../router/app_routes.dart';
import '../../shared/widgets/neon_media_card.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    _precacheCreateImages(context);

    final action = await showModalBottomSheet<_CreateAction>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.76),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _CreateSheet(),
    );

    if (!context.mounted || action == null) return;

    switch (action) {
      case _CreateAction.video:
        context.go('${AppRoutes.create}?format=video');
      case _CreateAction.image:
        context.go('${AppRoutes.create}?format=image');
      case _CreateAction.motion:
        context.go('${AppRoutes.create}?format=motion');
      case _CreateAction.effects:
        context.push(AppRoutes.tools);
    }
  }

  void _precacheCreateImages(BuildContext context) {
    for (final option in _createSheetOptions) {
      unawaited(
        precacheImage(
          CachedNetworkImageProvider(option.imageUrl),
          context,
        ).timeout(const Duration(milliseconds: 900)).catchError((_) {}),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: navigationShell.currentIndex == 1
          ? null
          : _NeonBottomBar(
              currentIndex: navigationShell.currentIndex,
              onHome: () => _goBranch(0),
              onCreate: () => _openCreateSheet(context),
              onProjects: () => _goBranch(2),
            ),
    );
  }
}

enum _CreateAction { video, image, effects, motion }

class _CreateOptionData {
  const _CreateOptionData({required this.imageUrl, required this.action});

  final String imageUrl;
  final _CreateAction action;
}

const _createSheetOptions = [
  _CreateOptionData(
    imageUrl:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1200&q=82',
    action: _CreateAction.video,
  ),
  _CreateOptionData(
    imageUrl:
        'https://images.unsplash.com/photo-1495385794356-15371f348c31?auto=format&fit=crop&w=700&q=82',
    action: _CreateAction.image,
  ),
  _CreateOptionData(
    imageUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=700&q=82',
    action: _CreateAction.effects,
  ),
  _CreateOptionData(
    imageUrl:
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=700&q=82',
    action: _CreateAction.motion,
  ),
];

class _NeonBottomBar extends StatelessWidget {
  const _NeonBottomBar({
    required this.currentIndex,
    required this.onHome,
    required this.onCreate,
    required this.onProjects,
  });

  final int currentIndex;
  final VoidCallback onHome;
  final VoidCallback onCreate;
  final VoidCallback onProjects;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Color(0xFF202024))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 82 + bottomPadding,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BottomItem(
                  label: l10n.navHome,
                  icon: Icons.movie_creation_outlined,
                  selected: currentIndex == 0,
                  onTap: onHome,
                ),
                _CreateButton(onTap: onCreate, selected: currentIndex == 1),
                _BottomItem(
                  label: l10n.navProjects,
                  icon: Icons.video_library_outlined,
                  selected: currentIndex == 2,
                  onTap: onProjects,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? allAiNeon : const Color(0xFF6F6F76);

    return SizedBox(
      width: 86,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onTap, required this.selected});

  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      height: 62,
      child: Material(
        color: allAiNeon,
        borderRadius: BorderRadius.circular(31),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Icon(
            selected ? Icons.add_circle : Icons.add,
            color: Colors.black,
            size: 32,
          ),
        ),
      ),
    );
  }
}

class _CreateSheet extends StatelessWidget {
  const _CreateSheet();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final maxHeight = screen.height * 0.64;
    final l10n = context.l10n;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF18181A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.createSheetTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Flexible(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.04,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        for (final option in _createSheetOptions)
                          _CreateOptionTile(option: option),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 104,
                      height: 60,
                      child: Material(
                        color: const Color(0xFF111113),
                        borderRadius: BorderRadius.circular(30),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateOptionTile extends StatelessWidget {
  const _CreateOptionTile({required this.option});

  final _CreateOptionData option;

  @override
  Widget build(BuildContext context) {
    final label = switch (option.action) {
      _CreateAction.video => context.l10n.createVideo,
      _CreateAction.image => context.l10n.createImage,
      _CreateAction.effects => context.l10n.createEffects,
      _CreateAction.motion => context.l10n.createMotion,
    };

    return Material(
      color: allAiPanel,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(option.action),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: option.imageUrl,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 120),
              placeholder: (context, url) => const _CreateTileFallback(),
              errorWidget: (context, url, error) => const _CreateTileFallback(),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x33000000),
                    Color(0xD9000000),
                  ],
                  stops: [0, 0.46, 1],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 18,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateTileFallback extends StatelessWidget {
  const _CreateTileFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2D), Color(0xFF101012)],
        ),
      ),
    );
  }
}
