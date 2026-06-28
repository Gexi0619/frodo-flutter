import 'package:flutter/material.dart';

import '../../../models/topic.dart';
import '../../../theme.dart';
import '../../../ui/dimens.dart';
import '../../../utils/time.dart';
import '../../../widgets/content_block.dart';
import '../../../widgets/shimmer_loading.dart';
import '../../../widgets/topic_content.dart';
import '../../../widgets/topic_video_player.dart';
import '../../../widgets/user_avatar.dart';

double? _aspectRatio(TopicImage img) {
  final w = img.width, h = img.height;
  return (w != null && h != null && h > 0) ? w / h : null;
}

/// 讨论主体：标题、作者行、正文 / 摘要、配图。
///
/// [isContentLoading] 用于配合 seed 渲染：正文（`topic.content`）未到时
/// 显示骨架占位，而不是空白或仅 abstract。
class TopicPost extends StatelessWidget {
  const TopicPost({
    super.key,
    required this.topic,
    this.isContentLoading = false,
  });

  final Topic topic;
  final bool isContentLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = topic.content;
    final photoSizes = <String, double>{
      for (final p in topic.photos)
        if (p.images?.large case final large?)
          if (large.url case final url?)
            if (_aspectRatio(large) case final ar?) url: ar,
    };
    // Live 图：缩略图 url → mp4 源。键与 photoSizes 一致（large.url），
    // 供正文 block 解析时透传给对应的 image-container。
    final liveVideos = <String, String>{
      for (final p in topic.photos)
        if (p.images?.isLive == true)
          if (p.images?.large?.url case final url?)
            if (p.images?.video?.url case final videoUrl?) url: videoUrl,
    };
    final blocks = (content != null && content.isNotEmpty)
        ? parseTopicContent(
            content,
            photoSizes: photoSizes,
            liveVideos: liveVideos,
          )
        : <ContentBlock>[];

    final picImages = [
      for (final p in topic.photos)
        if (p.images?.large case final large?)
          if (large.url case final url?)
            ImageBlock(
              url: url,
              aspectRatio: _aspectRatio(large),
              caption: p.title?.isNotEmpty == true ? p.title : null,
              liveVideoUrl: p.images?.isLive == true
                  ? p.images?.video?.url
                  : null,
            ),
    ];

    final isPicMode = topic.imageLayout == 'horizontal';

    final textBlocks = (isPicMode && picImages.isNotEmpty)
        ? blocks.where((b) => b is! ImageBlock).toList()
        : blocks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(topic.title, style: theme.textTheme.titleLarge),
        const SizedBox(height: Dim.xs),
        _TopicTimeMeta(topic: topic),
        const SizedBox(height: Dim.md),
        _AuthorMeta(topic: topic),
        const SizedBox(height: Dim.lg),
        if (topic.videoInfo?.videoUrl?.isNotEmpty == true) ...[
          TopicVideoPlayer(info: topic.videoInfo!),
          const SizedBox(height: Dim.lg),
        ],
        if (isPicMode && picImages.isNotEmpty) ...[
          PicModeGallery(images: picImages),
          if (textBlocks.isNotEmpty || isContentLoading)
            const SizedBox(height: Dim.lg),
        ],
        if (textBlocks.isNotEmpty)
          TopicContent(blocks: textBlocks)
        else if (isContentLoading)
          const ShimmerTextLines(lineCount: 6)
        else if (!isPicMode && topic.abstract != null)
          Text(topic.abstract!, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

/// 发表时间 | 最后回复时间，位于标题正下方。
class _TopicTimeMeta extends StatelessWidget {
  const _TopicTimeMeta({required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final metaStyle = Theme.of(context)
        .extension<AppTextStyles>()
        ?.micro
        .copyWith(color: Theme.of(context).colorScheme.outline);

    final isEdited = topic.editTime != null && topic.editTime!.isNotEmpty;

    final parts = <String>[
      if (topic.createTime != null)
        '发表 ${formatRelativeTime(topic.createTime) ?? topic.createTime!}',
      if (isEdited)
        '已编辑 ${formatRelativeTime(topic.editTime) ?? topic.editTime!}',
      if (topic.updateTime != null && topic.updateTime != topic.createTime)
        '最后回复 ${formatRelativeTime(topic.updateTime) ?? topic.updateTime!}',
    ];

    if (parts.isEmpty) return const SizedBox.shrink();
    return Text(parts.join(' | '), style: metaStyle);
  }
}

/// 作者行：头像 + 昵称 | IP 属地。
class _AuthorMeta extends StatelessWidget {
  const _AuthorMeta({required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final nameStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final secondaryStyle = theme.textTheme.labelSmall?.copyWith(
      color: scheme.outline,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UserAvatar(url: topic.author?.avatar, userId: topic.author?.id),
        const SizedBox(width: Dim.sm),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (topic.author?.name != null)
                Flexible(
                  child: Text(
                    topic.author!.name,
                    style: nameStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (topic.ipLocation != null && topic.ipLocation!.isNotEmpty) ...[
                Text(' | ', style: secondaryStyle),
                Text(topic.ipLocation!, style: secondaryStyle),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
