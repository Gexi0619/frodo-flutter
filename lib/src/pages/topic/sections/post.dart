import 'package:flutter/material.dart';

import '../../../models/topic.dart';
import '../../../widgets/content_block.dart';
import '../../../widgets/topic_content.dart';
import '../../../widgets/user_avatar.dart';

double? _aspectRatio(TopicImage img) {
  final w = img.width, h = img.height;
  return (w != null && h != null && h > 0) ? w / h : null;
}

/// 讨论主体：标题、作者行、正文 / 摘要、配图。
class TopicPost extends StatelessWidget {
  const TopicPost({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final content = topic.content;
    final photoSizes = <String, double>{
      for (final p in topic.photos)
        if (p.images?.large case final large?)
          if (large.url case final url?)
            if (_aspectRatio(large) case final ar?)
              url: ar,
    };
    final blocks = (content != null && content.isNotEmpty)
        ? parseTopicContent(content, photoSizes: photoSizes)
        : <ContentBlock>[];

    final picImages = [
      for (final p in topic.photos)
        if (p.images?.large case final large?)
          if (large.url case final url?)
            ImageBlock(
              url: url,
              aspectRatio: _aspectRatio(large),
              caption: p.title?.isNotEmpty == true ? p.title : null,
            ),
    ];

    final isPicMode = topic.imageLayout == 'horizontal';

    final textBlocks = (isPicMode && picImages.isNotEmpty)
        ? blocks.where((b) => b is! ImageBlock).toList()
        : blocks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          topic.title,
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            UserAvatar(url: topic.author?.avatar),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                [
                  if (topic.author?.name != null) topic.author!.name,
                  if (topic.createTime != null) topic.createTime,
                ].whereType<String>().join(' · '),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: scheme.outline),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isPicMode && picImages.isNotEmpty) ...[
          PicModeGallery(images: picImages),
          if (textBlocks.isNotEmpty) const SizedBox(height: 16),
        ],
        if (textBlocks.isNotEmpty)
          TopicContent(blocks: textBlocks)
        else if (!isPicMode && topic.abstract != null)
          Text(topic.abstract!, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
