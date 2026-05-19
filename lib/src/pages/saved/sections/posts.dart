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
import '../../../widgets/frodo_image.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/user_avatar.dart';

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
        PagedSliverList<int, DoulistPost>(
          pagingController: pagingController,
          builderDelegate: frodoPagedDelegate<DoulistPost>(
            controller: pagingController,
            emptyText: '还没有收录的帖子',
            itemBuilder: (context, post, _) => _PostCard(
              post: post,
              onTap: () {
                final id = post.content?.id ?? post.id;
                context.go(AppRoutes.savedTopic(id));
              },
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.onTap});

  final DoulistPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final content = post.content;
    final photos = content?.photos ?? [];
    final hasNote = post.collectionReason != null &&
        post.collectionReason!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 收藏元信息行
            Row(
              children: [
                Icon(Icons.bookmark, size: 13, color: scheme.primary),
                const SizedBox(width: 4),
                Text(
                  '收藏于 ${formatRelativeDate(post.collectionTime)}',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: scheme.primary),
                ),
              ],
            ),

            // 备注（有才显示）
            if (hasNote) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notes, size: 12, color: scheme.outline),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        post.collectionReason!,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 8),

            // 帖子内容主体
            if (content != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (content.abstract != null &&
                            content.abstract!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            content.abstract!,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // 单张封面图（有图时右侧展示）
                  if (photos.length == 1) ...[
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: _photoWidget(photos.first, 72, 72),
                    ),
                  ],
                ],
              ),

              // 多张图横向滚动条
              if (photos.length > 1) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: _photoWidget(photos[i], 80, 80),
                    ),
                  ),
                ),
              ],

              // 作者 + 计数行
              const SizedBox(height: 8),
              Row(
                children: [
                  if (content.author != null) ...[
                    UserAvatar(url: content.author!.avatar, radius: 8),
                    const SizedBox(width: 4),
                    Text(
                      content.author!.name,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: scheme.outline),
                    ),
                    const SizedBox(width: 10),
                  ],
                  if (post.commentsCount != null)
                    _MetaChip(
                      icon: Icons.chat_bubble_outline,
                      label: '${post.commentsCount}',
                    ),
                  const SizedBox(width: 8),
                  if (post.reactionsCount != null)
                    _MetaChip(
                      icon: Icons.thumb_up_outlined,
                      label: '${post.reactionsCount}',
                    ),
                ],
              ),
            ],

            const SizedBox(height: 14),
            const Divider(height: 0.5),
          ],
        ),
      ),
    );
  }

  Widget _photoWidget(TopicPhoto photo, double w, double h) {
    final url = photo.images?.normal?.url ?? photo.images?.large?.url;
    if (url == null || url.isEmpty) {
      return SizedBox(width: w, height: h);
    }
    return FrodoImage.tile(imageUrl: url, width: w, height: h);
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(color: Theme.of(context).colorScheme.outline);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 2),
        Text(label, style: style),
      ],
    );
  }
}

