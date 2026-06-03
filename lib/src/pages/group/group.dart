import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/group.dart';
import '../../models/topic.dart';
import '../../repositories/group_repository.dart';
import '../../routing/app_routes.dart';
import '../../widgets/paged_builders.dart';
import '../../widgets/paging_mixin.dart';
import '../../widgets/scroll_hide_bar.dart';
import '../../widgets/scroll_to_top_fab.dart';
import '../../widgets/sticky_header_sliver.dart';
import '../../widgets/topic_tile.dart';
import '../groups/sections/groups_dock.dart';
import '../settings/providers.dart';
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
  final _hide = ScrollHideBar();

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
    _hide.dispose();
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

  Future<void> _openEditor(String? groupName) async {
    final created = await context.push<bool>(
      AppRoutes.groupPost(widget.groupId),
      extra: groupName,
    );
    if (created == true && mounted) {
      pagingController.refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('发表成功')),
      );
    }
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

    final layout = ref.watch(groupsLayoutProvider);
    final hideOnScroll = ref.watch(hideNavOnScrollProvider);
    final group = ref.watch(groupDetailProvider(widget.groupId)).valueOrNull;
    final canPost = group?.joinStatus == GroupJoinStatus.joined;

    return Scaffold(
      floatingActionButton: canPost
          ? FloatingActionButton(
              tooltip: '发表讨论',
              onPressed: () => _openEditor(group?.name),
              child: const Icon(Icons.edit_outlined),
            )
          : null,
      bottomNavigationBar: layout == GroupsLayout.bottomDock
          ? _hide.wrap(
              enabled: hideOnScroll,
              child: GroupsDock(selectedGroupId: widget.groupId),
            )
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: hideOnScroll ? _hide.onNotification : null,
        child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            GroupHeader(
              groupId: widget.groupId,
              showTitle: _showTitle,
              onTitleTap: _scrollToTop,
              showScrollToTop: showScrollToTopFab,
              onScrollToTop: _scrollToTop,
            ),
            GroupHeaderBackground(groupId: widget.groupId),
            StickyHeaderSliver(
              height: GroupControlBar.height,
              mode: StickyHeaderMode.pinned,
              child: GroupControlBar(groupId: widget.groupId),
            ),
            PagedSliverList<int, Topic>.separated(
              pagingController: pagingController,
              separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.3, indent: 64),
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
      ),
    );
  }
}
