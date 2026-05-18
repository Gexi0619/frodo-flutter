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
import '../../../widgets/topic_view_mode_toggle.dart';
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
    final result = await ref.read(groupRepositoryProvider).searchGroupTab(
          keyword,
          start: start,
          count: kPageSize,
          sort: widget.sort,
        );
    appendPaged(start, result.topics);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen<String>(searchKeywordProvider, (_, __) => pagingController.refresh());

    final keyword = ref.watch(searchKeywordProvider);
    if (keyword.trim().isEmpty) {
      return const Center(child: Text('输入关键词搜索讨论'));
    }

    final mode = ref.watch(searchTopicsViewModeProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
          child: Row(
            children: [
              const Spacer(),
              TopicViewModeToggle(provider: searchTopicsViewModeProvider),
            ],
          ),
        ),
        Expanded(
          child: mode == TopicFeedViewMode.compact
              ? PagedListView<int, Topic>.separated(
                  pagingController: pagingController,
                  scrollController: widget.scrollController,
                  separatorBuilder: (_, __) => const Divider(height: 0.5),
                  builderDelegate: frodoPagedDelegate<Topic>(
                    controller: pagingController,
                    emptyText: '没有匹配结果',
                    itemBuilder: (context, topic, _) => TopicTile(
                      topic: topic,
                      showGroup: true,
                      onTap: () => context.go('/search/topic/${topic.id}'),
                    ),
                  ),
                )
              : PagedListView<int, Topic>(
                  pagingController: pagingController,
                  scrollController: widget.scrollController,
                  builderDelegate: frodoPagedDelegate<Topic>(
                    controller: pagingController,
                    emptyText: '没有匹配结果',
                    itemBuilder: (context, topic, _) => TopicCard(
                      topic: topic,
                      onTap: () => context.go('/search/topic/${topic.id}'),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
