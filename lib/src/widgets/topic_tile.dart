import 'package:flutter/material.dart';

import '../models/topic.dart';
import 'frodo_image.dart';

class TopicTile extends StatelessWidget {
  const TopicTile({super.key, required this.topic, this.onTap});

  final Topic topic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final cover = (topic.coverUrl != null && topic.coverUrl!.isNotEmpty)
        ? topic.coverUrl
        : null;
    final author = topic.author;
    final timeLabel = _formatRelative(topic.updateTime ?? topic.createTime);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 44,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatCount(topic.commentsCount ?? 0),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '回应',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: scheme.outline),
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
                    _joinMeta([author?.name, timeLabel]),
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
                child: FrodoImage(
                  imageUrl: cover,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 64,
                    height: 64,
                    color: scheme.surfaceContainerHighest,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 64,
                    height: 64,
                    color: scheme.surfaceContainerHighest,
                    child: Icon(Icons.broken_image,
                        size: 20, color: scheme.outline),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
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
