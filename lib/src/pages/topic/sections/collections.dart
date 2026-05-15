import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/collection.dart';
import '../../../repositories/topic_repository.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/user_avatar.dart';
import '../providers.dart';

class TopicCollections extends ConsumerStatefulWidget {
  const TopicCollections({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<TopicCollections> createState() => _TopicCollectionsState();
}

class _TopicCollectionsState extends ConsumerState<TopicCollections>
    with PagingMixin<Collection, TopicCollections> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref.read(topicRepositoryProvider).fetchCollections(
          widget.topicId,
          start: start,
          count: kPageSize,
        );
    appendPageResult(page.items, start, page.total);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      topicCollectionsRefreshTickProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    return PagedSliverList<int, Collection>(
      pagingController: pagingController,
      builderDelegate: frodoPagedDelegate<Collection>(
        controller: pagingController,
        emptyText: '还没有人收藏',
        dense: true,
        itemBuilder: (context, item, _) => _CollectionTile(item: item),
      ),
    );
  }
}

class _CollectionTile extends StatelessWidget {
  const _CollectionTile({required this.item});

  final Collection item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doulist = item.doulist;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(url: doulist.owner.avatar),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doulist.title,
                  style: theme.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  doulist.owner.name,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.time.substring(0, 10),
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
