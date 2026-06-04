import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/collection.dart';
import '../../../repositories/topic_repository.dart';
import '../../../routing/app_routes.dart';
import '../../../utils/time.dart';
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
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      topicListsRefreshTickProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    return PagedSliverList<int, Collection>.separated(
      pagingController: pagingController,
      separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
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
    return InkWell(
      onTap: () =>
          context.push(AppRoutes.doulist(doulist.id), extra: doulist),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(url: doulist.owner.avatar, userId: doulist.owner.id),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doulist.owner.name,
                    style: theme.textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: '收藏到 '),
                        TextSpan(
                          text: doulist.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatRelativeTime(item.time) ?? item.time.substring(0, 10),
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
