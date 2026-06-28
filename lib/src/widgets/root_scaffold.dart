import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 侧边栏暂时隐藏，恢复时取消注释：
// import '../pages/groups/sections/home_drawer.dart';
import '../pages/messages/providers.dart';
import '../pages/settings/providers.dart';
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
                icon: _maybeBadge(
                  count: i == 2 ? messagesBadge : 0,
                  child: Icon(t.icon),
                ),
                activeIcon: _maybeBadge(
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

/// `count > 0` 时在 [child]（底栏图标）右上角叠一个 iOS 风格红色角标
/// （超过 99 显示 99+），否则原样返回。样式与消息页内的角标保持一致。
Widget _maybeBadge({required int count, required Widget child}) {
  if (count <= 0) return child;
  final display = count > 99 ? '99+' : '$count';
  return Stack(
    clipBehavior: Clip.none,
    children: [
      child,
      Positioned(
        top: -3,
        right: -8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          constraints: const BoxConstraints(minWidth: 18),
          decoration: const BoxDecoration(
            color: CupertinoColors.systemRed,
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: Text(
            display,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
      ),
    ],
  );
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
