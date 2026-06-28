import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/group.dart';
import '../routing/app_routes.dart';
import 'cupertino_tappable.dart';
import 'frodo_image.dart';

/// 竖排小组列表里的一行：左侧圆角头像 + 名称 / 成员数·讨论数 / 最近更新（或简介）。
/// 用户主页「小组」与「我的小组」整页共用同一行样式。
class GroupListTile extends StatelessWidget {
  const GroupListTile({
    super.key,
    required this.group,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  final Group group;

  /// 默认点进小组详情；传入可覆盖（如需要 go 而非 push）。
  final VoidCallback? onTap;

  /// 长按回调（如置顶/取消置顶）；不传则不响应长按。
  final VoidCallback? onLongPress;

  /// 行尾控件（如「更多」菜单按钮）；不传则不占位。
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = group.avatar ?? group.largeAvatar;

    final memberText =
        group.memberCountText ??
        (group.memberCount != null ? '${group.memberCount}' : null);
    final memberLabel = group.memberName ?? '成员';
    final metaParts = <String>[
      if (memberText != null) '$memberText$memberLabel',
      if (group.topicCount != null) '${group.topicCount} 讨论',
    ];

    // 第三行优先展示「最近更新」副标题，没有就退化到简介。
    final detail = (group.subtitle?.isNotEmpty ?? false)
        ? group.subtitle
        : group.descAbstract;

    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: url != null && url.isNotEmpty
          ? FrodoImage.tile(
              imageUrl: url,
              width: 56,
              height: 56,
              errorIcon: CupertinoIcons.person_2_fill,
              errorIconSize: 24,
            )
          : Container(
              width: 56,
              height: 56,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                CupertinoIcons.person_2_fill,
                color: theme.colorScheme.outline,
                size: 24,
              ),
            ),
    );

    return CupertinoTappable(
      onTap: onTap ?? () => context.push(AppRoutes.group(group.id)),
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // IntrinsicHeight 给行一个确定高度，让行尾的 trailing 能上下居中，
        // 而头像与文字仍保持顶对齐。
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 置顶小组在头像左上角叠一枚图钉。
              group.isSticky == true
                  ? Stack(
                      clipBehavior: Clip.none,
                      children: [
                        avatar,
                        Positioned(
                          top: -4,
                          left: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              CupertinoIcons.pin_fill,
                              size: 11,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    )
                  : avatar,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    if (metaParts.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        metaParts.join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                    if (detail != null && detail.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                Align(alignment: Alignment.center, child: trailing!),
            ],
          ),
        ),
      ),
    );
  }
}
