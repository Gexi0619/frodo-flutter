import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/cupertino_ux.dart';

import '../../../models/user.dart';
import '../../../routing/app_routes.dart';
import '../../../utils/format.dart';
import '../../../utils/parsing.dart';
import '../../../utils/share.dart';
import '../../../widgets/frodo_image.dart';
import '../../../widgets/user_avatar.dart';
import '../providers.dart';

/// 用户主页顶栏：滚动到一定程度后在 topbar 居中显示用户名。
/// 与 [GroupHeader] 同构——标题用 [ValueListenable] 注入，避免滚动时重建整棵子树。
class UserHeader extends ConsumerWidget {
  const UserHeader({
    super.key,
    required this.userId,
    required this.showTitle,
    this.isSelf = false,
    this.showScrollToTop = false,
    this.onScrollToTop,
  });

  final String userId;

  /// 标题是否显示，由外层页面的滚动状态驱动。
  final ValueListenable<bool> showTitle;

  /// 是否在看自己的主页：是则在 topbar 显示设置入口。
  final bool isSelf;

  /// 是否显示"回到顶部"按钮。
  final bool showScrollToTop;

  final VoidCallback? onScrollToTop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailProvider(userId)).valueOrNull;
    return SliverAppBar(
      pinned: true,
      forceElevated: true,
      titleSpacing: 0,
      surfaceTintColor: Colors.transparent,
      // 用 iOS 风格返回按钮，与小组 / 帖子页保持一致。
      automaticallyImplyLeading: false,
      leading: CupertinoNavigationBarBackButton(
        onPressed: () => context.pop(),
      ),
      title: _AppBarTitle(user: user, visible: showTitle),
      actions: [
        if (showScrollToTop)
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            onPressed: onScrollToTop,
            child: const Icon(CupertinoIcons.arrow_up, size: 22),
          ),
        if (isSelf)
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            onPressed: () => context.push('/settings'),
            child: const Icon(CupertinoIcons.settings, size: 22),
          ),
        CupertinoButton(
          padding: const EdgeInsets.only(left: 4, right: 16),
          minimumSize: Size.zero,
          onPressed: user == null
              ? null
              : () => shareText(
                    '${user.name}\nhttps://www.douban.com/people/$userId/',
                  ),
          child: const Icon(CupertinoIcons.share, size: 22),
        ),
      ],
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({required this.user, required this.visible});

  final User? user;
  final ValueListenable<bool> visible;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: visible,
      builder: (context, v, _) {
        if (!v || user == null) return const SizedBox(width: double.infinity);
        return SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserAvatar(url: user!.avatar, radius: 14),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  user!.name,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 用户主页主体头部：头图 + 头像 + 昵称/性别/属地 + 关注按钮 + 简介 + 统计。
class UserHeaderBackground extends ConsumerWidget {
  const UserHeaderBackground({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailProvider(userId)).valueOrNull;
    if (user == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(child: _Profile(user: user));
  }
}

const double _bannerHeight = 132;
const double _avatarRadius = 36;

class _Profile extends StatelessWidget {
  const _Profile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final banner = user.profileBanner;
    final bannerColor = hexToColor(
      banner?.color,
      fallback: theme.colorScheme.surfaceContainerHighest,
    );
    // is_default=true 时头图是系统底图，仍可展示，但用纯色兜底更干净。
    final bannerUrl = normalizeUrl(banner?.large ?? banner?.normal);
    final showBannerImage = bannerUrl != null && (banner?.isDefault != true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 头图 + 悬浮头像
        SizedBox(
          height: _bannerHeight + _avatarRadius,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: _bannerHeight,
                child: showBannerImage
                    ? FrodoImage(imageUrl: bannerUrl, fit: BoxFit.cover)
                    : ColoredBox(color: bannerColor),
              ),
              Positioned(
                left: 16,
                top: _bannerHeight - _avatarRadius,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.scaffoldBackgroundColor,
                      width: 3,
                    ),
                  ),
                  child: UserAvatar(
                    url: user.largeAvatar ?? user.avatar,
                    radius: _avatarRadius,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 昵称 + 性别 + 关注按钮
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _GenderIcon(gender: user.gender),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _FollowButton(user: user),
                ],
              ),
              const SizedBox(height: 6),
              _MetaLine(user: user),
              if (user.intro != null && user.intro!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  user.intro!.trim(),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: 12),
              _StatsRow(user: user),
            ],
          ),
        ),
      ],
    );
  }
}

