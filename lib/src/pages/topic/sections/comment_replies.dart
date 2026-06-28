import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../providers.dart';
import 'comment_widgets.dart';
import 'interaction.dart';

/// 进入某条评论的楼中楼详情页（iOS 风格 push，带左滑返回手势）。
void openCommentReplies(
  BuildContext context, {
  required String topicId,
  required Comment comment,
}) {
  Navigator.of(context).push(
    CupertinoPageRoute<void>(
      builder: (_) => _CommentRepliesPage(topicId: topicId, comment: comment),
    ),
  );
}

// ---------------------------------------------------------------------------

class _CommentRepliesPage extends ConsumerStatefulWidget {
  const _CommentRepliesPage({required this.topicId, required this.comment});

  final String topicId;
  final Comment comment;

  @override
  ConsumerState<_CommentRepliesPage> createState() =>
      _CommentRepliesPageState();
}

class _CommentRepliesPageState extends ConsumerState<_CommentRepliesPage>
    with PagingMixin<Comment, _CommentRepliesPage> {
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
    final opAuthorId = ref.watch(
      topicDetailProvider(widget.topicId)
          .select((t) => t.valueOrNull?.author?.id),
    );
    final total = widget.comment.totalReplies ?? 0;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(total > 0 ? '$total 条回复' : '回复'),
        backgroundColor: scheme.surface,
        border: Border(
          bottom: BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.12),
            width: 0.0,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 顶部固定展示被回复的父评论，作为楼中楼的上下文。
          SliverToBoxAdapter(
            child: CommentTile(
              topicId: widget.topicId,
              comment: widget.comment,
              opAuthorId: opAuthorId,
              onTap: () => showTopicCommentSheet(
                context,
                ref,
                topicId: widget.topicId,
                replyTo: widget.comment,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 0.5),
          ),
          PagedSliverList<int, Comment>.separated(
            pagingController: pagingController,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, thickness: 0.5),
            builderDelegate: frodoPagedDelegate<Comment>(
              controller: pagingController,
              emptyText: '还没有回复',
              dense: true,
              itemBuilder: (context, reply, _) => CommentTile(
                topicId: widget.topicId,
                comment: reply,
                opAuthorId: opAuthorId,
                onTap: () => showTopicCommentSheet(
                  context,
                  ref,
                  topicId: widget.topicId,
                  replyTo: reply,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
