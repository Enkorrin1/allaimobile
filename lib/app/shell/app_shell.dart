import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: _NeonBottomBar(
        currentIndex: navigationShell.currentIndex,
        onHome: () => _goBranch(0),
        onCreate: () => _goBranch(1),
        onProjects: () => _goBranch(2),
      ),
    );
  }
}

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

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Color(0xFF202024))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 90 + bottomPadding,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BottomItem(
                  label: 'Home',
                  icon: Icons.movie_creation_outlined,
                  selected: currentIndex == 0,
                  onTap: onHome,
                ),
                _CreateButton(onTap: onCreate, selected: currentIndex == 1),
                _BottomItem(
                  label: 'Projects',
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
      width: 92,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 31),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 14,
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
      width: 118,
      height: 72,
      child: Material(
        color: allAiNeon,
        borderRadius: BorderRadius.circular(36),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Icon(
            selected ? Icons.add_circle : Icons.add,
            color: Colors.black,
            size: 36,
          ),
        ),
      ),
    );
  }
}
