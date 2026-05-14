import 'package:flutter/material.dart';

import '../../../models/topic.dart';
import '../../../widgets/frodo_html.dart';
import '../../../widgets/frodo_image.dart';
import '../../../widgets/user_avatar.dart';

/// 讨论主体：标题、作者行、正文 / 摘要、配图。
class TopicPost extends StatelessWidget {
  const TopicPost({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
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
        if (topic.content != null && topic.content!.isNotEmpty)
          FrodoHtml(data: topic.content!)
        else if (topic.abstract != null)
          Text(topic.abstract!, style: theme.textTheme.bodyMedium),
        if (topic.photos.isNotEmpty) ...[
          const SizedBox(height: 12),
          for (final photo in topic.photos)
            if ((photo.large ?? photo.normal)?.url != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FrodoImage(
                    imageUrl: (photo.large ?? photo.normal)!.url!,
                  ),
                ),
              ),
        ],
      ],
    );
  }
}
