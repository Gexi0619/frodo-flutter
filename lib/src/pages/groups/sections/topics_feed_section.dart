import 'package:flutter/cupertino.dart';
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
final topicsFeedViewModeProvider = StateProvider<TopicFeedViewMode>(
  (ref) => TopicFeedViewMode.compact,
);

/// 当前选中的 feed。
final topicsFeedProvider = StateProvider<GroupsFeed>(
  (ref) => GroupsFeed.recommended,
);

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
        appendPaged(
          start,
          await repo.fetchRecentTopicsFeed(start: start, count: kPageSize),
        );
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
    ref.listen<int>(
      topicsFeedRefreshTickProvider,
      (_, __) => pagingController.refresh(),
    );
    // 切 tab 时刷新列表，并把视图恢复成该 tab 的默认样式（推荐=动态卡片，
    // 推荐讨论=紧凑列表），用户仍可用右侧切换器单独改。
    ref.listen<GroupsFeed>(topicsFeedProvider, (_, next) {
      pagingController.refresh();
      ref.read(topicsFeedViewModeProvider.notifier).state =
          next.defaultViewMode;
    });
    final mode = ref.watch(topicsFeedViewModeProvider);
    final feed = ref.watch(topicsFeedProvider);

    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(
          child: ControlBar(
            leading: _FeedSegmentedControl(),
            trailing: _FeedViewModeSegmentedControl(),
          ),
        ),
        if (mode == TopicFeedViewMode.compact)
          PagedSliverList<int, Topic>.separated(
            pagingController: pagingController,
            separatorBuilder: (_, __) =>
                const Divider(height: 0, thickness: 0.3, indent: 64),
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
            separatorBuilder: (_, __) =>
                const Divider(height: 0, thickness: 0.3),
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

/// 小组主页顶部的 feed 切换：iOS 原生分段控件，与 [topicsFeedProvider] 双向
/// 同步——点段 → 写 provider；provider 在别处被改 → 段控高亮随之移动。
/// 无 [TabBarView]，故不需要 TabController，直接读写 provider 即可。
class _FeedSegmentedControl extends ConsumerWidget {
  const _FeedSegmentedControl();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(topicsFeedProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: CupertinoSlidingSegmentedControl<int>(
        groupValue: feed.index,
        onValueChanged: (i) {
          if (i != null) {
            ref.read(topicsFeedProvider.notifier).state = GroupsFeed.values[i];
          }
        },
        children: {
          for (final (i, f) in GroupsFeed.values.indexed) i: Text(f.label),
        },
      ),
    );
  }
}

/// 控件栏右侧的视图模式切换：iOS 原生分段控件（紧凑列表 / 卡片模式），
/// 用图标分段，与 [topicsFeedViewModeProvider] 双向同步。
class _FeedViewModeSegmentedControl extends ConsumerWidget {
  const _FeedViewModeSegmentedControl();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(topicsFeedViewModeProvider);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: CupertinoSlidingSegmentedControl<TopicFeedViewMode>(
        groupValue: mode,
        onValueChanged: (m) {
          if (m != null) {
            ref.read(topicsFeedViewModeProvider.notifier).state = m;
          }
        },
        children: {
          for (final m in TopicFeedViewMode.values)
            m: Icon(_viewModeIcon(m), size: 18),
        },
      ),
    );
  }

  static IconData _viewModeIcon(TopicFeedViewMode m) => switch (m) {
    TopicFeedViewMode.compact => CupertinoIcons.list_bullet,
    TopicFeedViewMode.card => CupertinoIcons.square_list,
  };
}
