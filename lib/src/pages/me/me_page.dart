import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_providers.dart';
import '../../constants.dart';
import '../../routing/app_routes.dart';
import '../../widgets/account_switcher.dart';
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

    final groupedBg = CupertinoColors.systemGroupedBackground.resolveFrom(
      context,
    );
    return Scaffold(
      backgroundColor: groupedBg,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('我的'),
            backgroundColor: groupedBg.withValues(alpha: 0.9),
            border: null,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () => context.push(AppRoutes.settings()),
              child: const Icon(CupertinoIcons.settings, size: 24),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                CupertinoListSection.insetGrouped(
                  children: [
                    _ProfileHeader(
                      name: account?.name ?? '未登录',
                      // 登录后进个人主页（不显示文字）；未登录则进账号管理页登录。
                      subtitle: account != null ? null : '管理账号',
                      avatar: account?.avatar,
                      onTap: () => context.push(
                        account != null
                            ? AppRoutes.user(userId)
                            : AppRoutes.accounts(),
                      ),
                      // 已登录时才提供切换入口。
                      onSwitch: account != null
                          ? () => showAccountSwitcher(
                              context,
                              onManage: () {
                                Navigator.of(context).pop(); // 关面板
                                context.push(AppRoutes.accounts());
                              },
                            )
                          : null,
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  children: [
                    _MeEntry(
                      icon: CupertinoIcons.list_bullet,
                      label: '我的豆列',
                      onTap: () => context.push(AppRoutes.meDoulists()),
                    ),
                    _MeEntry(
                      icon: CupertinoIcons.bookmark,
                      label: '我的收藏',
                      onTap: () => context.push(AppRoutes.meCollections()),
                    ),
                    _MeEntry(
                      icon: CupertinoIcons.square_pencil,
                      label: '我发布的',
                      onTap: () => context.push(AppRoutes.mePosted()),
                    ),
                    _MeEntry(
                      icon: CupertinoIcons.chat_bubble_2,
                      label: '我回复的',
                      onTap: () => context.push(AppRoutes.meReplied()),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  children: [
                    _MeEntry(
                      icon: CupertinoIcons.person_2,
                      label: '账号管理',
                      onTap: () => context.push(AppRoutes.accounts()),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 头像入口（iOS 设置风格的大头像单元）：头像 + 名字 + 右侧切换/箭头，
/// 点击进入自己的用户主页。
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.subtitle,
    required this.avatar,
    required this.onTap,
    this.onSwitch,
  });

  final String name;
  final String? subtitle;
  final String? avatar;
  final VoidCallback onTap;

  /// 非空时在右侧显示「切换账号」按钮。
  final VoidCallback? onSwitch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return CupertinoListTile(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leadingSize: 48,
      leadingToTitle: 14,
      // 纯展示，点击交给整行的 onTap（避免头像内置的二次跳转）。
      leading: UserAvatar(url: avatar, radius: 24),
      title: Text(
        name,
        style: theme.textTheme.titleMedium,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: onSwitch != null
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: onSwitch,
              child: Icon(
                CupertinoIcons.chevron_up_chevron_down,
                color: scheme.outline,
                size: 20,
              ),
            )
          : const CupertinoListTileChevron(),
      onTap: onTap,
    );
  }
}

/// 单个导航按钮行：图标 + 文案 + 右侧箭头（iOS 列表项样式）。
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
    return CupertinoListTile.notched(
      leading: Icon(icon, color: scheme.primary),
      title: Text(label),
      trailing: const CupertinoListTileChevron(),
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
