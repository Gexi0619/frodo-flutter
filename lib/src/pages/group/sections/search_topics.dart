import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/topic.dart';
import '../../../repositories/group_repository.dart';
import '../../../routing/app_routes.dart';
import '../../topic/providers.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/topic_tile.dart';

class GroupSearchTopicsTab extends ConsumerStatefulWidget {
  const GroupSearchTopicsTab({
    super.key,
    required this.groupId,
    required this.keyword,
    required this.sort,
    required this.scrollController,
  });

  final String groupId;
  final String keyword;
  final String sort;
  final ScrollController scrollController;

  @override
  ConsumerState<GroupSearchTopicsTab> createState() =>
      _GroupSearchTopicsTabState();
}

class _GroupSearchTopicsTabState extends ConsumerState<GroupSearchTopicsTab>
    with PagingMixin<Topic, GroupSearchTopicsTab>, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(GroupSearchTopicsTab old) {
    super.didUpdateWidget(old);
    if (old.keyword != widget.keyword || old.sort != widget.sort) {
      pagingController.refresh();
    }
  }

  @override
  Future<void> onLoadPage(int start) async {
    if (widget.keyword.trim().isEmpty) {
      pagingController.appendLastPage([]);
      return;
    }
    final page = await ref.read(groupRepositoryProvider).searchGroupTopics(
          widget.groupId,
          widget.keyword,
          start: start,
          count: kPageSize,
          sortBy: widget.sort,
        );
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.keyword.trim().isEmpty) {
      return const Center(child: Text('输入关键词搜索讨论'));
    }

    return PagedListView<int, Topic>.separated(
      pagingController: pagingController,
      scrollController: widget.scrollController,
      separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.3, indent: 64),
      builderDelegate: frodoPagedDelegate<Topic>(
        controller: pagingController,
        emptyText: '没有匹配结果',
        itemBuilder: (context, topic, _) => TopicTile(
          topic: topic,
          onTap: () {
            prefetchTopic(ref, topic.id);
            context.push(
              AppRoutes.groupTopic(widget.groupId, topic.id),
              extra: topic,
            );
          },
        ),
      ),
    );
  }
}
