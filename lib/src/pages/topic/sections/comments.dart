import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../theme.dart';
import '../../../ui/dimens.dart';
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
    final result = await ref
        .read(topicRepositoryProvider)
        .fetchComments(
          widget.topicId,
          start: jumpStart + start,
          count: kPageSize,
          orderBy: orderBy,
          opOnly: opOnly,
        );
    final page = result.page;
    ref.read(topicCommentTotalProvider(widget.topicId).notifier).state =
        page.total;
    // 热评只在列表头部（start=0）那一页随响应返回；其余页响应里为空，
    // 直接覆盖即可让跳页 / 倒序等场景自动清空热评区。
    if (start == 0) {
      ref.read(topicPopularCommentsProvider(widget.topicId).notifier).state =
          result.popular;
    }
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
    final jumpStart = ref.read(topicCommentJumpStartProvider(widget.topicId));
    final absolute = jumpStart + visibleStart;
    final current = ref.read(topicCommentVisibleStartProvider(widget.topicId));
    if (current != absolute) {
      ref
              .read(topicCommentVisibleStartProvider(widget.topicId).notifier)
              .state =
          absolute;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      topicListsRefreshTickProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    ref.listen<String>(topicCommentOrderProvider(widget.topicId), (_, __) {
      // 切换排序时重置跳页偏移，再刷新列表
      ref.read(topicCommentJumpStartProvider(widget.topicId).notifier).state =
          0;
      pagingController.refresh();
    });
    ref.listen<bool>(topicCommentOpOnlyProvider(widget.topicId), (_, __) {
      ref.read(topicCommentJumpStartProvider(widget.topicId).notifier).state =
          0;
      pagingController.refresh();
    });
    ref.listen<int>(
      topicCommentJumpStartProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    final popular = ref.watch(topicPopularCommentsProvider(widget.topicId));
    return SliverMainAxisGroup(
      slivers: [
        if (popular.isNotEmpty)
          SliverToBoxAdapter(
            child: _PopularComments(topicId: widget.topicId, comments: popular),
          ),
        PagedSliverList<int, Comment>.separated(
          pagingController: pagingController,
          separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
          builderDelegate: frodoPagedDelegate<Comment>(
            controller: pagingController,
            emptyText: '还没有评论',
            dense: true,
            firstPageProgressBuilder: (_) => const ShimmerCommentList(),
            itemBuilder: (context, comment, _) =>
                _CommentTile(topicId: widget.topicId, comment: comment),
          ),
        ),
      ],
    );
  }
}

/// 热评区：列表顶部的「热评」分组，复用 [CommentTile] 排版。用一层极淡的
/// 主题色背景与一行轻量小标题作区隔，不加粗线，背景边界即是与全部评论的分界。
/// 仅在 start=0 那一页拿到热评时显示。
class _PopularComments extends StatelessWidget {
  const _PopularComments({required this.topicId, required this.comments});

  final String topicId;
  final List<Comment> comments;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < comments.length; i++) ...[
          if (i > 0)
            Divider(height: 1, thickness: 0.5, color: scheme.outlineVariant),
          _CommentTile(topicId: topicId, comment: comments[i]),
        ],
        const SizedBox(height: Dim.xs),
        // 热评与全部评论之间的双线分割，明显区隔两段。
        _DoubleDivider(color: scheme.outlineVariant),
      ],
    );
  }
}

/// 双线分割：两条细线夹一道窄缝，比单线更醒目，用于分隔热评与全部评论。
class _DoubleDivider extends StatelessWidget {
  const _DoubleDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final line = BorderSide(color: color, width: 0.8);
    return Container(
      height: 4,
      decoration: BoxDecoration(border: Border(top: line, bottom: line)),
    );
  }
}

class _CommentTile extends ConsumerWidget {
  const _CommentTile({required this.topicId, required this.comment});

  final String topicId;
  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opAuthorId = ref.watch(
      topicDetailProvider(topicId).select((t) => t.valueOrNull?.author?.id),
    );
    return CommentTile(
      topicId: topicId,
      comment: comment,
      opAuthorId: opAuthorId,
      onTap: () => showTopicCommentSheet(
        context,
        ref,
        topicId: topicId,
        replyTo: comment,
      ),
      actions: [
        // 正序(nested)模式下回复内嵌为预览，由 footer 的 _RepliesPreview 承载入口；
        // 倒序/扁平模式 replies 为空，退回气泡按钮打开楼中楼弹层。
        if (comment.replies.isEmpty && (comment.totalReplies ?? 0) > 0)
          _RepliesButton(topicId: topicId, comment: comment),
      ],
      footer: comment.replies.isNotEmpty
          ? _RepliesPreview(topicId: topicId, comment: comment)
          : null,
    );
  }
}

// ---------------------------------------------------------------------------

/// 内嵌的楼中楼预览：Reddit 风格的缩进串，默认显示最多 3 条回复，
/// 整块点击打开完整楼中楼弹层。数据来自父评论 nested 模式下的 `replies` 字段，
/// 无需额外请求。
class _RepliesPreview extends ConsumerWidget {
  const _RepliesPreview({required this.topicId, required this.comment});

  final String topicId;
  final Comment comment;

  static const _maxPreview = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final previews = comment.replies.take(_maxPreview).toList();
    if (previews.isEmpty) return const SizedBox.shrink();
    final total = comment.totalReplies ?? previews.length;

    // InkWell 包在 Padding 外层，确保顶部间距与左侧缩进区域的点击也进入
    // 楼中楼详情，而非穿透到父 CommentTile 的回复。
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => openCommentReplies(
        context,
        topicId: topicId,
        comment: comment,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: Dim.sm, left: Dim.md),
        child: Container(
          // 占满可用宽度，让点击区右侧顶到列表边缘，而非只覆盖文字。
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(Dim.md, Dim.xs, 0, Dim.xs),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: scheme.outlineVariant, width: 2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < previews.length; i++) ...[
                if (i > 0) const SizedBox(height: Dim.xs),
                _ReplyPreviewLine(reply: previews[i]),
              ],
              // 只有一条回复时不展示提示按钮（无可“查看”的更多内容）。
              if (total > 1) ...[
                const SizedBox(height: Dim.xs),
                Text(
                  total > previews.length ? '查看全部 $total 条回复' : '查看回复',
                  style: theme.extension<AppTextStyles>()?.micro.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 单条楼中楼预览：作者名加粗 + 行内正文（最多 3 行）+ 配图（若有）。
class _ReplyPreviewLine extends StatelessWidget {
  const _ReplyPreviewLine({required this.reply});

  final Comment reply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final body = reply.text?.trim();
    final micro = theme.extension<AppTextStyles>()?.micro;
    final hasBody = body != null && body.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: reply.author?.name ?? '匿名',
                style: micro?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              if (hasBody) TextSpan(text: '  $body', style: micro),
            ],
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (reply.photos.isNotEmpty) ...[
          const SizedBox(height: Dim.xs),
          CommentPhotos(photos: reply.photos),
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => openCommentReplies(
        context,
        topicId: topicId,
        comment: comment,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dim.sm,
          vertical: Dim.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${comment.totalReplies}',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: color),
            ),
            const SizedBox(width: Dim.xxs),
            Icon(CupertinoIcons.chat_bubble, size: Dim.iconSm, color: color),
          ],
        ),
      ),
    );
  }
}
