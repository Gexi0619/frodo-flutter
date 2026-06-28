import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/group.dart';
import '../../widgets/error_view.dart';
import '../../widgets/group_list_tile.dart';
import 'providers.dart';
import 'sticky_group_menu.dart';

/// 「我的小组」整页：竖排列表，按 member_role 分「已加入 / 申请中 / 我关注的」
/// 三个分类，每类一个 Material 风格分组标题。数据走 joined_groups?page=home。
class MyGroupsPage extends ConsumerWidget {
  const MyGroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myGroupsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('我的小组')),
      body: async.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(myGroupsProvider),
        ),
        data: (groups) {
          if (groups.isEmpty) {
            return const Center(child: Text('还没有加入或关注任何小组'));
          }
          // 按分类分桶，保持接口返回的原始顺序。
          final joined = <Group>[];
          final applying = <Group>[];
          final following = <Group>[];
          for (final g in groups) {
            switch (g.joinStatus) {
              case GroupJoinStatus.joined:
                joined.add(g);
              case GroupJoinStatus.applying:
                applying.add(g);
              case GroupJoinStatus.notJoined:
              case GroupJoinStatus.unknown:
                following.add(g);
            }
          }
          final sections = <(String, List<Group>)>[
            ('已加入', joined),
            ('申请中', applying),
            ('我关注的', following),
          ].where((s) => s.$2.isNotEmpty).toList();

          return CustomScrollView(
            slivers: [
              for (final (title, items) in sections) ...[
                _CategoryHeader(title: title, count: items.length),
                SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 0.5, indent: 84),
                  itemBuilder: (context, i) => GroupListTile(
                    group: items[i],
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      tooltip: '更多',
                      color: Theme.of(context).colorScheme.outline,
                      onPressed: () =>
                          showGroupStickyMenu(context, ref, items[i]),
                    ),
                  ),
                ),
              ],
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          );
        },
      ),
    );
  }
}

/// 分类分组标题：Material 风格，主题色小标题 + 数量。
class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Row(
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
