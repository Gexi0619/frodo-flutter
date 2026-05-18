import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../widgets/paged_builders.dart';
import 'comment_widgets.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/user_avatar.dart';
import 'interaction.dart';

/// 打开某条评论的楼中楼底部弹层。
void showCommentRepliesSheet(
  BuildContext context,
  WidgetRef ref, {
  required String topicId,
  required Comment comment,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CommentRepliesSheet(
      topicId: topicId,
      comment: comment,
      parentRef: ref,
    ),
  );
}

// ---------------------------------------------------------------------------

class _CommentRepliesSheet extends ConsumerStatefulWidget {
  const _CommentRepliesSheet({
    required this.topicId,
    required this.comment,
    required this.parentRef,
  });

  final String topicId;
  final Comment comment;
  final WidgetRef parentRef;

  @override
  ConsumerState<_CommentRepliesSheet> createState() =>
      _CommentRepliesSheetState();
}

class _CommentRepliesSheetState extends ConsumerState<_CommentRepliesSheet>
    with PagingMixin<Comment, _CommentRepliesSheet> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref
        .read(topicRepositoryProvider)
        .fetchCommentReplies(widget.comment.id, start: start, count: kPageSize);
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.6;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHandle(),
          _ParentCommentHeader(
            topicId: widget.topicId,
            comment: widget.comment,
            parentRef: widget.parentRef,
          ),
          const Divider(height: 1, thickness: 0.5),
          Flexible(
            child: CustomScrollView(
              slivers: [
                PagedSliverList<int, Comment>(
                  pagingController: pagingController,
                  builderDelegate: frodoPagedDelegate<Comment>(
                    controller: pagingController,
                    emptyText: '还没有回复',
                    dense: true,
                    itemBuilder: (context, reply, _) => _ReplyTile(
                      topicId: widget.topicId,
                      reply: reply,
                      parentRef: widget.parentRef,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ParentCommentHeader extends StatelessWidget {
  const _ParentCommentHeader({
    required this.topicId,
    required this.comment,
    required this.parentRef,
  });

  final String topicId;
  final Comment comment;
  final WidgetRef parentRef;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: () => showTopicCommentSheet(
        context,
        parentRef,
        topicId: topicId,
        replyTo: comment,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(url: comment.author?.avatar),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          comment.author?.name ?? '匿名',
                          style: theme.textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if ((comment.voteCount ?? 0) > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.thumb_up_outlined,
                                size: 13, color: scheme.outline),
                            const SizedBox(width: 3),
                            Text(
                              '${comment.voteCount}',
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(color: scheme.outline),
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (comment.text != null)
                    Text(
                      comment.text!,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '${comment.totalReplies ?? 0}条回复',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: scheme.outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ReplyTile extends StatelessWidget {
  const _ReplyTile({
    required this.topicId,
    required this.reply,
    required this.parentRef,
  });

  final String topicId;
  final Comment reply;
  final WidgetRef parentRef;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: () => showTopicCommentSheet(
        context,
        parentRef,
        topicId: topicId,
        replyTo: reply,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(url: reply.author?.avatar, radius: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reply.author?.name ?? '匿名',
                              style: theme.textTheme.labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (reply.createTime != null)
                              Text(
                                reply.createTime!,
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(color: scheme.outline),
                              ),
                          ],
                        ),
                      ),
                      CommentVoteButton(topicId: topicId, comment: reply),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (reply.refComment case final ref
                      when ref != null &&
                          ref.id != reply.parentCommentId) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${ref.author?.name ?? "用户"}: ${ref.text ?? ""}',
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (reply.text != null)
                    Text(reply.text!, style: theme.textTheme.bodyMedium),
                  if (reply.photos.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    CommentPhotos(photos: reply.photos),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

