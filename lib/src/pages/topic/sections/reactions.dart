import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/reaction.dart';
import '../../../repositories/topic_repository.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/user_avatar.dart';
import '../providers.dart';

class TopicReactions extends ConsumerStatefulWidget {
  const TopicReactions({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<TopicReactions> createState() => _TopicReactionsState();
}

class _TopicReactionsState extends ConsumerState<TopicReactions>
    with PagingMixin<Reaction, TopicReactions> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref.read(topicRepositoryProvider).fetchReactions(
          widget.topicId,
          start: start,
          count: kPageSize,
        );
    appendPageResult(page.items, start, page.total);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      topicReactionsRefreshTickProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    return PagedSliverList<int, Reaction>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<Reaction>(
        itemBuilder: (context, reaction, _) =>
            _ReactionTile(reaction: reaction),
        firstPageProgressIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
        newPageProgressIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
        noItemsFoundIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text('还没有人点赞')),
        ),
        firstPageErrorIndicatorBuilder: (_) => Padding(
          padding: const EdgeInsets.all(20),
          child: ErrorView(
            error: pagingController.error ?? '未知错误',
            onRetry: pagingController.refresh,
          ),
        ),
      ),
    );
  }
}

class _ReactionTile extends StatelessWidget {
  const _ReactionTile({required this.reaction});

  final Reaction reaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          UserAvatar(url: reaction.user.avatar),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              reaction.user.name,
              style: theme.textTheme.labelMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            reaction.text ?? '赞过',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
