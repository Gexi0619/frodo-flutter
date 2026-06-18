import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/messages/providers.dart';
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
    _NavTab(icon: Icons.mail_outline, selectedIcon: Icons.mail, label: '消息'),
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
    final onHome = widget.navigationShell.currentIndex == 0;

    // 非首页 tab 上按返回键，先回到「小组」tab，而不是直接退出 App。
    return PopScope(
      canPop: onHome,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        widget.navigationShell.goBranch(0, initialLocation: false);
      },
      child: _buildScaffold(context, hideOnScroll),
    );
  }

  Widget _buildScaffold(BuildContext context, bool hideOnScroll) {
    // 「消息」入口（index 2）角标：未读通知 + 私信总数。
    final messagesBadge =
        ref.watch(notificationChartProvider).valueOrNull?.messagesBadge ?? 0;
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
            for (final (i, t) in _tabs.indexed)
              NavigationDestination(
                icon: _maybeBadge(
                  count: i == 2 ? messagesBadge : 0,
                  child: Icon(t.icon),
                ),
                selectedIcon: _maybeBadge(
                  count: i == 2 ? messagesBadge : 0,
                  child: Icon(t.selectedIcon),
                ),
                label: t.label,
              ),
          ],
        ),
      ),
    );
  }
}

/// `count > 0` 时给 [child] 套一个数字角标（超过 999 显示 999+），否则原样返回。
Widget _maybeBadge({required int count, required Widget child}) {
  if (count <= 0) return child;
  return Badge.count(count: count, child: child);
}

class _NavTab {
  const _NavTab({required this.icon, required this.selectedIcon, required this.label});

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
