import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/topic.dart';
import '../../repositories/group_repository.dart';
import '../../routing/app_routes.dart';
import '../../widgets/paged_builders.dart';
import '../../widgets/paging_mixin.dart';
import '../../widgets/scroll_to_top_fab.dart';
import '../../widgets/sticky_header_sliver.dart';
import '../../widgets/topic_tile.dart';
import '../topic/providers.dart';
import 'providers.dart';
import 'sections/control_bar.dart';
import 'sections/group_header.dart';

class GroupPage extends ConsumerStatefulWidget {
  const GroupPage({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends ConsumerState<GroupPage>
    with PagingMixin<Topic, GroupPage>, FabVisibilityMixin {
  final _scrollController = ScrollController();
  final _showTitle = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _showTitle.dispose();
    super.dispose();
  }

  void _onScroll() {
    final p = _scrollController.position.pixels;
    updateFabVisibility(p);
    _showTitle.value = p > 0;
  }

  void _scrollToTop() => animateScrollToTop(_scrollController);

  @override
  Future<void> onLoadPage(int start) async {
    final sortBy = ref.read(selectedSortByProvider(widget.groupId));
    final tabId = ref.read(selectedGroupTabIdProvider(widget.groupId));
    final page = await ref.read(groupRepositoryProvider).fetchTopics(
          widget.groupId,
          start: start,
          count: kPageSize,
          sortBy: sortBy ?? 'new',
          groupTabId: tabId,
        );
    appendPaged(start, page);
  }

  Future<void> _onRefresh() async {
    ref.invalidate(groupDetailProvider(widget.groupId));
    pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
      selectedSortByProvider(widget.groupId),
      (_, __) => pagingController.refresh(),
    );
    ref.listen<String?>(
      selectedGroupTabIdProvider(widget.groupId),
      (_, __) => pagingController.refresh(),
    );

    return Scaffold(
      floatingActionButton: ScrollToTopFab(
        visible: showScrollToTopFab,
        onPressed: _scrollToTop,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            GroupHeader(groupId: widget.groupId, showTitle: _showTitle, onTitleTap: _scrollToTop),
            GroupHeaderBackground(groupId: widget.groupId),
            StickyHeaderSliver(
              height: GroupControlBar.height,
              mode: StickyHeaderMode.pinned,
              child: GroupControlBar(groupId: widget.groupId),
            ),
            PagedSliverList<int, Topic>.separated(
              pagingController: pagingController,
              separatorBuilder: (_, __) => const Divider(height: 0.5),
              builderDelegate: frodoPagedDelegate<Topic>(
                controller: pagingController,
                emptyText: '暂无讨论',
                itemBuilder: (context, topic, _) => TopicTile(
                  topic: topic,
                  onTap: () {
                    prefetchTopic(ref, topic.id);
                    context.go(
                      AppRoutes.groupTopic(widget.groupId, topic.id),
                      extra: topic,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
