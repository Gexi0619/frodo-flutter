import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/auth_providers.dart';
import '../../../constants.dart';
import '../../../models/group.dart';
import '../../../routing/app_routes.dart';
import '../../../ui/dimens.dart';
import '../../../widgets/frodo_image.dart';
import '../../../widgets/user_avatar.dart';
import '../providers.dart';

/// 首页侧边栏：当前账号入口 + 我的小组（前 5 个）+ 搜索 / 设置。
///
/// 账号头像点击进入个人主页（同「我的」页）；小组取首页同款 [joinedGroupsProvider]
/// 的前 5 个，点击进小组详情；底部是搜索与设置两行入口。
class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  /// 关闭抽屉后再导航，避免抽屉盖在新页面上。
  void _go(BuildContext context, VoidCallback action) {
    Navigator.of(context).pop();
    action();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(activeAccountProvider);
    final userId = account?.userId ?? FrodoConstants.defaultUserId;
    final joined = ref.watch(joinedGroupsProvider);

    return Drawer(
      // 比默认（约 304）窄一些，约屏宽的 70%，并设上限避免大屏过宽。
      width: (MediaQuery.sizeOf(context).width * 0.70).clamp(240.0, 300.0),
      child: SafeArea(
        child: Column(
          children: [
            _AccountHeader(
              name: account?.name ?? '未登录',
              subtitle: account != null ? '我的主页' : null,
              avatar: account?.avatar,
              onTap: () =>
                  _go(context, () => context.push(AppRoutes.user(userId))),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _MeEntry(
                    icon: Icons.list_alt_outlined,
                    label: '我的豆列',
                    onTap: () => _go(
                        context, () => context.push(AppRoutes.meDoulists())),
                  ),
                  _MeEntry(
                    icon: Icons.bookmark_outline,
                    label: '我的收藏',
                    onTap: () => _go(
                        context, () => context.push(AppRoutes.meCollections())),
                  ),
                  _MeEntry(
                    icon: Icons.edit_note_outlined,
                    label: '我发布的',
                    onTap: () => _go(
                        context, () => context.push(AppRoutes.mePosted())),
                  ),
                  _MeEntry(
                    icon: Icons.forum_outlined,
                    label: '我回复的',
                    onTap: () => _go(
                        context, () => context.push(AppRoutes.meReplied())),
                  ),
                  const Divider(height: 1),
                  joined.when(
                    loading: () => Column(
                      children: const [
                        _SectionHeader(title: '我的小组'),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: Dim.xl),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                    error: (_, __) => Column(
                      children: const [
                        _SectionHeader(title: '我的小组'),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dim.pageH, vertical: Dim.lg),
                          child: Text('加载小组失败'),
                        ),
                      ],
                    ),
                    data: (groups) {
                      final sticky =
                          groups.where((g) => g.isSticky == true).toList();
                      // 置顶单列一栏，其余仍只展示前 5 个。
                      final others = groups
                          .where((g) => g.isSticky != true)
                          .take(5)
                          .toList();
                      return Column(
                        children: [
                          if (sticky.isNotEmpty) ...[
                            const _SectionHeader(title: '置顶小组'),
                            for (final g in sticky)
                              _GroupTile(
                                group: g,
                                onTap: () => _go(context,
                                    () => context.go(AppRoutes.group(g.id))),
                              ),
                          ],
                          _SectionHeader(
                            title: '我的小组',
                            onTap: () => _go(context,
                                () => context.push(AppRoutes.myGroups())),
                          ),
                          if (groups.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: Dim.xl),
                              child: Center(child: Text('还没有加入任何小组')),
                            )
                          else
                            for (final g in others)
                              _GroupTile(
                                group: g,
                                onTap: () => _go(context,
                                    () => context.go(AppRoutes.group(g.id))),
                              ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('搜索'),
              onTap: () => _go(context, () => context.go(AppRoutes.search())),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('设置'),
              onTap: () =>
                  _go(context, () => context.push(AppRoutes.settings())),
            ),
          ],
        ),
      ),
    );
  }
}

/// 账号入口：头像 + 名字 + 右侧指示箭头，点击进入个人主页。
class _AccountHeader extends StatelessWidget {
  const _AccountHeader({
    required this.name,
    required this.subtitle,
    required this.avatar,
    required this.onTap,
  });

  final String name;
  final String? subtitle;
  final String? avatar;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dim.pageH,
          vertical: Dim.lg,
        ),
        child: Row(
          children: [
            UserAvatar(url: avatar, radius: Dim.avatarLg / 2),
            const SizedBox(width: Dim.lg),
            Expanded(
              child: Text(
                name,
                style: theme.textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(left: Dim.sm),
                child: Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: scheme.outline),
                ),
              ),
            Icon(Icons.chevron_right, color: scheme.outline),
          ],
        ),
      ),
    );
  }
}

/// 单个导航按钮行：图标 + 文案 + 右侧箭头（同「我的」页）。
class _MeEntry extends StatelessWidget {
  const _MeEntry({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: scheme.primary),
      title: Text(label),
      trailing: Icon(Icons.chevron_right, color: scheme.outline),
      onTap: onTap,
    );
  }
}

/// 抽屉里的一行小组：圆角头像 + 名称（单行）。
class _GroupTile extends StatelessWidget {
  const _GroupTile({required this.group, required this.onTap});

  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _GroupAvatar(url: group.avatar ?? group.largeAvatar),
      title: Text(
        group.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}

/// 抽屉小组行的圆角头像。
class _GroupAvatar extends StatelessWidget {
  const _GroupAvatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dim.radiusSm),
      child: url != null && url!.isNotEmpty
          ? FrodoImage.tile(
              imageUrl: url!,
              width: Dim.avatarMd,
              height: Dim.avatarMd,
              errorIcon: Icons.group,
              errorIconSize: 20,
            )
          : Container(
              width: Dim.avatarMd,
              height: Dim.avatarMd,
              color: scheme.surfaceContainerHighest,
              child: Icon(Icons.group, color: scheme.outline, size: 20),
            ),
    );
  }
}

/// 小组分区标题行：标题 + 「全部 >」。
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dim.lg, Dim.lg, Dim.lg, Dim.sm),
        child: Row(
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            if (onTap != null) ...[
              const Spacer(),
              Text(
                '全部',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
              Icon(Icons.chevron_right,
                  size: 18, color: theme.colorScheme.outline),
            ],
          ],
        ),
      ),
    );
  }
}
