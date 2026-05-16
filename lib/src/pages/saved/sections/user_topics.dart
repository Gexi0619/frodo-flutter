import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/paged.dart';
import '../../../models/topic.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/topic_tile.dart';

class SavedPostedTopics extends StatelessWidget {
  const SavedPostedTopics({super.key});

  @override
  Widget build(BuildContext context) => _UserTopicsList(
        fetchPage: (ref, start, count) => ref
            .read(groupRepositoryProvider)
            .fetchPostedTopics(start: start, count: count),
      );
}

class SavedRepliedTopics extends StatelessWidget {
  const SavedRepliedTopics({super.key});

  @override
  Widget build(BuildContext context) => _UserTopicsList(
        fetchPage: (ref, start, count) => ref
            .read(groupRepositoryProvider)
            .fetchRepliedTopics(start: start, count: count),
      );
}

// ---------------------------------------------------------------------------

typedef _FetchPage = Future<Paged<Topic>> Function(
    WidgetRef ref, int start, int count);

class _UserTopicsList extends ConsumerStatefulWidget {
  const _UserTopicsList({required this.fetchPage});

  final _FetchPage fetchPage;

  @override
  ConsumerState<_UserTopicsList> createState() => _UserTopicsListState();
}

class _UserTopicsListState extends ConsumerState<_UserTopicsList>
    with PagingMixin<Topic, _UserTopicsList> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await widget.fetchPage(ref, start, kPageSize);
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        PagedSliverList<int, Topic>.separated(
          pagingController: pagingController,
          separatorBuilder: (_, __) => const Divider(height: 0.5),
          builderDelegate: frodoPagedDelegate<Topic>(
            controller: pagingController,
            emptyText: '暂无帖子',
            itemBuilder: (context, topic, _) => TopicTile(
              topic: topic,
              showGroup: true,
              onTap: () => context.go('/saved/topic/${topic.id}'),
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}
