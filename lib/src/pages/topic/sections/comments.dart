import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../utils/time.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/shimmer_loading.dart';
import '../providers.dart';
import 'comment_replies.dart';
import 'comment_widgets.dart';
import 'interaction.dart';

/// 讨论的评论区分页列表，作为 sliver 嵌入到 [TopicPage] 的 CustomScrollView 中。
class TopicComments extends ConsumerStatefulWidget {
  const TopicComments({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<TopicComments> createState() => _TopicCommentsState();
}

class _TopicCommentsState extends ConsumerState<TopicComments>
    with PagingMixin<Comment, TopicComments> {
  ScrollPosition? _trackedPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 评论 sliver 所在 CustomScrollView 的 ScrollPosition，监听它来推算可见首项。
    final pos = Scrollable.maybeOf(context)?.position;
    if (pos != _trackedPosition) {
      _trackedPosition?.removeListener(_onScroll);
      _trackedPosition = pos;
      _trackedPosition?.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _trackedPosition?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Future<void> onLoadPage(int start) async {
    final orderBy = ref.read(topicCommentOrderProvider(widget.topicId));
    final isAsc = orderBy != 'time_desc';
    final opOnly = ref.read(topicCommentOpOnlyProvider(widget.topicId));
    // 正序时叠加跳页偏移，使 paging controller 从指定页开始连续加载
    final jumpStart = isAsc
        ? ref.read(topicCommentJumpStartProvider(widget.topicId))
        : 0;
    final page = await ref.read(topicRepositoryProvider).fetchComments(
          widget.topicId,
          start: jumpStart + start,
          count: kPageSize,
          orderBy: orderBy,
          opOnly: opOnly,
        );
    ref.read(topicCommentTotalProvider(widget.topicId).notifier).state =
        page.total;
    appendPaged(start, page);
  }

  /// 按已加载内容的滚动比例估算当前首个可见 item 的绝对索引（含 jumpStart）。
  /// 列表越靠后 maxScrollExtent 越大，对不固定行高也鲁棒。
  void _onScroll() {
    final pos = _trackedPosition;
    if (pos == null || !pos.hasContentDimensions) return;
    final items = pagingController.itemList;
    if (items == null || items.isEmpty) return;
    final max = pos.maxScrollExtent;
    final loaded = items.length;
    final avgItemHeight = max > 0 ? max / loaded : 0.0;
    final viewportItems = avgItemHeight > 0
        ? (pos.viewportDimension / avgItemHeight).floor().clamp(1, loaded)
        : 1;
    final scrollable = (loaded - viewportItems).clamp(1, loaded);
    final ratio = max > 0 ? (pos.pixels / max).clamp(0.0, 1.0) : 0.0;
    final visibleStart = (ratio * scrollable).floor();
    final jumpStart =
        ref.read(topicCommentJumpStartProvider(widget.topicId));
    final absolute = jumpStart + visibleStart;
    final current =
        ref.read(topicCommentVisibleStartProvider(widget.topicId));
    if (current != absolute) {
      ref
          .read(topicCommentVisibleStartProvider(widget.topicId).notifier)
          .state = absolute;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      topicListsRefreshTickProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    ref.listen<String>(
      topicCommentOrderProvider(widget.topicId),
      (_, __) {
        // 切换排序时重置跳页偏移，再刷新列表
        ref.read(topicCommentJumpStartProvider(widget.topicId).notifier).state =
            0;
        pagingController.refresh();
      },
    );
    ref.listen<bool>(
      topicCommentOpOnlyProvider(widget.topicId),
      (_, __) {
        ref.read(topicCommentJumpStartProvider(widget.topicId).notifier).state =
            0;
        pagingController.refresh();
      },
    );
    ref.listen<int>(
      topicCommentJumpStartProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    return PagedSliverList<int, Comment>.separated(
      pagingController: pagingController,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, thickness: 0.5, indent: 42),
      builderDelegate: frodoPagedDelegate<Comment>(
        controller: pagingController,
        emptyText: '还没有评论',
        dense: true,
        firstPageProgressBuilder: (_) => const ShimmerCommentList(),
        itemBuilder: (context, comment, _) => _CommentTile(
          topicId: widget.topicId,
          comment: comment,
        ),
      ),
    );
  }
}

class _CommentTile extends ConsumerWidget {
  const _CommentTile({required this.topicId, required this.comment});

  final String topicId;
  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitleParts = [
      if (comment.createTime != null)
        formatRelativeTime(comment.createTime) ?? comment.createTime!,
      if (comment.ipLocation != null) comment.ipLocation!,
    ];
    return InkWell(
      onTap: () => showTopicCommentSheet(
        context,
        ref,
        topicId: topicId,
        replyTo: comment,
      ),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommentHeader(
              avatarUrl: comment.author?.avatar,
              authorName: comment.author?.name ?? '匿名',
              subtitle: subtitleParts.isEmpty ? null : subtitleParts.join(' '),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if ((comment.totalReplies ?? 0) > 0) ...[
                    _RepliesButton(topicId: topicId, comment: comment),
                    const SizedBox(width: 4),
                  ],
                  CommentVoteButton(topicId: topicId, comment: comment),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 42), // avatar 32 + spacing 10
              child: _CommentBody(comment: comment),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _CommentBody extends StatelessWidget {
  const _CommentBody({required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (comment.refComment != null) ...[
          CommentRefQuote(
            authorName: comment.refComment!.author?.name ?? '用户',
            text: comment.refComment!.text ?? '',
          ),
          const SizedBox(height: 6),
        ],
        if (comment.text != null) CollapsibleText(comment.text!),
        if (comment.photos.isNotEmpty) ...[
          const SizedBox(height: 6),
          CommentPhotos(photos: comment.photos),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _RepliesButton extends ConsumerWidget {
  const _RepliesButton({required this.topicId, required this.comment});

  final String topicId;
  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme.outline;
    return InkWell(
      onTap: () => showCommentRepliesSheet(
        context,
        ref,
        topicId: topicId,
        comment: comment,
      ),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${comment.totalReplies}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
            ),
            const SizedBox(width: 3),
            Icon(Icons.chat_bubble_outline, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
