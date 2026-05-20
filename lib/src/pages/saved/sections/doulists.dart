import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants.dart';
import '../../../models/collection.dart';
import '../../../repositories/topic_repository.dart';
import '../../../routing/app_routes.dart';
import '../../../widgets/doulist_cover.dart';
import '../../../widgets/shimmer_loading.dart';

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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          const _SectionHeader(title: '我的豆列'),
          _buildSection(context, ref, owned,
              () => ref.invalidate(_ownedDoulistsProvider)),
          const _SectionHeader(title: '关注的豆列'),
          _buildSection(context, ref, following,
              () => ref.invalidate(_followingDoulistsProvider)),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Doulist>> asyncValue,
    VoidCallback onRetry,
  ) {
    return asyncValue.when(
      loading: () => const ShimmerDoulistSection(),
      error: (e, _) => Row(
        children: [
          Expanded(
            child: Text('加载失败: $e',
                style: Theme.of(context).textTheme.bodySmall),
          ),
          TextButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
      data: (items) {
        final filtered =
            items.where((d) => d.category != 'book').toList();
        return filtered.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '暂无',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline),
                  ),
                ),
              )
            : Column(
                spacing: 8,
                children: [
                  for (final d in filtered)
                    DoulistCard(
                      doulist: d,
                      onTap: () =>
                          context.push(AppRoutes.doulist(d.id), extra: d),
                    ),
                ],
              );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall
                ?.copyWith(color: scheme.primary),
          ),
        ],
      ),
    );
  }
}

