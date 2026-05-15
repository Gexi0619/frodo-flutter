import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/topic.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/error_view.dart';
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
    appendPageResult(page.items, start, page.total);
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
      separatorBuilder: (_, __) => const Divider(height: 0.5),
      builderDelegate: PagedChildBuilderDelegate<Topic>(
        itemBuilder: (context, topic, _) => TopicTile(
          topic: topic,
          onTap: () => context.push('/group/${widget.groupId}/topic/${topic.id}'),
        ),
        firstPageProgressIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(48),
          child: Center(child: CircularProgressIndicator()),
        ),
        newPageProgressIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
        noItemsFoundIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(48),
          child: Center(child: Text('没有匹配结果')),
        ),
        firstPageErrorIndicatorBuilder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: ErrorView(
            error: pagingController.error ?? '未知错误',
            onRetry: pagingController.refresh,
          ),
        ),
      ),
    );
  }
}
