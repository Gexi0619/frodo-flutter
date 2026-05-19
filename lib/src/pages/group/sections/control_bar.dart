import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/group.dart';
import '../providers.dart';

/// 帖子列表的吸顶控件栏：左侧 group_tabs 下拉，右侧 feed_tags 排序切换。
/// 不直接刷新分页 —— 由 [selectedGroupTabIdProvider] / [selectedSortByProvider]
/// 的监听者负责。
class GroupControlBar extends ConsumerWidget {
  const GroupControlBar({super.key, required this.groupId});

  final String groupId;

  static const height = 44.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupDetailProvider(groupId)).valueOrNull;
    final tabs = group?.groupTabs ?? const <GroupTab>[];
    final tags = group?.feedTags ?? const <FeedTag>[];
    if (tabs.isEmpty && tags.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            if (tabs.isNotEmpty) _TabDropdown(groupId: groupId, tabs: tabs),
            const Spacer(),
            if (tags.isNotEmpty)
              Flexible(child: _SortTags(groupId: groupId, tags: tags)),
          ],
        ),
      ),
    );
  }
}

/// PopupMenuButton 把 `value: null` 视作"取消"不会触发 onSelected，
/// 所以菜单这层用空串作为"全部"的 sentinel，写入 provider 时再映射回 null。
const _kAllTabSentinel = '';

class _TabDropdown extends ConsumerWidget {
  const _TabDropdown({required this.groupId, required this.tabs});

  final String groupId;
  final List<GroupTab> tabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedGroupTabIdProvider(groupId));
    final selectedName = tabs
            .where((t) => t.id == selectedId)
            .map((t) => t.name)
            .firstOrNull ??
        '全部';
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      tooltip: '分栏',
      initialValue: selectedId ?? _kAllTabSentinel,
      onSelected: (v) => ref
          .read(selectedGroupTabIdProvider(groupId).notifier)
          .state = v == _kAllTabSentinel ? null : v,
      itemBuilder: (_) => [
        const PopupMenuItem<String>(value: _kAllTabSentinel, child: Text('全部')),
        for (final t in tabs)
          PopupMenuItem<String>(value: t.id, child: Text(t.name)),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down,
                size: 20, color: theme.colorScheme.onSurfaceVariant),
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
    final theme = Theme.of(context);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemCount: tags.length,
      itemBuilder: (context, i) {
        // reverse: true 把第 0 项贴右，这里按视觉顺序还原索引。
        final tag = tags[tags.length - 1 - i];
        final isSelected = effective == tag.sortby;
        return TextButton(
          style: TextButton.styleFrom(
            foregroundColor: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            textStyle: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => ref
              .read(selectedSortByProvider(groupId).notifier)
              .state = tag.sortby,
          child: Text(tag.title),
        );
      },
    );
  }
}
