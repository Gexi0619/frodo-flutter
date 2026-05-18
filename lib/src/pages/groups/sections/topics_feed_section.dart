import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/topic.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/topic_card.dart';
import '../../../widgets/topic_tile.dart';

final topicsFeedRefreshTickProvider = StateProvider<int>((ref) => 0);
final topicsFeedViewModeProvider =
    StateProvider<TopicFeedViewMode>((ref) => TopicFeedViewMode.compact);

class TopicsFeedSection extends ConsumerStatefulWidget {
  const TopicsFeedSection({super.key});

  @override
  ConsumerState<TopicsFeedSection> createState() => _TopicsFeedSectionState();
}

class _TopicsFeedSectionState extends ConsumerState<TopicsFeedSection>
    with PagingMixin<Topic, TopicsFeedSection> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref
        .read(groupRepositoryProvider)
        .fetchRecentTopicsFeed(start: start, count: kPageSize);
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(topicsFeedRefreshTickProvider, (_, __) => pagingController.refresh());
    final mode = ref.watch(topicsFeedViewModeProvider);
    final theme = Theme.of(context);

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 8, 8),
            child: Row(
              children: [
                Text(
                  '推荐讨论',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                SegmentedButton<TopicFeedViewMode>(
                  segments: const [
                    ButtonSegment(
                      value: TopicFeedViewMode.compact,
                      icon: Icon(Icons.view_list_rounded, size: 18),
                      tooltip: '紧凑列表',
                    ),
                    ButtonSegment(
                      value: TopicFeedViewMode.card,
                      icon: Icon(Icons.view_module_rounded, size: 18),
                      tooltip: '卡片模式',
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (s) =>
                      ref.read(topicsFeedViewModeProvider.notifier).state = s.first,
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (mode == TopicFeedViewMode.compact)
          PagedSliverList<int, Topic>.separated(
            pagingController: pagingController,
            separatorBuilder: (_, __) => const Divider(height: 0.5),
            builderDelegate: frodoPagedDelegate<Topic>(
              controller: pagingController,
              emptyText: '暂无推荐讨论',
              itemBuilder: (context, topic, _) => TopicTile(
                topic: topic,
                showGroup: true,
                onTap: () => context.push('/topic/${topic.id}'),
              ),
            ),
          )
        else
          PagedSliverList<int, Topic>(
            pagingController: pagingController,
            builderDelegate: frodoPagedDelegate<Topic>(
              controller: pagingController,
              emptyText: '暂无推荐讨论',
              itemBuilder: (context, topic, _) => TopicCard(
                topic: topic,
                onTap: () => context.push('/topic/${topic.id}'),
              ),
            ),
          ),
      ],
    );
  }
}
