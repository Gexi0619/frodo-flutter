import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/group.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/group_card.dart';
import '../../../widgets/paging_mixin.dart';
import '../providers.dart';

class SearchGroupsTab extends ConsumerStatefulWidget {
  const SearchGroupsTab({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  ConsumerState<SearchGroupsTab> createState() => _SearchGroupsTabState();
}

class _SearchGroupsTabState extends ConsumerState<SearchGroupsTab>
    with PagingMixin<Group, SearchGroupsTab>, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> onLoadPage(int start) async {
    final keyword = ref.read(searchKeywordProvider);
    if (keyword.trim().isEmpty) {
      pagingController.appendLastPage([]);
      return;
    }
    final page = await ref.read(groupRepositoryProvider).searchGroups(
          keyword,
          start: start,
          count: kPageSize,
        );
    appendPageResult(page.items, start, page.total);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen<String>(searchKeywordProvider, (_, __) => pagingController.refresh());

    final keyword = ref.watch(searchKeywordProvider);
    if (keyword.trim().isEmpty) {
      return const Center(child: Text('输入关键词搜索小组'));
    }

    return PagedListView<int, Group>(
      pagingController: pagingController,
      scrollController: widget.scrollController,
      builderDelegate: PagedChildBuilderDelegate<Group>(
        itemBuilder: (context, group, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: GroupCard(
            group: group,
            onTap: () => context.go('/group/${group.id}'),
          ),
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
