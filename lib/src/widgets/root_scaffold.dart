import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 侧边栏暂时隐藏，恢复时取消注释：
// import '../pages/groups/sections/home_drawer.dart';
import '../pages/messages/providers.dart';
import '../pages/settings/providers.dart';
import 'count_badge.dart';
import 'scroll_hide_bar.dart';

/// 根 Scaffold 的 key：供子页面（小组首页）打开覆盖整屏（含底栏）的侧边栏。
final rootScaffoldKeyProvider = Provider<GlobalKey<ScaffoldState>>(
  (_) => GlobalKey<ScaffoldState>(),
);

class RootScaffold extends ConsumerStatefulWidget {
  const RootScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends ConsumerState<RootScaffold> {
  static const _tabs = <_NavTab>[
    _NavTab(
      icon: CupertinoIcons.person_3,
      selectedIcon: CupertinoIcons.person_3_fill,
      label: '小组',
    ),
    _NavTab(
      icon: CupertinoIcons.search,
      selectedIcon: CupertinoIcons.search,
      label: '搜索',
    ),
    _NavTab(
      icon: CupertinoIcons.chat_bubble_2,
      selectedIcon: CupertinoIcons.chat_bubble_2_fill,
      label: '消息',
    ),
    _NavTab(
      icon: CupertinoIcons.person,
      selectedIcon: CupertinoIcons.person_fill,
      label: '我的',
    ),
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
      child: _buildScaffold(context, hideOnScroll, onHome),
    );
  }

  Widget _buildScaffold(BuildContext context, bool hideOnScroll, bool onHome) {
    // 「消息」入口（index 2）角标：未读通知 + 私信总数。
    final messagesBadge =
        ref.watch(notificationChartProvider).valueOrNull?.messagesBadge ?? 0;
    return Scaffold(
      key: ref.watch(rootScaffoldKeyProvider),
      // 侧边栏暂时隐藏（连同 groups.dart 顶部的汉堡按钮一起）。
      // 恢复时改回：drawer: onHome ? const HomeDrawer() : null,
      drawer: null,
      body: NotificationListener<ScrollNotification>(
        onNotification: hideOnScroll ? _hide.onNotification : null,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: _hide.wrap(
        // 底部导航栏常驻屏幕底部，不随滑动隐藏。
        enabled: false,
        child: CupertinoTabBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _onTabSelected,
          activeColor: Theme.of(context).colorScheme.primary,
          items: [
            for (final (i, t) in _tabs.indexed)
              BottomNavigationBarItem(
                icon: CountBadge.overlay(
                  count: i == 2 ? messagesBadge : 0,
                  top: -3,
                  right: -8,
                  border: false,
                  child: Icon(t.icon),
                ),
                activeIcon: CountBadge.overlay(
                  count: i == 2 ? messagesBadge : 0,
                  top: -3,
                  right: -8,
                  border: false,
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

class _NavTab {
  const _NavTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
