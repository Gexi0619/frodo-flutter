import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../constants.dart';
import '../../../models/doulist_post.dart';
import '../../../models/topic.dart';
import '../../../repositories/topic_repository.dart';
import '../../../routing/app_routes.dart';
import '../../../utils/time.dart';
import '../../topic/providers.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/topic_card.dart';

class SavedPosts extends ConsumerStatefulWidget {
  const SavedPosts({super.key});

  @override
  ConsumerState<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends ConsumerState<SavedPosts>
    with PagingMixin<DoulistPost, SavedPosts> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref.read(topicRepositoryProvider).fetchDoulistPosts(
          FrodoConstants.defaultUserId,
          start: start,
          count: kPageSize,
        );
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        PagedSliverList<int, DoulistPost>.separated(
          pagingController: pagingController,
          separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.6),
          builderDelegate: frodoPagedDelegate<DoulistPost>(
            controller: pagingController,
            emptyText: '还没有收录的帖子',
            itemBuilder: (context, post, _) => TopicCard(
              topic: _toTopic(post),
              header: _buildHeader(context, post),
              onTap: () {
                final id = post.content?.id ?? post.id;
                prefetchTopic(ref, id);
                context.go(AppRoutes.savedTopic(id), extra: _toTopic(post));
              },
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, DoulistPost post) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final date = formatRelativeDate(post.collectionTime);
    final doulist = post.doulist;
    return Row(
      children: [
        if (date.isNotEmpty)
          Text(date, style: theme.textTheme.labelSmall?.copyWith(color: scheme.outline)),
        if (date.isNotEmpty && doulist != null)
          Text(' · ', style: theme.textTheme.labelSmall?.copyWith(color: scheme.outline)),
        if (doulist != null)
          GestureDetector(
            onTap: () => context.go(AppRoutes.doulist(doulist.id)),
            child: Text(
              doulist.title,
              style: theme.textTheme.labelSmall?.copyWith(color: scheme.primary),
            ),
          ),
      ],
    );
  }

  Topic _toTopic(DoulistPost post) {
    final c = post.content;
    return Topic(
      id: c?.id ?? post.id,
      title: c?.title ?? '',
      abstract: c?.abstract,
      author: c?.author,
      photos: c?.photos ?? [],
      commentsCount: post.commentsCount,
      reactionsCount: post.reactionsCount,
      resharesCount: post.resharesCount,
    );
  }
}
