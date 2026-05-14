import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/group.dart';
import 'providers.dart';
import 'sections/group_header.dart';
import 'sections/group_tabs.dart';
import 'sections/topics.dart';

class GroupPage extends ConsumerWidget {
  const GroupPage({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ref.watch(groupDetailProvider(groupId)).maybeWhen(
          data: (g) => g.groupTabs ?? const <GroupTab>[],
          orElse: () => const <GroupTab>[],
        );
    // tabId == null 表示"全部"，永远占第一位。
    final tabIds = <String?>[null, ...tabs.map((t) => t.id)];
    final tabLabels = <String>['全部', ...tabs.map((t) => t.name)];
    final hasTabs = tabIds.length > 1;

    return DefaultTabController(
      key: ValueKey('group-tabs-${tabIds.length}'),
      length: tabIds.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle:
                  NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverMainAxisGroup(
                slivers: [
                  GroupHeader(groupId: groupId),
                  if (hasTabs) GroupTabsSliver(labels: tabLabels),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              for (final id in tabIds)
                GroupTopicsTab(groupId: groupId, tabId: id),
            ],
          ),
        ),
      ),
    );
  }
}
