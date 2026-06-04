import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/settings/providers.dart';
import 'scroll_hide_bar.dart';

class RootScaffold extends ConsumerStatefulWidget {
  const RootScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends ConsumerState<RootScaffold> {
  static const _tabs = <_NavTab>[
    _NavTab(icon: Icons.groups_outlined, selectedIcon: Icons.groups, label: '小组'),
    _NavTab(icon: Icons.search_outlined, selectedIcon: Icons.search, label: '搜索'),
    _NavTab(icon: Icons.bookmark_outline, selectedIcon: Icons.bookmark, label: '收藏'),
    _NavTab(icon: Icons.person_outline, selectedIcon: Icons.person, label: '我的'),
  ];

  final _hide = ScrollHideBar();

  @override
  void dispose() {
    _hide.dispose();
    super.dispose();
  }

  void _onTabSelected(int i) {
    _hide.show();
    widget.navigationShell.goBranch(
      i,
      initialLocation: i == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hideOnScroll = ref.watch(hideNavOnScrollProvider);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: hideOnScroll ? _hide.onNotification : null,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: _hide.wrap(
        enabled: hideOnScroll,
        child: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: _onTabSelected,
          destinations: [
            for (final t in _tabs)
              NavigationDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.selectedIcon),
                label: t.label,
              ),
          ],
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({required this.icon, required this.selectedIcon, required this.label});

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
