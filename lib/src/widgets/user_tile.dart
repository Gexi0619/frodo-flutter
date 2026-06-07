import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/author.dart';
import '../routing/app_routes.dart';
import '../ui/dimens.dart';
import 'user_avatar.dart';

/// 列表里的一行用户：头像 + 昵称，点击进入其主页。
/// 搜索 / 关注 / 被关注等用户列表共用。
class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.author});

  final Author author;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.push(AppRoutes.user(author.id)),
      child: Padding(
        padding: Dim.tile,
        child: Row(
          children: [
            UserAvatar(url: author.avatar, radius: Dim.avatarMd / 2),
            const SizedBox(width: Dim.md),
            Expanded(
              child: Text(
                author.name,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
