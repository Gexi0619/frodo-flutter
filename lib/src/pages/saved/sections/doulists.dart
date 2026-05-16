import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../../../models/collection.dart';
import '../../../repositories/topic_repository.dart';
import '../../../widgets/frodo_image.dart';
import '../../../widgets/user_avatar.dart';

final _ownedDoulistsProvider =
    FutureProvider.autoDispose<List<Doulist>>((ref) {
  return ref
      .watch(topicRepositoryProvider)
      .fetchOwnedDoulists(FrodoConstants.defaultUserId);
});

final _followingDoulistsProvider =
    FutureProvider.autoDispose<List<Doulist>>((ref) {
  return ref
      .watch(topicRepositoryProvider)
      .fetchFollowingDoulists(FrodoConstants.defaultUserId);
});

class SavedDoulists extends ConsumerWidget {
  const SavedDoulists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owned = ref.watch(_ownedDoulistsProvider);
    final following = ref.watch(_followingDoulistsProvider);

    return ListView(
      children: [
        _DoulistSection(
          title: '我的豆列',
          count: owned.valueOrNull?.length,
          asyncValue: owned,
          onRetry: () => ref.invalidate(_ownedDoulistsProvider),
        ),
        _DoulistSection(
          title: '关注的豆列',
          count: following.valueOrNull?.length,
          asyncValue: following,
          onRetry: () => ref.invalidate(_followingDoulistsProvider),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _DoulistSection extends StatelessWidget {
  const _DoulistSection({
    required this.title,
    required this.asyncValue,
    required this.onRetry,
    this.count,
  });

  final String title;
  final int? count;
  final AsyncValue<List<Doulist>> asyncValue;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final label = count != null ? '$title ($count)' : title;

    return ExpansionTile(
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      initiallyExpanded: true,
      childrenPadding: EdgeInsets.zero,
      children: [_buildBody(context)],
    );
  }

  Widget _buildBody(BuildContext context) {
    return asyncValue.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text('加载失败: $e',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            TextButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
      data: (items) => items.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text('暂无',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline)),
              ),
            )
          : Column(
              children: [
                for (final d in items) ...[
                  _DoulistTile(doulist: d),
                  const Divider(height: 0.5, indent: 84),
                ],
              ],
            ),
    );
  }
}

class _DoulistTile extends StatelessWidget {
  const _DoulistTile({required this.doulist});

  final Doulist doulist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverUrl = doulist.coverUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: coverUrl != null && coverUrl.isNotEmpty
                ? FrodoImage.tile(imageUrl: coverUrl, width: 56, height: 56)
                : ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(Icons.bookmark_outline,
                          color: theme.colorScheme.outline, size: 24),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        doulist.title,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (doulist.isPrivate == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.lock_outline,
                            size: 14, color: theme.colorScheme.outline),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    UserAvatar(url: doulist.owner.avatar, radius: 8),
                    const SizedBox(width: 4),
                    Text(
                      doulist.owner.name,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (doulist.itemsCount != null)
                Text(
                  '${doulist.itemsCount} 条',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
              if (doulist.followersCount != null)
                Text(
                  '${doulist.followersCount} 关注',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
