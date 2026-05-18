import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../utils/time.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
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
  String _orderBy = 'time_asc';

  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref.read(topicRepositoryProvider).fetchComments(
          widget.topicId,
          start: start,
          count: kPageSize,
          orderBy: _orderBy,
        );
    appendPaged(start, page);
  }

  void _toggleOrder() {
    setState(() {
      _orderBy = _orderBy == 'time_asc' ? 'time_desc' : 'time_asc';
    });
    pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      topicListsRefreshTickProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    final isAsc = _orderBy == 'time_asc';
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: _toggleOrder,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scaleY: isAsc ? 1.0 : -1.0,
                    child: Icon(
                      Icons.sort,
                      size: 24,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isAsc ? '最早' : '最新',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        PagedSliverList<int, Comment>.separated(
          pagingController: pagingController,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, thickness: 0.5, indent: 42),
          builderDelegate: frodoPagedDelegate<Comment>(
            controller: pagingController,
            emptyText: '还没有评论',
            dense: true,
            itemBuilder: (context, comment, _) => _CommentTile(
              topicId: widget.topicId,
              comment: comment,
            ),
          ),
        ),
      ],
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


