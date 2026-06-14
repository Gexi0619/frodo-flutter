import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_providers.dart';
import '../../constants.dart';
import '../../routing/app_routes.dart';
import '../../ui/dimens.dart';
import '../../widgets/user_avatar.dart';

/// 「我的」标签页。
///
/// 顶部是当前账号的头像入口（点击进入自己的用户主页），下面是四个导航
/// 按钮：我的豆列 / 我的收藏 / 我发布的 / 我回复的，分别跳到对应的列表页。
class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(activeAccountProvider);
    final userId = account?.userId ?? FrodoConstants.defaultUserId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            tooltip: '设置',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings()),
          ),
        ],
      ),
      body: ListView(
        children: [
          _ProfileHeader(
            name: account?.name ?? '未登录',
            // 登录后才提示这是进入个人主页的入口。
            subtitle: account != null ? '我的主页' : null,
            avatar: account?.avatar,
            onTap: () => context.push(AppRoutes.user(userId)),
          ),
          const SizedBox(height: Dim.sm),
          _MeEntry(
            icon: Icons.list_alt_outlined,
            label: '我的豆列',
            onTap: () => context.push(AppRoutes.meDoulists()),
          ),
          _MeEntry(
            icon: Icons.bookmark_outline,
            label: '我的收藏',
            onTap: () => context.push(AppRoutes.meCollections()),
          ),
          _MeEntry(
            icon: Icons.edit_note_outlined,
            label: '我发布的',
            onTap: () => context.push(AppRoutes.mePosted()),
          ),
          _MeEntry(
            icon: Icons.forum_outlined,
            label: '我回复的',
            onTap: () => context.push(AppRoutes.meReplied()),
          ),
        ],
      ),
    );
  }
}

/// 头像入口：头像 + 名字 + 右侧指示箭头，点击进入自己的用户主页。
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
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
            // 纯展示，点击交给整行的 InkWell（避免头像内置的二次跳转）。
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.outline,
                  ),
                ),
              ),
            Icon(Icons.chevron_right, color: scheme.outline),
          ],
        ),
      ),
    );
  }
}

/// 单个导航按钮行：图标 + 文案 + 右侧箭头。
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

/// 「我的」二级列表页的统一外壳：标题栏 + 内容（复用收藏页的各分区）。
class MeSectionPage extends StatelessWidget {
  const MeSectionPage({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: child,
    );
  }
}
