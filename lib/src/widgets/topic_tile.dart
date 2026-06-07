import 'package:flutter/material.dart';

import '../models/topic.dart';
import '../ui/dimens.dart';
import '../utils/format.dart';
import '../utils/time.dart';
import 'frodo_image.dart';

class TopicTile extends StatelessWidget {
  const TopicTile({super.key, required this.topic, this.onTap, this.showGroup = false});

  final Topic topic;
  final VoidCallback? onTap;
  /// 将副标题从作者名换成来源小组名（用于 feed 场景）。
  final bool showGroup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final cover = (topic.coverUrl != null && topic.coverUrl!.isNotEmpty)
        ? topic.coverUrl
        : null;
    final sourceLabel = showGroup ? topic.group?.name : topic.author?.name;
    final sourceAvatar = showGroup ? topic.group?.avatar : topic.author?.avatar;
    final timeLabel = formatRelativeTime(topic.updateTime ?? topic.createTime);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: Dim.tile,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: Dim.iconBadge,
              height: Dim.iconBadge,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_rounded,
                    size: Dim.iconBadge,
                    color: _commentColor(topic.commentsCount ?? 0, scheme),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: Dim.xs),
                    child: Text(
                      formatCount(topic.commentsCount ?? 0),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.surface,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dim.md),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: Dim.coverTile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      topic.title,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dim.sm),
                    Row(
                      children: [
                        if (sourceAvatar != null && sourceAvatar.isNotEmpty) ...[
                          _miniAvatar(sourceAvatar, isGroup: showGroup),
                          const SizedBox(width: Dim.xs),
                        ],
                        Expanded(
                          child: Text(
                            _joinMeta([sourceLabel, timeLabel]),
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: scheme.outline),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (cover != null) ...[
              const SizedBox(width: Dim.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(Dim.radiusSm),
                child: FrodoImage.tile(
                  imageUrl: cover,
                  width: Dim.coverTile,
                  height: Dim.coverTile,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Color _commentColor(int count, ColorScheme scheme) {
  final t = (count / 500).clamp(0.0, 1.0);
  return Color.lerp(scheme.outlineVariant, scheme.primary, t)!;
}

String _joinMeta(Iterable<String?> parts) {
  return parts
      .where((p) => p != null && p.isNotEmpty)
      .cast<String>()
      .join(' · ');
}

Widget _miniAvatar(String url, {required bool isGroup, double size = Dim.avatarSm}) {
  final img = FrodoImage(imageUrl: url, width: size, height: size, fit: BoxFit.cover);
  return isGroup
      ? ClipRRect(borderRadius: BorderRadius.circular(Dim.radiusSm), child: img)
      : ClipOval(child: img);
}
