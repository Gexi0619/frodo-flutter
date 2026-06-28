import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../auth/auth_providers.dart';
import '../../models/collection.dart';
import '../../models/doulist_post.dart';
import '../../repositories/topic_repository.dart';
import '../../routing/app_routes.dart';
import '../../utils/time.dart';
import '../../widgets/frodo_image.dart';
import '../../widgets/paged_builders.dart';
import '../../widgets/paging_mixin.dart';
import '../../widgets/scroll_to_top_fab.dart';
import '../../widgets/doulist_post_card.dart';
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
    // 仅自己的豆列可编辑收藏语。
    final canEdit = doulist?.owner.id == ref.watch(currentUserIdProvider);

    return Scaffold(
      floatingActionButton: ScrollToTopFab(
        visible: showScrollToTopFab,
        onPressed: () => animateScrollToTop(_scrollController),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        // iOS 回弹物理：让 CupertinoSliverRefreshControl 在各平台都能下拉触发。
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(doulist?.title ?? '豆列'),
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              ref.invalidate(_doulistDetailProvider(widget.doulistId));
              pagingController.refresh();
            },
          ),
          SliverToBoxAdapter(
              child: switch (detailAsync) {
                AsyncData(:final value) => _DoulistHeader(doulist: value),
                AsyncLoading() when widget.seed != null =>
                  _DoulistHeader(doulist: widget.seed!),
                AsyncLoading() => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CupertinoActivityIndicator()),
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
                itemBuilder: (context, post, _) => DoulistPostCard(
                  post: post,
                  editableDoulistId: canEdit ? widget.doulistId : null,
                  onTap: post.content != null
                      ? () => context.push(AppRoutes.topic(post.content!.id))
                      : null,
                ),
              ),
            ),
          ],
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
    final desc = doulist.desc?.trim();
    final hasDesc = desc != null && desc.isNotEmpty;
    final tags = doulist.tags;

    const double coverSize = 84;

    final metaParts = <String>[
      if (doulist.itemsCount != null) '${doulist.itemsCount} 条内容',
      if (doulist.followersCount != null) '${doulist.followersCount} 人关注',
      if (doulist.updateTime != null)
        '更新于 ${formatRelativeDate(doulist.updateTime)}',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面 + 作者 + 隐私标签（标题已上移到导航栏大标题）
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: doulist.coverUrl != null && doulist.coverUrl!.isNotEmpty
                    ? FrodoImage(
                        imageUrl: doulist.coverUrl!,
                        width: coverSize,
                        height: coverSize,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: coverSize,
                        height: coverSize,
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          CupertinoIcons.list_bullet,
                          size: coverSize * 0.42,
                          color: scheme.outline,
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        UserAvatar(
                          url: doulist.owner.avatar,
                          radius: 11,
                          userId: doulist.owner.id,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            doulist.owner.name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _PrivacyChip(isPrivate: doulist.isPrivate == true),
                      ],
                    ),
                    if (metaParts.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        metaParts.join('  |  '),
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: scheme.outline),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (hasDesc) ...[
            const SizedBox(height: 12),
            Text(
              desc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
          ],
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in tags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
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
        ],
      ),
    );
  }
}

/// 豆列公开/私密状态的小药丸标签。
class _PrivacyChip extends StatelessWidget {
  const _PrivacyChip({required this.isPrivate});

  final bool isPrivate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPrivate ? CupertinoIcons.lock : CupertinoIcons.globe,
            size: 12,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 3),
          Text(
            isPrivate ? '私密' : '公开',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

