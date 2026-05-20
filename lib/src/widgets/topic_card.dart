import 'package:flutter/material.dart';

import '../models/topic.dart';
import '../utils/format.dart';
import '../utils/time.dart';
import 'frodo_image.dart';

enum TopicFeedViewMode { compact, card }

class TopicCard extends StatelessWidget {
  const TopicCard({super.key, required this.topic, this.onTap, this.header});

  final Topic topic;
  final VoidCallback? onTap;
  /// 替换顶行小组信息的自定义 widget。
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final abstract = topic.abstract?.trim() ?? '';
    final timeLabel = formatRelativeTime(topic.updateTime ?? topic.createTime) ?? '';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header != null
                  ? header!
                  : Row(
                children: [
                  _GroupAvatar(url: topic.group?.avatar),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      topic.group?.name ?? '',
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.outline),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (timeLabel.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      timeLabel,
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.outline),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 9),
              Text(
                topic.title,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600, height: 1.35),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (abstract.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  abstract,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              _PhotoSection(topic: topic),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (topic.author?.name case final name when name != null && name.isNotEmpty) ...[
                    if (topic.author?.avatar case final av when av != null && av.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: ClipOval(
                          child: FrodoImage(imageUrl: av, width: 16, height: 16, fit: BoxFit.cover),
                        ),
                      ),
                    Text(
                      name,
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.outline),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Icon(Icons.chat_bubble_outline_rounded, size: 14, color: scheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    formatCount(topic.commentsCount ?? 0),
                    style: theme.textTheme.labelSmall?.copyWith(color: scheme.outline),
                  ),
                  if ((topic.reactionsCount ?? 0) > 0) ...[
                    const SizedBox(width: 14),
                    Icon(Icons.favorite_border_rounded, size: 14, color: scheme.outline),
                    const SizedBox(width: 4),
                    Text(
                      formatCount(topic.reactionsCount!),
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.outline),
                    ),
                  ],
                  if ((topic.resharesCount ?? 0) > 0) ...[
                    const SizedBox(width: 14),
                    Icon(Icons.repeat_rounded, size: 14, color: scheme.outline),
                    const SizedBox(width: 4),
                    Text(
                      formatCount(topic.resharesCount!),
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.outline),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final photos = topic.photos;
    final cover = topic.coverUrl;

    if (photos.isEmpty) {
      if (cover == null || cover.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: AspectRatio(
            aspectRatio: 2.4,
            child: FrodoImage.tile(imageUrl: cover),
          ),
        ),
      );
    }

    final displayPhotos = photos.take(9).toList();
    final count = displayPhotos.length;
    const crossCount = 3;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: count,
        itemBuilder: (_, i) {
          final img = displayPhotos[i].images?.normal ?? displayPhotos[i].images?.large;
          final url = img?.url ?? '';
          if (url.isEmpty) return const SizedBox.shrink();
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: FrodoImage.tile(imageUrl: url),
          );
        },
      ),
    );
  }
}
class _GroupAvatar extends StatelessWidget {
  const _GroupAvatar({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const size = 22.0;
    const radius = BorderRadius.all(Radius.circular(6));
    if (url != null && url!.isNotEmpty) {
      return ClipRRect(
        borderRadius: radius,
        child: FrodoImage(imageUrl: url!, width: size, height: size, fit: BoxFit.cover),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: radius,
      ),
      child: Icon(Icons.group, size: 16, color: scheme.outline),
    );
  }
}

