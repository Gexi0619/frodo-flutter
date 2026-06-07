import 'package:flutter/material.dart';

import '../models/topic.dart';
import '../theme.dart';
import '../ui/dimens.dart';
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
    final metaStyle =
        theme.extension<AppTextStyles>()?.micro.copyWith(color: scheme.outline);
    final abstract = topic.abstract?.trim() ?? '';
    final createLabel = formatRelativeTime(topic.createTime);
    final hasReply = topic.updateTime != null && topic.updateTime != topic.createTime;
    final updateLabel = hasReply ? formatRelativeTime(topic.updateTime) : null;
    final timeParts = [
      if (createLabel != null) '发表 $createLabel',
      if (updateLabel != null) '回复 $updateLabel',
    ];
    final timeLabel = timeParts.join(' | ');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dim.lg, vertical: Dim.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header != null
                  ? header!
                  : Row(
                children: [
                  _GroupAvatar(url: topic.group?.avatar),
                  const SizedBox(width: Dim.sm),
                  Expanded(
                    child: Text(
                      topic.group?.name ?? '',
                      style: metaStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (timeLabel.isNotEmpty) ...[
                    const SizedBox(width: Dim.sm),
                    Text(
                      timeLabel,
                      style: metaStyle,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: Dim.sm),
              Text(
                topic.title,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600, height: 1.35),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (abstract.isNotEmpty) ...[
                const SizedBox(height: Dim.xs),
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
              const SizedBox(height: Dim.md),
              Row(
                children: [
                  if (topic.author?.name case final name when name != null && name.isNotEmpty) ...[
                    if (topic.author?.avatar case final av when av != null && av.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: Dim.xs),
                        child: ClipOval(
                          child: FrodoImage(imageUrl: av, width: Dim.avatarSm, height: Dim.avatarSm, fit: BoxFit.cover),
                        ),
                      ),
                    Text(
                      name,
                      style: metaStyle,
                    ),
                    const SizedBox(width: Dim.md),
                  ],
                  Icon(Icons.chat_bubble_outline_rounded, size: Dim.iconXs, color: scheme.outline),
                  const SizedBox(width: Dim.xs),
                  Text(
                    formatCount(topic.commentsCount ?? 0),
                    style: metaStyle,
                  ),
                  if ((topic.reactionsCount ?? 0) > 0) ...[
                    const SizedBox(width: Dim.lg),
                    Icon(Icons.favorite_border_rounded, size: Dim.iconXs, color: scheme.outline),
                    const SizedBox(width: Dim.xs),
                    Text(
                      formatCount(topic.reactionsCount!),
                      style: metaStyle,
                    ),
                  ],
                  if ((topic.resharesCount ?? 0) > 0) ...[
                    const SizedBox(width: Dim.lg),
                    Icon(Icons.repeat_rounded, size: Dim.iconXs, color: scheme.outline),
                    const SizedBox(width: Dim.xs),
                    Text(
                      formatCount(topic.resharesCount!),
                      style: metaStyle,
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
        padding: const EdgeInsets.only(top: Dim.md),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dim.radiusSm),
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
      padding: const EdgeInsets.only(top: Dim.md),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: Dim.xs,
          mainAxisSpacing: Dim.xs,
        ),
        itemCount: count,
        itemBuilder: (_, i) {
          final img = displayPhotos[i].images?.normal ?? displayPhotos[i].images?.large;
          final url = img?.url ?? '';
          if (url.isEmpty) return const SizedBox.shrink();
          return ClipRRect(
            borderRadius: BorderRadius.circular(Dim.radiusXs),
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
    const radius = BorderRadius.all(Radius.circular(Dim.radiusSm));
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
      child: Icon(Icons.group, size: Dim.iconSm, color: scheme.outline),
    );
  }
}

