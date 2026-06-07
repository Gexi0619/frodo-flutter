import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../ui/dimens.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import 'comment_widgets.dart';
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

    // 用 DraggableScrollableSheet：把它提供的 scrollController 接到内部列表，
    // 这样在顶部继续下滑会拖动整个弹层，滑到 minChildSize 即收起。
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              _SheetHandle(),
              Expanded(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: Dim.lg),
                      sliver: SliverToBoxAdapter(
                        child: CommentTile(
                          topicId: widget.topicId,
                          comment: widget.comment,
                          onTap: () => showTopicCommentSheet(
                            context,
                            widget.parentRef,
                            topicId: widget.topicId,
                            replyTo: widget.comment,
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Divider(height: 1, thickness: 0.5),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: Dim.lg),
                      sliver: PagedSliverList<int, Comment>.separated(
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
                            onTap: () => showTopicCommentSheet(
                              context,
                              widget.parentRef,
                              topicId: widget.topicId,
                              replyTo: reply,
                            ),
                          ),
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
      },
    );
  }
}

// ---------------------------------------------------------------------------

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dim.sm),
      child: Container(
        width: 36,
        height: Dim.xs,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
