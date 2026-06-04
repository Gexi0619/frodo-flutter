import 'package:flutter/material.dart';

import '../models/collection.dart';
import '../utils/time.dart';
import 'frodo_image.dart';
import 'user_avatar.dart';

class DoulistCover extends StatelessWidget {
  const DoulistCover({super.key, this.url, this.size = 44});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: url != null && url!.isNotEmpty
          ? FrodoImage(
              imageUrl: url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            )
          : ColoredBox(
              color: scheme.surfaceContainerHighest,
              child: SizedBox(
                width: size,
                height: size,
                child: Icon(Icons.list, size: size * 0.5, color: scheme.outline),
              ),
            ),
    );
  }
}

/// 卡片式豆列展示：大封面图 + 标题 + 作者 + 创建时间。
class DoulistCard extends StatelessWidget {
  const DoulistCard({super.key, required this.doulist, this.onTap});

  final Doulist doulist;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final coverUrl = doulist.coverUrl;

    const double imgSize = 64;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: imgSize,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: imgSize,
                    child: coverUrl != null && coverUrl.isNotEmpty
                        ? FrodoImage(
                            imageUrl: coverUrl,
                            width: imgSize,
                            height: imgSize,
                            fit: BoxFit.cover,
                          )
                        : ColoredBox(
                            color: scheme.surfaceContainerHighest,
                            child: Icon(
                                Icons.list, size: 32, color: scheme.outline),
                          ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 2, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                doulist.title,
                                style: theme.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (doulist.createTime != null) ...[
                              const SizedBox(width: 6),
                              Text(
                                formatRelativeDate(doulist.createTime),
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(color: scheme.outline),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            UserAvatar(url: doulist.owner.avatar, radius: 8, userId: doulist.owner.id),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                doulist.owner.name,
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              doulist.isPrivate == true
                                  ? Icons.lock_outline
                                  : Icons.public,
                              size: 13,
                              color: scheme.outline,
                            ),
                            if (doulist.itemsCount != null) ...[
                              const SizedBox(width: 4),
                              Text(
                                '${doulist.itemsCount} 条',
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(color: scheme.outline),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DoulistListTile extends StatelessWidget {
  const DoulistListTile({
    super.key,
    required this.title,
    required this.coverUrl,
    this.isPrivate,
    this.itemsCount,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? coverUrl;
  final bool? isPrivate;
  final int? itemsCount;

  /// 额外 trailing 内容（如收藏按钮），放在条数文字右侧。
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListTile(
      onTap: onTap,
      leading: DoulistCover(url: coverUrl),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPrivate == true ? Icons.lock_outline : Icons.public,
            size: 14,
            color: scheme.outline,
          ),
          if (itemsCount != null) ...[
            const SizedBox(width: 3),
            Text(
              '$itemsCount 条',
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.outline),
            ),
          ],
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}
