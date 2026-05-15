import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/group.dart';
import '../../../models/topic.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/group_card.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/topic_tile.dart';
import '../providers.dart';

class SearchComprehensiveTab extends ConsumerStatefulWidget {
  const SearchComprehensiveTab({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  ConsumerState<SearchComprehensiveTab> createState() =>
      _SearchComprehensiveTabState();
}

class _SearchComprehensiveTabState
    extends ConsumerState<SearchComprehensiveTab>
    with
        PagingMixin<Topic, SearchComprehensiveTab>,
        AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Group> _groups = [];

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
        );
    if (start == 0 && mounted) {
      setState(() => _groups = result.groups);
    }
    appendPageResult(result.topics.items, start, result.topics.total);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen<String>(searchKeywordProvider, (_, __) {
      setState(() => _groups = []);
      pagingController.refresh();
    });

    final keyword = ref.watch(searchKeywordProvider);
    if (keyword.trim().isEmpty) {
      return const Center(child: Text('输入关键词综合搜索'));
    }

    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        if (_groups.isNotEmpty) ...[
          const _SectionHeader(title: '小组'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            sliver: SliverList.builder(
              itemCount: _groups.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GroupCard(
                  group: _groups[i],
                  onTap: () => context.go('/group/${_groups[i].id}'),
                ),
              ),
            ),
          ),
          const _SectionHeader(title: '讨论'),
        ],
        PagedSliverList<int, Topic>.separated(
          pagingController: pagingController,
          separatorBuilder: (_, __) => const Divider(height: 0.5),
          builderDelegate: PagedChildBuilderDelegate<Topic>(
            itemBuilder: (ctx, topic, _) => TopicTile(
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
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text(
          title,
          style: theme.textTheme.labelLarge
              ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
