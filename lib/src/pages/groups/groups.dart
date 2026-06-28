import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/app_routes.dart';
import '../../ui/scroll_behavior.dart';
import '../../widgets/scroll_hide_bar.dart';
import '../../widgets/scroll_to_top_fab.dart';
import '../settings/providers.dart';
// 侧边栏暂时隐藏，恢复时取消注释（汉堡按钮用到 rootScaffoldKeyProvider）：
// import '../../widgets/root_scaffold.dart';
import 'providers.dart';
import 'sections/groups_dock.dart';
import 'sections/joined_groups_section.dart';
import 'sections/topics_feed_section.dart';

class GroupsPage extends ConsumerStatefulWidget {
  const GroupsPage({super.key});

  @override
  ConsumerState<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends ConsumerState<GroupsPage>
    with FabVisibilityMixin {
  final _scrollController = ScrollController();
  final _hide = ScrollHideBar();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () => updateFabVisibility(_scrollController.offset),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hide.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(joinedGroupsProvider);
    ref.read(topicsFeedRefreshTickProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    final layout = ref.watch(groupsLayoutProvider);
    final showTopGrid = layout == GroupsLayout.topGrid;
    final hideOnScroll = ref.watch(hideNavOnScrollProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: const Text('小组'),
        backgroundColor: scheme.surface,
        border: Border(
          bottom: BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.12),
            width: 0.0,
          ),
        ),
        padding: const EdgeInsetsDirectional.only(start: 8, end: 12),
        // 侧边栏暂时隐藏，恢复时取消注释这个汉堡按钮：
        // leading: CupertinoButton(
        //   padding: EdgeInsets.zero,
        //   minimumSize: Size.zero,
        //   onPressed: () =>
        //       ref.read(rootScaffoldKeyProvider).currentState?.openDrawer(),
        //   child: const Icon(CupertinoIcons.line_horizontal_3, size: 26),
        // ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showScrollToTopFab)
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: Size.zero,
                onPressed: () => animateScrollToTop(_scrollController),
                child: const Icon(CupertinoIcons.arrow_up_to_line, size: 24),
              ),
            CupertinoButton(
              padding: const EdgeInsets.only(left: 4),
              minimumSize: Size.zero,
              onPressed: () => context.go(AppRoutes.search()),
              child: const Icon(CupertinoIcons.search, size: 24),
            ),
          ],
        ),
      ),
      bottomNavigationBar: layout == GroupsLayout.bottomDock
          // 小组 dock 常驻屏幕底部，不随滑动隐藏。
          ? _hide.wrap(enabled: false, child: const GroupsDock())
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: hideOnScroll ? _hide.onNotification : null,
        child: CustomScrollView(
          controller: _scrollController,
          physics: kRefreshScrollPhysics,
          slivers: [
            CupertinoSliverRefreshControl(onRefresh: _refresh),
            if (showTopGrid)
                JoinedGroupsSection(
                  onRetry: () => ref.invalidate(joinedGroupsProvider),
                ),
              const TopicsFeedSection(),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
      ),
    );
  }
}
