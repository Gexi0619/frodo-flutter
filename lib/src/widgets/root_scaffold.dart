import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/settings/providers.dart';

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
  ];

  bool _navBarVisible = true;

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 2 && _navBarVisible) {
        setState(() => _navBarVisible = false);
      } else if (delta < -2 && !_navBarVisible) {
        setState(() => _navBarVisible = true);
      }
    } else if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels <= 0) {
        setState(() => _navBarVisible = true);
      }
    }
    return false;
  }

  void _onTabSelected(int i) {
    setState(() => _navBarVisible = true);
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
        onNotification: hideOnScroll ? _onScrollNotification : null,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        heightFactor: (!hideOnScroll || _navBarVisible) ? 1.0 : 0.0,
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
