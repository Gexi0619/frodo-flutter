import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/topic.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/topic_tile.dart';
import '../providers.dart';

class SearchTopicsTab extends ConsumerStatefulWidget {
  const SearchTopicsTab({super.key, required this.sort, required this.scrollController});

  final String sort;
  final ScrollController scrollController;

  @override
  ConsumerState<SearchTopicsTab> createState() => _SearchTopicsTabState();
}

class _SearchTopicsTabState extends ConsumerState<SearchTopicsTab>
    with PagingMixin<Topic, SearchTopicsTab>, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> onLoadPage(int start) async {
    final keyword = ref.read(searchKeywordProvider);
    if (keyword.trim().isEmpty) {
      pagingController.appendLastPage([]);
      return;
    }
    final page = await ref.read(groupRepositoryProvider).searchTopics(
          keyword,
          start: start,
          count: kPageSize,
          sort: widget.sort,
        );
    appendPageResult(page.items, start, page.total);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen<String>(searchKeywordProvider, (_, __) => pagingController.refresh());

    final keyword = ref.watch(searchKeywordProvider);
    if (keyword.trim().isEmpty) {
      return const Center(child: Text('输入关键词搜索讨论'));
    }

    return PagedListView<int, Topic>.separated(
      pagingController: pagingController,
      scrollController: widget.scrollController,
      separatorBuilder: (_, __) => const Divider(height: 0.5),
      builderDelegate: PagedChildBuilderDelegate<Topic>(
        itemBuilder: (context, topic, _) => TopicTile(
          topic: topic,
          showGroup: true,
          onTap: () => context.go('/search/topic/${topic.id}'),
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
