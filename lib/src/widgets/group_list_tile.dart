import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/group.dart';
import '../routing/app_routes.dart';
import 'frodo_image.dart';

/// 竖排小组列表里的一行：左侧圆角头像 + 名称 / 成员数·讨论数 / 最近更新（或简介）。
/// 用户主页「小组」与「我的小组」整页共用同一行样式。
class GroupListTile extends StatelessWidget {
  const GroupListTile({super.key, required this.group, this.onTap});

  final Group group;

  /// 默认点进小组详情；传入可覆盖（如需要 go 而非 push）。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = group.avatar ?? group.largeAvatar;

    final memberText = group.memberCountText ??
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

    return InkWell(
      onTap: onTap ?? () => context.push(AppRoutes.group(group.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: url != null && url.isNotEmpty
                  ? FrodoImage.tile(
                      imageUrl: url,
                      width: 56,
                      height: 56,
                      errorIcon: Icons.group,
                      errorIconSize: 24,
                    )
                  : Container(
                      width: 56,
                      height: 56,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.group,
                          color: theme.colorScheme.outline, size: 24),
                    ),
            ),
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
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ],
                  if (detail != null && detail.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
