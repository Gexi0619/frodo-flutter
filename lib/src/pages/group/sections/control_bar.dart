import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../models/group.dart';
import '../../../widgets/control_bar.dart';
import '../providers.dart';

/// 小组页的吸顶控件栏：左侧 group_tabs 下拉，右侧 feed_tags 排序切换。
/// 复用通用 [ControlBar] 外壳与 [ControlBarDropdown]。
/// 不直接刷新分页 —— 由 [selectedGroupTabIdProvider] / [selectedSortByProvider]
/// 的监听者负责。
class GroupControlBar extends ConsumerWidget {
  const GroupControlBar({super.key, required this.groupId});

  final String groupId;

  static const height = ControlBar.height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupDetailProvider(groupId)).valueOrNull;
    final tabs = group?.groupTabs ?? const <GroupTab>[];
    final tags = group?.feedTags ?? const <FeedTag>[];
    if (tabs.isEmpty && tags.isEmpty) return const SizedBox.shrink();

    return ControlBar(
      leading: tabs.isNotEmpty
          ? _TabDropdown(groupId: groupId, tabs: tabs)
          : null,
      trailing: tags.isNotEmpty
          ? Flexible(
              child: _SortTags(groupId: groupId, tags: tags),
            )
          : null,
    );
  }
}

class _TabDropdown extends ConsumerWidget {
  const _TabDropdown({required this.groupId, required this.tabs});

  final String groupId;
  final List<GroupTab> tabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedGroupTabIdProvider(groupId));
    final theme = Theme.of(context);
    final selectedLabel = selectedId == null
        ? '全部'
        : (tabs
                  .where((t) => t.id == selectedId)
                  .map((t) => t.name)
                  .firstOrNull ??
              '全部');

    return PullDownButton(
      itemBuilder: (context) => [
        PullDownMenuItem.selectable(
          title: '全部',
          selected: selectedId == null,
          onTap: () =>
              ref.read(selectedGroupTabIdProvider(groupId).notifier).state =
                  null,
        ),
        for (final t in tabs)
          PullDownMenuItem.selectable(
            title: t.name,
            selected: selectedId == t.id,
            onTap: () =>
                ref.read(selectedGroupTabIdProvider(groupId).notifier).state =
                    t.id,
          ),
      ],
      buttonBuilder: (context, showMenu) => CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: Size.zero,
        onPressed: showMenu,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              CupertinoIcons.chevron_down,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SortTags extends ConsumerWidget {
  const _SortTags({required this.groupId, required this.tags});

  final String groupId;
  final List<FeedTag> tags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedSortByProvider(groupId));
    final effective = selected ?? tags.first.sortby;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: CupertinoSlidingSegmentedControl<String>(
        groupValue: effective,
        onValueChanged: (v) {
          if (v != null) {
            ref.read(selectedSortByProvider(groupId).notifier).state = v;
          }
        },
        children: {for (final t in tags) t.sortby: Text(t.title)},
      ),
    );
  }
}
