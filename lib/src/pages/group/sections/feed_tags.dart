import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/group.dart';
import '../providers.dart';

/// 分栏条下方的排序条（最新 / 热门 / 精华 ...）。
/// 切换 [selectedSortByProvider]，各分栏的 GroupTopicsTab 监听并刷新分页。
class GroupFeedTagsBar extends ConsumerWidget {
  const GroupFeedTagsBar({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(groupDetailProvider(groupId)).maybeWhen(
          data: (g) => g.feedTags ?? const <FeedTag>[],
          orElse: () => const <FeedTag>[],
        );
    if (tags.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final selected = ref.watch(selectedSortByProvider(groupId));
    return SliverPersistentHeader(
      pinned: false,
      delegate: _FeedTagsDelegate(
        tags: tags,
        selected: selected,
        onSelect: (sortby) => ref
            .read(selectedSortByProvider(groupId).notifier)
            .state = sortby,
      ),
    );
  }
}

class _FeedTagsDelegate extends SliverPersistentHeaderDelegate {
  _FeedTagsDelegate({
    required this.tags,
    required this.selected,
    required this.onSelect,
  });

  final List<FeedTag> tags;
  final String? selected;
  final ValueChanged<String> onSelect;

  static const _height = 44.0;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    // 未显式选择时，视觉上回落到第一个 tag。
    final effective = selected ?? tags.first.sortby;
    return Material(
      color: theme.colorScheme.surface,
      elevation: overlapsContent ? 1 : 0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: tags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final tag = tags[i];
          return ChoiceChip(
            label: Text(tag.title),
            selected: effective == tag.sortby,
            visualDensity: VisualDensity.compact,
            onSelected: (_) => onSelect(tag.sortby),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FeedTagsDelegate old) =>
      old.selected != selected || !identical(old.tags, tags);
}
