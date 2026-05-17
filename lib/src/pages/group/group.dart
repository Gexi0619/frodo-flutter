import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/group.dart';
import '../../widgets/scroll_to_top_fab.dart';
import 'providers.dart';
import 'sections/group_header.dart';
import 'sections/topics.dart';

class GroupPage extends ConsumerStatefulWidget {
  const GroupPage({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends ConsumerState<GroupPage>
    with FabVisibilityMixin {
  final _nestedKey = GlobalKey<NestedScrollViewState>();
  bool _showTitle = false;

  void _scrollToTop() {
    final state = _nestedKey.currentState;
    if (state == null) return;
    animateScrollToTop(state.innerController);
    animateScrollToTop(state.outerController);
  }

  bool _onScroll(ScrollNotification n) {
    updateFabVisibility(n.metrics.pixels);
    final show = n.metrics.pixels > 0;
    if (show != _showTitle) setState(() => _showTitle = show);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ref.watch(groupDetailProvider(widget.groupId)).valueOrNull
            ?.groupTabs ??
        const <GroupTab>[];
    final tabIds = <String?>[null, ...tabs.map((t) => t.id)];
    final tabLabels = <String>['全部', ...tabs.map((t) => t.name)];
    final hasTabs = tabIds.length > 1;

    return DefaultTabController(
      key: ValueKey('group-tabs-${tabIds.length}'),
      length: tabIds.length,
      child: Scaffold(
        floatingActionButton: ScrollToTopFab(
          visible: showScrollToTopFab,
          onPressed: _scrollToTop,
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: _onScroll,
          child: NestedScrollView(
            key: _nestedKey,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: GroupHeader(
                  groupId: widget.groupId,
                  tabLabels: hasTabs ? tabLabels : const [],
                  showTitle: _showTitle,
                ),
              ),
            ],
            body: TabBarView(
              children: [
                for (final id in tabIds)
                  GroupTopicsTab(groupId: widget.groupId, tabId: id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
