import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../widgets/frodo_image.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/user_avatar.dart';
import '../providers.dart';
import 'comment_replies.dart';
import 'interaction.dart';

/// 讨论的评论区分页列表，作为 sliver 嵌入到 [TopicPage] 的 CustomScrollView 中。
class TopicComments extends ConsumerStatefulWidget {
  const TopicComments({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<TopicComments> createState() => _TopicCommentsState();
}

class _TopicCommentsState extends ConsumerState<TopicComments>
    with PagingMixin<Comment, TopicComments> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref.read(topicRepositoryProvider).fetchComments(
          widget.topicId,
          start: start,
          count: kPageSize,
        );
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      topicListsRefreshTickProvider(widget.topicId),
      (_, __) => pagingController.refresh(),
    );
    return PagedSliverList<int, Comment>.separated(
      pagingController: pagingController,
      separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5, indent: 42),
      builderDelegate: frodoPagedDelegate<Comment>(
        controller: pagingController,
        emptyText: '还没有评论',
        dense: true,
        itemBuilder: (context, comment, _) => _CommentTile(
          topicId: widget.topicId,
          comment: comment,
        ),
      ),
    );
  }
}

class _CommentTile extends ConsumerWidget {
  const _CommentTile({required this.topicId, required this.comment});

  final String topicId;
  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: () => showTopicCommentSheet(
        context,
        ref,
        topicId: topicId,
        replyTo: comment,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(url: comment.author?.avatar),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.author?.name ?? '匿名',
                              style: theme.textTheme.labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (comment.createTime != null)
                              Text(
                                comment.createTime!,
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(color: scheme.outline),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if ((comment.totalReplies ?? 0) > 0) ...[
                            _RepliesButton(topicId: topicId, comment: comment),
                            const SizedBox(width: 12),
                          ],
                          _VoteButton(topicId: topicId, comment: comment),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (comment.refComment != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _CollapsibleText(
                        comment.refComment!.text ?? '',
                        style: theme.textTheme.bodySmall,
                        prefix:
                            '${comment.refComment!.author?.name ?? "用户"}: ',
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  if (comment.text != null)
                    _CollapsibleText(comment.text!),
                  if (comment.photos.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _CommentPhotos(photos: comment.photos),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _RepliesButton extends ConsumerWidget {
  const _RepliesButton({required this.topicId, required this.comment});

  final String topicId;
  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme.outline;
    return GestureDetector(
      onTap: () => showCommentRepliesSheet(
        context,
        ref,
        topicId: topicId,
        comment: comment,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${comment.totalReplies}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
          ),
          const SizedBox(width: 3),
          Icon(Icons.chat_bubble_outline, size: 16, color: color),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _VoteButton extends ConsumerStatefulWidget {
  const _VoteButton({required this.topicId, required this.comment});

  final String topicId;
  final Comment comment;

  @override
  ConsumerState<_VoteButton> createState() => _VoteButtonState();
}

class _VoteButtonState extends ConsumerState<_VoteButton> {
  late bool _voted;
  late int _count;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _voted = widget.comment.isVoted ?? false;
    _count = widget.comment.voteCount ?? 0;
  }

  Future<void> _onTap() async {
    if (_loading || _voted) return;
    setState(() {
      _loading = true;
      _voted = true;
      _count += 1;
    });
    final ok = await ref
        .read(topicRepositoryProvider)
        .voteComment(widget.topicId, widget.comment.id);
    if (!ok && mounted) {
      setState(() {
        _voted = false;
        _count -= 1;
      });
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final color = _voted
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outline;
    return GestureDetector(
      onTap: _onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_count > 0) ...[
            Text(
              '$_count',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: color),
            ),
            const SizedBox(width: 3),
          ],
          Icon(
            _voted ? Icons.thumb_up : Icons.thumb_up_outlined,
            size: 16,
            color: color,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _CollapsibleText extends StatefulWidget {
  const _CollapsibleText(this.text, {this.style, this.prefix});

  final String text;
  final TextStyle? style;

  /// 显示在正文前的粗体前缀（如引用评论的作者名），不计入折叠阈值。
  final String? prefix;

  @override
  State<_CollapsibleText> createState() => _CollapsibleTextState();
}

class _CollapsibleTextState extends State<_CollapsibleText> {
  static const _threshold = 150;
  static const _maxLines = 5;

  bool _expanded = false;
  double? _scrollOffsetBeforeExpand;

  void _onToggle() {
    if (!_expanded) {
      _scrollOffsetBeforeExpand =
          Scrollable.maybeOf(context)?.position.pixels;
      setState(() => _expanded = true);
    } else {
      setState(() => _expanded = false);
      final target = _scrollOffsetBeforeExpand;
      if (target != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Scrollable.maybeOf(context)?.position.animateTo(
                target,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
        });
      }
    }
  }

  Widget _content({int? maxLines}) {
    final overflow =
        maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible;
    if (widget.prefix case final prefix?) {
      return RichText(
        maxLines: maxLines,
        overflow: overflow,
        text: TextSpan(
          style: widget.style ?? DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: prefix,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: widget.text),
          ],
        ),
      );
    }
    return Text(
      widget.text,
      style: widget.style,
      maxLines: maxLines,
      overflow: maxLines != null ? overflow : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.length <= _threshold) return _content();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _content(maxLines: _expanded ? null : _maxLines),
        GestureDetector(
          onTap: _onToggle,
          child: Text(
            _expanded ? '收起' : '展开',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _CommentPhotos extends StatelessWidget {
  const _CommentPhotos({required this.photos});

  final List<CommentPhoto> photos;

  @override
  Widget build(BuildContext context) {
    if (photos.length == 1) {
      final photo = photos.first;
      final url = photo.url;
      if (url == null) return const SizedBox.shrink();
      final ratio = photo.aspectRatio;
      Widget inner = _PhotoThumbnail(url: url, isAnimated: photo.isAnimated);
      if (ratio != null) inner = AspectRatio(aspectRatio: ratio, child: inner);
      return GestureDetector(
        onTap: () => _openViewer(context, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160, maxHeight: 160),
            child: inner,
          ),
        ),
      );
    }

    const size = 72.0;
    const spacing = 4.0;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (int i = 0; i < photos.length; i++)
          Builder(
            builder: (context) {
              final url = photos[i].url;
              if (url == null) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () => _openViewer(context, i),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: _PhotoThumbnail(
                      url: url,
                      isAnimated: photos[i].isAnimated,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _openViewer(BuildContext context, int initialIndex) {
    final urls = photos.map((p) => p.url).whereType<String>().toList();
    if (urls.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _PhotoViewerPage(
          photos: urls,
          initialIndex: initialIndex.clamp(0, urls.length - 1),
        ),
      ),
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  const _PhotoThumbnail({required this.url, required this.isAnimated});

  final String url;
  final bool isAnimated;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        FrodoImage.tile(imageUrl: url),
        if (isAnimated)
          Positioned(
            left: 6,
            bottom: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'GIF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PhotoViewerPage extends StatefulWidget {
  const _PhotoViewerPage({required this.photos, required this.initialIndex});

  final List<String> photos;
  final int initialIndex;

  @override
  State<_PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<_PhotoViewerPage> {
  late final PageController _pageController;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: widget.photos.length > 1
            ? Text(
                '${_current + 1} / ${widget.photos.length}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            : null,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.photos.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (_, i) => LayoutBuilder(
          builder: (context, constraints) => InteractiveViewer(
            maxScale: 4,
            child: Center(
              child: FrodoImage(
                imageUrl: widget.photos[i],
                fit: BoxFit.contain,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
