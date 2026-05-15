import 'package:flutter/material.dart';

import '../../../models/topic.dart';
import '../../../widgets/content_block.dart';
import '../../../widgets/topic_content.dart';
import '../../../widgets/user_avatar.dart';

/// 讨论主体：标题、作者行、正文 / 摘要、配图。
class TopicPost extends StatelessWidget {
  const TopicPost({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final content = topic.content;
    final blocks = (content != null && content.isNotEmpty)
        ? parseTopicContent(content)
        : <ContentBlock>[];

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
        if (blocks.isNotEmpty)
          TopicContent(blocks: blocks)
        else if (topic.abstract != null)
          Text(topic.abstract!, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
