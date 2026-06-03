import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/app_routes.dart';
import '../../widgets/scroll_hide_bar.dart';
import '../../widgets/scroll_to_top_fab.dart';
import '../settings/providers.dart';
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
        () => updateFabVisibility(_scrollController.offset));
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('小组'),
        actions: [
          if (showScrollToTopFab)
            IconButton(
              icon: const Icon(Icons.vertical_align_top),
              tooltip: '回到顶部',
              padding: const EdgeInsets.symmetric(horizontal: 4),
              onPressed: () => animateScrollToTop(_scrollController),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: '设置',
            padding: const EdgeInsets.symmetric(horizontal: 4),
            onPressed: () => context.push(AppRoutes.settings()),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: '搜索',
            padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
            onPressed: () => context.go(AppRoutes.search()),
          ),
        ],
      ),
      bottomNavigationBar: layout == GroupsLayout.bottomDock
          ? _hide.wrap(enabled: hideOnScroll, child: const GroupsDock())
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: hideOnScroll ? _hide.onNotification : null,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
            if (showTopGrid)
              JoinedGroupsSection(
                onRetry: () => ref.invalidate(joinedGroupsProvider),
              ),
            const TopicsFeedSection(),
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
          ),
        ),
      ),
    );
  }
}
