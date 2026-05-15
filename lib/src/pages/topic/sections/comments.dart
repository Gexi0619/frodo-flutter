import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/user_avatar.dart';
import '../providers.dart';

/// 讨论的评论区分页列表，作为 sliver 嵌入到 [TopicPage] 的 CustomScrollView 中。
class TopicComments extends ConsumerStatefulWidget {
  const TopicComments({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<TopicComments> createState() => _TopicCommentsState();
}

class _TopicCommentsState extends ConsumerState<TopicComments>
    with PagingMixin<Comment, TopicComments> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref.read(topicRepositoryProvider).fetchComments(
          widget.topicId,
          start: start,
          count: kPageSize,
        );
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      topicListsRefreshTickProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    return PagedSliverList<int, Comment>(
      pagingController: pagingController,
      builderDelegate: frodoPagedDelegate<Comment>(
        controller: pagingController,
        emptyText: '还没有评论',
        dense: true,
        itemBuilder: (context, comment, _) => _CommentTile(comment: comment),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(url: comment.author?.avatar),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.author?.name ?? '匿名',
                  style: theme.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (comment.createTime != null)
                  Text(
                    comment.createTime!,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: scheme.outline),
                  ),
                const SizedBox(height: 4),
                if (comment.text != null) Text(comment.text!),
                if (comment.refComment != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text:
                                '${comment.refComment!.author?.name ?? "用户"}: ',
                            style:
                                const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: comment.refComment!.text ?? ''),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
