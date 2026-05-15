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

class _GroupPageState extends ConsumerState<GroupPage> {
  final _nestedKey = GlobalKey<NestedScrollViewState>();
  bool _showFab = false;

  void _scrollToTop() {
    final state = _nestedKey.currentState;
    if (state == null) return;
    const duration = Duration(milliseconds: 300);
    const curve = Curves.easeOutCubic;
    state.innerController.animateTo(0, duration: duration, curve: curve);
    state.outerController.animateTo(0, duration: duration, curve: curve);
  }

  bool _onScroll(ScrollNotification n) {
    final show = n.metrics.pixels > 300;
    if (show != _showFab) setState(() => _showFab = show);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ref.watch(groupDetailProvider(widget.groupId)).maybeWhen(
          data: (g) => g.groupTabs ?? const <GroupTab>[],
          orElse: () => const <GroupTab>[],
        );
    final tabIds = <String?>[null, ...tabs.map((t) => t.id)];
    final tabLabels = <String>['全部', ...tabs.map((t) => t.name)];
    final hasTabs = tabIds.length > 1;

    return DefaultTabController(
      key: ValueKey('group-tabs-${tabIds.length}'),
      length: tabIds.length,
      child: Scaffold(
        floatingActionButton: ScrollToTopFab(
          visible: _showFab,
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
