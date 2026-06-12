import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/topic.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/control_bar.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/topic_card.dart';
import '../../../widgets/topic_tile.dart';
import '../../../routing/app_routes.dart';
import '../../topic/providers.dart';

/// 小组主页可切换的讨论 feed。顶部 tab 列出这里的全部项，新增 feed 时
/// 加一个枚举值并在 [_TopicsFeedSectionState.onLoadPage] 补一个分支即可。
/// [defaultViewMode] 是切到该 tab 时套用的默认视图（仍可用右侧切换器改）。
enum GroupsFeed {
  recommended('小组讨论', TopicFeedViewMode.compact),
  recommendFeed('推荐讨论', TopicFeedViewMode.card);

  const GroupsFeed(this.label, this.defaultViewMode);

  final String label;
  final TopicFeedViewMode defaultViewMode;
}

final topicsFeedRefreshTickProvider = StateProvider<int>((ref) => 0);
final topicsFeedViewModeProvider =
    StateProvider<TopicFeedViewMode>((ref) => TopicFeedViewMode.compact);

/// 当前选中的 feed。
final topicsFeedProvider =
    StateProvider<GroupsFeed>((ref) => GroupsFeed.recommended);

class TopicsFeedSection extends ConsumerStatefulWidget {
  const TopicsFeedSection({super.key});

  @override
  ConsumerState<TopicsFeedSection> createState() => _TopicsFeedSectionState();
}

class _TopicsFeedSectionState extends ConsumerState<TopicsFeedSection>
    with PagingMixin<Topic, TopicsFeedSection> {
  @override
  Future<void> onLoadPage(int start) async {
    final repo = ref.read(groupRepositoryProvider);
    switch (ref.read(topicsFeedProvider)) {
      case GroupsFeed.recommended:
        appendPaged(start,
            await repo.fetchRecentTopicsFeed(start: start, count: kPageSize));
      case GroupsFeed.recommendFeed:
        // 混排 feed 过滤掉了非帖子项，游标按原始条数推进（nextStart），
        // 不能走 appendPaged 的 start + items.length。
        final r = await repo.fetchRecommendFeed(start: start, count: kPageSize);
        if (r.hasMore && r.topics.isNotEmpty) {
          pagingController.appendPage(r.topics, r.nextStart);
        } else {
          pagingController.appendLastPage(r.topics);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(topicsFeedRefreshTickProvider, (_, __) => pagingController.refresh());
    // 切 tab 时刷新列表，并把视图恢复成该 tab 的默认样式（推荐=动态卡片，
    // 推荐讨论=紧凑列表），用户仍可用右侧切换器单独改。
    ref.listen<GroupsFeed>(topicsFeedProvider, (_, next) {
      pagingController.refresh();
      ref.read(topicsFeedViewModeProvider.notifier).state = next.defaultViewMode;
    });
    final mode = ref.watch(topicsFeedViewModeProvider);
    final feed = ref.watch(topicsFeedProvider);

    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(
          child: ControlBar(leading: _FeedTabBar()),
        ),
        if (mode == TopicFeedViewMode.compact)
          PagedSliverList<int, Topic>.separated(
            pagingController: pagingController,
            separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.3, indent: 64),
            builderDelegate: frodoPagedDelegate<Topic>(
              controller: pagingController,
              emptyText: '暂无${feed.label}',
              itemBuilder: (context, topic, _) => TopicTile(
                topic: topic,
                showGroup: true,
                onTap: () {
                  prefetchTopic(ref, topic.id);
                  context.push(AppRoutes.topic(topic.id), extra: topic);
                },
              ),
            ),
          )
        else
          PagedSliverList<int, Topic>.separated(
            pagingController: pagingController,
            separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.3),
            builderDelegate: frodoPagedDelegate<Topic>(
              controller: pagingController,
              emptyText: '暂无${feed.label}',
              itemBuilder: (context, topic, _) => TopicCard(
                topic: topic,
                onTap: () {
                  prefetchTopic(ref, topic.id);
                  context.push(AppRoutes.topic(topic.id), extra: topic);
                },
              ),
            ),
          ),
      ],
    );
  }
}

/// 小组主页顶部的 feed 切换 tab，使用 Flutter 自带的 [TabBar]。用一个
/// [TabController] 与 [topicsFeedProvider] 双向同步：点 tab → 写 provider，
/// provider 在别处被改 → 把指示器滑过去。
class _FeedTabBar extends ConsumerStatefulWidget {
  const _FeedTabBar();

  @override
  ConsumerState<_FeedTabBar> createState() => _FeedTabBarState();
}

class _FeedTabBarState extends ConsumerState<_FeedTabBar>
    with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(
    length: GroupsFeed.values.length,
    vsync: this,
    initialIndex: ref.read(topicsFeedProvider).index,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.indexIsChanging) return; // 只在落定后写一次
      final feed = GroupsFeed.values[_controller.index];
      if (ref.read(topicsFeedProvider) != feed) {
        ref.read(topicsFeedProvider.notifier).state = feed;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<GroupsFeed>(topicsFeedProvider, (_, next) {
      if (_controller.index != next.index) _controller.animateTo(next.index);
    });
    return TabBar(
      controller: _controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerColor: Colors.transparent,
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
      tabs: [
        for (final f in GroupsFeed.values)
          Tab(height: ControlBar.height, child: _FeedTab(feed: f)),
      ],
    );
  }
}

/// 单个 feed tab 的内容：标签 + 下拉箭头，仿照评论区 [CommentSortTab]。
/// 把「视图模式」收进 tab 自身的下拉菜单：未选中本 tab 时点击先切过来，
/// 已选中再点才弹菜单。当前视图被改成非该 tab 默认值时高亮箭头。
class _FeedTab extends ConsumerWidget {
  const _FeedTab({required this.feed});

  final GroupsFeed feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(topicsFeedProvider) == feed;
    final mode = ref.watch(topicsFeedViewModeProvider);
    final scheme = Theme.of(context).colorScheme;
    final active = selected && mode != feed.defaultViewMode;

    return MenuAnchor(
      builder: (context, menuController, _) => InkWell(
        onTap: () {
          if (!selected) {
            ref.read(topicsFeedProvider.notifier).state = feed;
          } else if (menuController.isOpen) {
            menuController.close();
          } else {
            menuController.open();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(feed.label),
            Icon(Icons.arrow_drop_down,
                size: 18, color: active ? scheme.primary : null),
          ],
        ),
      ),
      menuChildren: [
        for (final m in TopicFeedViewMode.values)
          MenuItemButton(
            leadingIcon: Icon(mode == m ? Icons.check : null, size: 16),
            onPressed: () =>
                ref.read(topicsFeedViewModeProvider.notifier).state = m,
            child: Text(_viewModeLabel(m)),
          ),
      ],
    );
  }

  static String _viewModeLabel(TopicFeedViewMode m) => switch (m) {
        TopicFeedViewMode.compact => '紧凑列表',
        TopicFeedViewMode.card => '卡片模式',
      };
}
