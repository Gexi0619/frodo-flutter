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
    final doulist = widget.seed;
    final coverUrl = doulist?.coverUrl;
    final hasExpanded = coverUrl != null && coverUrl.isNotEmpty;

    return Scaffold(
      floatingActionButton: ScrollToTopFab(
        visible: showScrollToTopFab,
        onPressed: () => animateScrollToTop(_scrollController),
      ),
      body: RefreshIndicator(
        onRefresh: () async => pagingController.refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: hasExpanded ? 160 : null,
              forceElevated: true,
              title: Text(doulist?.title ?? '豆列'),
              flexibleSpace: hasExpanded
                  ? FlexibleSpaceBar(
                      background: FrodoImage(
                        imageUrl: coverUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : null,
            ),
            PagedSliverList<int, DoulistPost>.separated(
              pagingController: pagingController,
              separatorBuilder: (_, __) => const Divider(height: 0.5),
              builderDelegate: frodoPagedDelegate<DoulistPost>(
                controller: pagingController,
                emptyText: '暂无帖子',
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
                      reason!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.outline,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  _StatRow(post: post, scheme: scheme, textTheme: theme.textTheme),
                ],
              ),
            ),
            if (hasThumb) ...[
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FrodoImage.tile(
                  imageUrl: thumbUrl!,
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