/// 属地 / 常居地 / 注册时间，灰色小字一行，缺省项自动省略。
class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimStyle = theme.textTheme.labelMedium
        ?.copyWith(color: theme.colorScheme.outline);

    final parts = <String>[
      if (user.loc?.name != null && user.loc!.name.isNotEmpty) user.loc!.name,
      if (user.ipLocation != null && user.ipLocation!.isNotEmpty)
        'IP 属地：${user.ipLocation}',
      if (user.regTime != null && user.regTime!.isNotEmpty)
        '${_regYear(user.regTime!)}年加入',
    ];
    if (parts.isEmpty) return const SizedBox.shrink();

    return Text(
      parts.join('  ·  '),
      style: dimStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// reg_time 形如 "2016-06-28 19:51:56"，取年份。
  static String _regYear(String regTime) =>
      regTime.length >= 4 ? regTime.substring(0, 4) : regTime;
}

class _GenderIcon extends StatelessWidget {
  const _GenderIcon({required this.gender});

  final String? gender;

  @override
  Widget build(BuildContext context) {
    final g = gender;
    if (g != 'M' && g != 'F') return const SizedBox.shrink();
    final isMale = g == 'M';
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Icon(
        isMale ? Icons.male : Icons.female,
        size: 18,
        color: isMale ? const Color(0xFF4C9DE0) : const Color(0xFFE06A9D),
      ),
    );
  }
}

/// 关注 / 被关注 / 广播 / 小组数据。关注、被关注可点进列表页。
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(
          label: '关注',
          count: user.followingCount,
          onTap: () => context.push(AppRoutes.userFollowing(user.id)),
        ),
        _StatItem(
          label: '被关注',
          count: user.followersCount,
          onTap: () => context.push(AppRoutes.userFollowers(user.id)),
        ),
        _StatItem(label: '广播', count: user.statusesCount),
        _StatItem(label: '小组', count: user.joinedGroupCount),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.count, this.onTap});

  final String label;
  final int? count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(right: 24, top: 2, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count == null ? '—' : formatCount(count!),
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

/// 关注按钮，文案随关系变化：未关注=关注、对方关注我=回关、已关注=已关注、
/// 互相关注=互相关注。
///
/// TODO(follow): openapi 暂无 follow/unfollow 接口，先按 [User.relation] 渲染
/// 状态，点击仅提示。接入后改为调用 repository 并 invalidate(userDetailProvider)。
class _FollowButton extends StatelessWidget {
  const _FollowButton({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final relation = user.relation;
    final isFollowing =
        relation == UserRelation.following || relation == UserRelation.mutual;

    final label = switch (relation) {
      UserRelation.none => '关注',
      UserRelation.followsMe => '回关',
      UserRelation.following => '已关注',
      UserRelation.mutual => '互相关注',
    };

    final theme = Theme.of(context);

    void onTap() {
      showToast(context, '关注功能待接入');
    }

    // 已关注：中性次要按钮；未关注：实心主色按钮。
    if (isFollowing) {
      return CupertinoButton(
        onPressed: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        minimumSize: Size.zero,
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surfaceContainerHighest,
        child: Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
      );
    }
    return CupertinoButton(
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      minimumSize: Size.zero,
      borderRadius: BorderRadius.circular(20),
      color: theme.colorScheme.primary,
      child: Text(
        label,
        style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 14),
      ),
    );
  }
}
