import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/group.dart';
import '../../../routing/app_routes.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/frodo_image.dart';
import '../providers.dart';

/// 用户主页「小组」子页：统一用 profile_group_info，自己和别人都走同一接口，
/// 不区分创建/加入/关注，单块横向小组栏。
/// 作为 sliver 嵌进 [UserPage] 的 CustomScrollView。
class UserGroupsView extends ConsumerWidget {
  const UserGroupsView({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(userGroupsProvider(userId));
    return SliverToBoxAdapter(
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: ErrorView(
            error: e,
            onRetry: () => ref.invalidate(userGroupsProvider(userId)),
          ),
        ),
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GroupBlock(title: '小组', groups: data.groups, total: data.total),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// 一个小组小块：标题（含数量）+ 横向滚动的小组图标条；空则显示占位。
class _GroupBlock extends StatelessWidget {
  const _GroupBlock({
    required this.title,
    required this.groups,
    required this.total,
  });

  final String title;
  final List<Group> groups;

  /// 小组总数（可能大于已展示的 [groups] 条数）。
  final int total;

  static const double _stripHeight = 112;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
          child: Row(
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 6),
              if (total > 0)
                Text(
                  '$total',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
            ],
          ),
        ),
        if (groups.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              '暂无',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
          )
        else
          SizedBox(
            height: _stripHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: groups.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) => _GroupIcon(group: groups[i]),
            ),
          ),
      ],
    );
  }
}

class _GroupIcon extends StatelessWidget {
  const _GroupIcon({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = group.avatar ?? group.largeAvatar;
    return GestureDetector(
      onTap: () => context.push(AppRoutes.group(group.id)),
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: url != null && url.isNotEmpty
                  ? FrodoImage.tile(
                      imageUrl: url,
                      width: 64,
                      height: 64,
                      errorIcon: Icons.group,
                      errorIconSize: 28,
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.group,
                          color: theme.colorScheme.outline, size: 28),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              group.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
