import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/collection.dart';
import '../../models/doulist_post.dart';
import '../../repositories/topic_repository.dart';
import '../../routing/app_routes.dart';
import '../../utils/time.dart';
import '../../widgets/frodo_image.dart';
import '../../widgets/paged_builders.dart';
import '../../widgets/paging_mixin.dart';
import '../../widgets/scroll_to_top_fab.dart';
import '../../widgets/user_avatar.dart';

final _doulistDetailProvider =
    FutureProvider.autoDispose.family<Doulist, String>((ref, id) {
  return ref.watch(topicRepositoryProvider).fetchDoulistDetail(id);
});

class DoulistPage extends ConsumerStatefulWidget {
  const DoulistPage({
    super.key,
    required this.doulistId,
    this.seed,
  });

  final String doulistId;
  final Doulist? seed;

  @override
  ConsumerState<DoulistPage> createState() => _DoulistPageState();
}

class _DoulistPageState extends ConsumerState<DoulistPage>
    with PagingMixin<DoulistPost, DoulistPage>, FabVisibilityMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() =>
      updateFabVisibility(_scrollController.position.pixels);

  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref.read(topicRepositoryProvider).fetchDoulistItems(
          widget.doulistId,
          start: start,
          count: kPageSize,
        );
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(_doulistDetailProvider(widget.doulistId));
    final doulist = detailAsync.valueOrNull ?? widget.seed;

    return Scaffold(
      floatingActionButton: ScrollToTopFab(
        visible: showScrollToTopFab,
        onPressed: () => animateScrollToTop(_scrollController),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(_doulistDetailProvider(widget.doulistId));
          pagingController.refresh();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              forceElevated: true,
              title: Text(doulist?.title ?? '豆列'),
            ),
            SliverToBoxAdapter(
              child: switch (detailAsync) {
                AsyncData(:final value) => _DoulistHeader(doulist: value),
                AsyncLoading() when widget.seed != null =>
                  _DoulistHeader(doulist: widget.seed!),
                AsyncLoading() => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                AsyncError(:final error) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '加载失败: $error',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                _ => const SizedBox.shrink(),
              },
            ),
            const SliverToBoxAdapter(child: Divider(height: 1)),
            PagedSliverList<int, DoulistPost>.separated(
              pagingController: pagingController,
              separatorBuilder: (_, __) => const Divider(height: 0.5),
              builderDelegate: frodoPagedDelegate<DoulistPost>(
                controller: pagingController,
                emptyText: '暂无内容',
                itemBuilder: (context, post, _) => _PostTile(
                  post: post,
                  onTap: post.content != null
                      ? () => context.push(
                            AppRoutes.savedTopic(post.content!.id),
                          )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoulistHeader extends StatelessWidget {
  const _DoulistHeader({required this.doulist});

  final Doulist doulist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final desc = doulist.desc;
    final hasDesc = desc != null && desc.isNotEmpty;
    final tags = doulist.tags;

    const double coverSize = 72;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover + title + private badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: doulist.coverUrl != null && doulist.coverUrl!.isNotEmpty
                    ? FrodoImage(
                        imageUrl: doulist.coverUrl!,
                        width: coverSize,
                        height: coverSize,
                        fit: BoxFit.cover,
                      )
                    : ColoredBox(
                        color: scheme.surfaceContainerHighest,
                        child: SizedBox(
                          width: coverSize,
                          height: coverSize,
                          child: Icon(
                            Icons.list_alt,
                            size: coverSize * 0.45,
                            color: scheme.outline,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: coverSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              doulist.title,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(height: 1.3),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            doulist.isPrivate == true
                                ? Icons.lock_outline
                                : Icons.public,
                            size: 13,
                            color: scheme.outline,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            doulist.isPrivate == true ? '私密' : '公开',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: scheme.outline),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          UserAvatar(url: doulist.owner.avatar, radius: 10),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              doulist.owner.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Stats
          Row(
            children: [
              if (doulist.itemsCount != null) ...[
                Icon(Icons.list_alt, size: 14, color: scheme.outline),
                const SizedBox(width: 3),
                Text(
                  '${doulist.itemsCount} 条内容',
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: scheme.outline),
                ),
                const SizedBox(width: 16),
              ],
              if (doulist.followersCount != null) ...[
                Icon(Icons.people_outline, size: 14, color: scheme.outline),
                const SizedBox(width: 3),
                Text(
                  '${doulist.followersCount} 人关注',
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: scheme.outline),
                ),
              ],
            ],
          ),
          if (hasDesc) ...[
            const SizedBox(height: 10),
            Text(
              desc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final tag in tags)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
              ],
            ),
          ],
          if (doulist.updateTime != null) ...[
            const SizedBox(height: 10),
            Text(
              '更新于 ${formatRelativeDate(doulist.updateTime)}',
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: scheme.outlineVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _PostTile extends StatelessWidget {
  const _PostTile({required this.post, this.onTap});

  final DoulistPost post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final content = post.content;
    if (content == null) return const SizedBox.shrink();

    final thumbUrl = content.photos.isNotEmpty
        ? (content.photos.first.images?.normal?.url ??
            content.photos.first.images?.large?.url)
        : null;
    final hasThumb = thumbUrl != null && thumbUrl.isNotEmpty;

    final reason = post.collectionReason;
    final hasReason = reason != null && reason.isNotEmpty;

    final meta = [
      content.author?.name,
      formatRelativeDate(post.collectionTime),
    ].where((s) => s != null && s.isNotEmpty).join(' · ');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(url: content.author?.avatar, radius: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meta,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: scheme.outline),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasReason) ...[
                    const SizedBox(height: 4),
                    Text(
                      reason,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.outline,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  _StatRow(
                    post: post,
                    scheme: scheme,
                    textTheme: theme.textTheme,
                  ),
                ],
              ),
            ),
            if (hasThumb) ...[
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FrodoImage.tile(
                  imageUrl: thumbUrl,
                  width: 64,
                  height: 64,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.post,
    required this.scheme,
    required this.textTheme,
  });

  final DoulistPost post;
  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final style =
        textTheme.labelSmall?.copyWith(color: scheme.outlineVariant);
    return Row(
      children: [
        Icon(Icons.chat_bubble_outline, size: 13, color: scheme.outlineVariant),
        const SizedBox(width: 3),
        Text('${post.commentsCount ?? 0}', style: style),
        const SizedBox(width: 12),
        Icon(Icons.favorite_border, size: 13, color: scheme.outlineVariant),
        const SizedBox(width: 3),
        Text('${post.reactionsCount ?? 0}', style: style),
      ],
    );
  }
}
