import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/topic.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/topic_tile.dart';

final topicsFeedRefreshTickProvider = StateProvider<int>((ref) => 0);

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
    appendPageResult(page.items, start, page.total);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(topicsFeedRefreshTickProvider, (_, __) => pagingController.refresh());

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              '推荐讨论',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        PagedSliverList<int, Topic>.separated(
          pagingController: pagingController,
          separatorBuilder: (_, __) => const Divider(height: 0.5),
          builderDelegate: frodoPagedDelegate<Topic>(
            controller: pagingController,
            emptyText: '暂无推荐讨论',
            itemBuilder: (context, topic, _) => TopicTile(
              topic: topic,
              showGroup: true,
              onTap: () => context.go('/group/${topic.group?.id ?? ''}/topic/${topic.id}'),
            ),
          ),
        ),
      ],
    );
  }
}
