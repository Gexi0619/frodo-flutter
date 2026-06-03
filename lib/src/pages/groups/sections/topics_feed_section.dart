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
import '../../../widgets/topic_view_mode_toggle.dart';

/// 小组主页可切换的讨论 feed。下拉框列出这里的全部项，新增 feed 时
/// 加一个枚举值并在 [_TopicsFeedSectionState.onLoadPage] 补一个分支即可。
enum GroupsFeed {
  recommended('推荐讨论'),
  recommendFeed('推荐');

  const GroupsFeed(this.label);

  final String label;
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
    ref.listen<GroupsFeed>(topicsFeedProvider, (_, __) => pagingController.refresh());
    final mode = ref.watch(topicsFeedViewModeProvider);
    final feed = ref.watch(topicsFeedProvider);

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: ControlBar(
            leading: ControlBarDropdown<GroupsFeed>(
              tooltip: '讨论',
              value: feed,
              onSelected: (v) =>
                  ref.read(topicsFeedProvider.notifier).state = v,
              options: [
                for (final f in GroupsFeed.values)
                  ControlBarOption(f, f.label),
              ],
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TopicViewModeToggle(provider: topicsFeedViewModeProvider),
            ),
          ),
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
