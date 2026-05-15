import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/reaction.dart';
import '../../../repositories/topic_repository.dart';
import '../../../widgets/paged_builders.dart';
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
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      topicListsRefreshTickProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    return PagedSliverList<int, Reaction>(
      pagingController: pagingController,
      builderDelegate: frodoPagedDelegate<Reaction>(
        controller: pagingController,
        emptyText: '还没有人点赞',
        dense: true,
        itemBuilder: (context, reaction, _) =>
            _ReactionTile(reaction: reaction),
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
