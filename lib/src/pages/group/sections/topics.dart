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
import 'feed_tags.dart';

/// 自增即可触发对应 groupId 的 topics 列表刷新（外壳 RefreshIndicator 用）。
final groupTopicsRefreshTickProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);

/// 单个分栏的内容页：feed_tags 排序条 + 分页帖子列表。
/// 由 [TabBarView] 按 [GroupTab] 数量实例化，受 [NestedScrollView] 协调滚动。
class GroupTopicsTab extends ConsumerStatefulWidget {
  const GroupTopicsTab({super.key, required this.groupId, required this.tabId});

  final String groupId;

  /// null 表示"全部"。
  final String? tabId;

  @override
  ConsumerState<GroupTopicsTab> createState() => _GroupTopicsTabState();
}

class _GroupTopicsTabState extends ConsumerState<GroupTopicsTab>
    with PagingMixin<Topic, GroupTopicsTab>, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> onLoadPage(int start) async {
    final sortBy = ref.read(selectedSortByProvider(widget.groupId));
    final page = await ref.read(groupRepositoryProvider).fetchTopics(
          widget.groupId,
          start: start,
          count: kPageSize,
          sortBy: sortBy ?? 'new',
          groupTabId: widget.tabId,
        );
    appendPageResult(page.items, start, page.total);
  }

  Future<void> _onRefresh() async {
    ref.invalidate(groupDetailProvider(widget.groupId));
    ref.read(groupTopicsRefreshTickProvider(widget.groupId).notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen<int>(
      groupTopicsRefreshTickProvider(widget.groupId),
      (_, __) => pagingController.refresh(),
    );
    ref.listen<String?>(
      selectedSortByProvider(widget.groupId),
      (_, __) => pagingController.refresh(),
    );
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        key: PageStorageKey<String>('group-tab-${widget.tabId ?? 'all'}'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          GroupFeedTagsBar(groupId: widget.groupId),
          PagedSliverList<int, Topic>.separated(
            pagingController: pagingController,
            separatorBuilder: (_, __) => const Divider(height: 0.5),
            builderDelegate: PagedChildBuilderDelegate<Topic>(
              itemBuilder: (context, topic, _) => TopicTile(
                topic: topic,
                onTap: () =>
                    context.go('/group/${widget.groupId}/topic/${topic.id}'),
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
                child: Center(child: Text('暂无讨论')),
              ),
              firstPageErrorIndicatorBuilder: (_) => Padding(
                padding: const EdgeInsets.all(24),
                child: ErrorView(
                  error: pagingController.error ?? '未知错误',
                  onRetry: pagingController.refresh,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
