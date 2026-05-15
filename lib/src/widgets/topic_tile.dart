import 'package:flutter/material.dart';

import '../models/topic.dart';
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
    final timeLabel = _formatRelative(topic.updateTime ?? topic.createTime);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_rounded,
                    size: 36,
                    color: _commentColor(topic.commentsCount ?? 0, scheme),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      _formatCount(topic.commentsCount ?? 0),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.surface,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    topic.title,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _joinMeta([sourceLabel, timeLabel]),
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: scheme.outline),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (cover != null) ...[
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FrodoImage.tile(
                  imageUrl: cover,
                  width: 64,
                  height: 64,
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

String _formatCount(int n) {
  if (n < 1000) return '$n';
  if (n < 10000) return '${(n / 1000).toStringAsFixed(1)}k';
  return '${(n / 10000).toStringAsFixed(1)}w';
}

String? _formatRelative(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final dt = DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  if (dt == null) return raw;
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inSeconds < 60) return '刚刚';
  if (diff.inMinutes < 60) return '${diff.inMinutes} 分钟前';
  if (diff.inHours < 24) return '${diff.inHours} 小时前';
  if (diff.inDays < 7) return '${diff.inDays} 天前';
  if (dt.year == now.year) return '${_pad2(dt.month)}-${_pad2(dt.day)}';
  return '${dt.year}-${_pad2(dt.month)}-${_pad2(dt.day)}';
}

String _pad2(int v) => v.toString().padLeft(2, '0');
