import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/reshare.dart';
import '../../../repositories/topic_repository.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/user_avatar.dart';
import '../providers.dart';

class TopicResharers extends ConsumerStatefulWidget {
  const TopicResharers({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<TopicResharers> createState() => _TopicResharersState();
}

class _TopicResharersState extends ConsumerState<TopicResharers>
    with PagingMixin<Reshare, TopicResharers> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref.read(topicRepositoryProvider).fetchResharers(
          widget.topicId,
          start: start,
          count: kPageSize,
        );
    appendPageResult(page.items, start, page.total);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      topicResharersRefreshTickProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    return PagedSliverList<int, Reshare>(
      pagingController: pagingController,
      builderDelegate: frodoPagedDelegate<Reshare>(
        controller: pagingController,
        emptyText: '还没有人转发',
        dense: true,
        itemBuilder: (context, reshare, _) => _ReshareTile(reshare: reshare),
      ),
    );
  }
}

class _ReshareTile extends StatelessWidget {
  const _ReshareTile({required this.reshare});

  final Reshare reshare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(url: reshare.author.avatar),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reshare.author.name,
                        style: theme.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (reshare.createTime != null)
                      Text(
                        reshare.createTime!.substring(0, 10),
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: scheme.outline),
                      ),
                  ],
                ),
                if (reshare.text != null && reshare.text!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(reshare.text!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
