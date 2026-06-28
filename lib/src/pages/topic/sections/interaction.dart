import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/paging_mixin.dart';
import '../../settings/providers.dart';
import '../providers.dart';
import 'collect_sheet.dart';
import 'comment_sheet.dart';

class TopicInteraction extends ConsumerWidget {
  const TopicInteraction({super.key, required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reactState = ref.watch(topicReactProvider(topicId));
    final liked = reactState.valueOrNull?.liked ?? false;
    final collectState = ref.watch(topicCollectProvider(topicId));
    final anyCollected = collectState.valueOrNull?.anyCollected ?? false;

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final likeColor = liked ? scheme.primary : scheme.onSurfaceVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        // iOS 工具栏特征：顶部一条 hairline 分隔线。
        border: Border(
          top: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 0.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        showTopicCommentSheet(context, ref, topicId: topicId),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: CupertinoColors.tertiarySystemFill.resolveFrom(
                          context,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '写评论…',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.outline,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _PagerToggleButton(topicId: topicId),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  onPressed: reactState is AsyncLoading
                      ? null
                      : () => ref
                            .read(topicReactProvider(topicId).notifier)
                            .toggle(),
                  child: Icon(
                    liked
                        ? CupertinoIcons.hand_thumbsup_fill
                        : CupertinoIcons.hand_thumbsup,
                    size: 22,
                    color: likeColor,
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  onPressed: () =>
                      showTopicCollectSheet(context, ref, topicId: topicId),
                  child: Icon(
                    anyCollected
                        ? CupertinoIcons.bookmark_fill
                        : CupertinoIcons.bookmark,
                    size: 22,
                    color: anyCollected
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 互动栏里的翻页滑块开关。仅在「回复」tab 且评论多页可翻时出现，
/// 点击展开 / 收起上方的 [CommentPageSlider]。
class _PagerToggleButton extends ConsumerWidget {
  const _PagerToggleButton({required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(topicCommentPagerAvailableProvider(topicId));
    final open = ref.watch(topicCommentPagerOpenProvider(topicId));
    final tabController = DefaultTabController.maybeOf(context);
    if (tabController == null || !available) return const SizedBox.shrink();

    // 当前页由可见首项推算（与滑块同源）。
    final total = ref.watch(topicCommentTotalProvider(topicId));
    final totalPages = total > 0 ? (total / kPageSize).ceil() : 0;
    final visibleStart = ref.watch(topicCommentVisibleStartProvider(topicId));
    final currentPage = totalPages > 0
        ? ((visibleStart ~/ kPageSize) + 1).clamp(1, totalPages)
        : 1;
    final style = ref.watch(commentPagerStyleProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = open ? scheme.primary : scheme.onSurfaceVariant;
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, _) {
        if (tabController.index != 0) return const SizedBox.shrink();
        return CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: Size.zero,
          onPressed: () => ref
              .read(topicCommentPagerOpenProvider(topicId).notifier)
              .update((s) => !s),
          child: switch (style) {
            // 圆环：填充比例 = 当前页 / 总页数。
            CommentPagerStyle.circle => SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                value: totalPages > 0 ? currentPage / totalPages : 0.0,
                strokeWidth: 2,
                backgroundColor: scheme.surfaceContainerHighest,
                color: accent,
              ),
            ),
            // 文字：「当前页/总页数」+ 展开 / 收起箭头。
            CommentPagerStyle.text => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$currentPage/$totalPages',
                  style: theme.textTheme.labelMedium?.copyWith(color: accent),
                ),
                const SizedBox(width: 2),
                Icon(
                  open ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_up,
                  size: 20,
                  color: accent,
                ),
              ],
            ),
          },
        );
      },
    );
  }
}
