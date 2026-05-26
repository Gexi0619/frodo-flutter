import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../utils/link_launcher.dart';
import '../../../widgets/frodo_image.dart';
import '../../../widgets/image_viewer_page.dart';
import '../../../widgets/user_avatar.dart';

/// Avatar + name + optional subtitle line + optional trailing widget.
/// Shared by comments.dart (_CommentTile) and comment_replies.dart (_ReplyTile).
class CommentHeader extends StatelessWidget {
  const CommentHeader({
    super.key,
    required this.avatarUrl,
    required this.authorName,
    this.avatarRadius = 16.0,
    this.avatarSpacing = 10.0,
    this.subtitle,
    this.trailing,
  });

  final String? avatarUrl;
  final String authorName;
  final double avatarRadius;
  final double avatarSpacing;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatar(url: avatarUrl, radius: avatarRadius),
        SizedBox(width: avatarSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Quoted-comment block shown when a comment or reply references another comment.
/// [collapsible] = true uses [CollapsibleText]; false uses a plain 2-line Text.
class CommentRefQuote extends StatelessWidget {
  const CommentRefQuote({
    super.key,
    required this.authorName,
    required this.text,
    this.collapsible = true,
  });

  final String authorName;
  final String text;
  final bool collapsible;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: collapsible
          ? CollapsibleText(text, style: style, prefix: '$authorName: ')
          : Text(
              '$authorName: $text',
              style: style,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}

/// Text that collapses to 5 lines when content exceeds 150 characters.
class CollapsibleText extends StatefulWidget {
  const CollapsibleText(this.text, {super.key, this.style, this.prefix});

  final String text;
  final TextStyle? style;

  /// Bold prefix rendered before the body (e.g. quoted author's name).
  final String? prefix;

  @override
  State<CollapsibleText> createState() => _CollapsibleTextState();
}

class _CollapsibleTextState extends State<CollapsibleText> {
  static const _threshold = 150;
  static const _maxLines = 5;

  /// 匹配 http/https URL，到下一处空白为止；常见尾随标点在生成 span 时再剥离。
  static final _urlPattern = RegExp(r'https?://\S+');
  static final _trailingPunctPattern =
      RegExp(r'[.,;:!?)\]}>"。，；：！？]+$');

  bool _expanded = false;
  double? _scrollOffsetBeforeExpand;
  final _recognizers = <TapGestureRecognizer>[];

  @override
  void didUpdateWidget(CollapsibleText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.prefix != widget.prefix) {
      _disposeRecognizers();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  void _openLink(String url) {
    openLink(context, url);
  }

  /// 将文本切分成普通段与链接段。每次构建前重置 recognizer，避免泄漏。
  List<InlineSpan> _buildSpans(BuildContext context) {
    _disposeRecognizers();
    final linkColor = Theme.of(context).colorScheme.primary;
    final spans = <InlineSpan>[];
    if (widget.prefix case final prefix?) {
      spans.add(TextSpan(
        text: prefix,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ));
    }
    final text = widget.text;
    var last = 0;
    for (final m in _urlPattern.allMatches(text)) {
      var url = m.group(0)!;
      url = url.replaceFirst(_trailingPunctPattern, '');
      if (url.isEmpty) continue;
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start)));
      }
      final recognizer = TapGestureRecognizer()..onTap = () => _openLink(url);
      _recognizers.add(recognizer);
      spans.add(TextSpan(
        text: url,
        style: TextStyle(color: linkColor),
        recognizer: recognizer,
      ));
      last = m.start + url.length;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }
    return spans;
  }

  void _onToggle() {
    if (!_expanded) {
      _scrollOffsetBeforeExpand = Scrollable.maybeOf(context)?.position.pixels;
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
    return Text.rich(
      TextSpan(
        style: widget.style ?? DefaultTextStyle.of(context).style,
        children: _buildSpans(context),
      ),
      maxLines: maxLines,
      overflow: overflow,
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

/// Optimistic-update like button for a comment or reply.
/// Shared by the main comment list and the replies sheet.
class CommentVoteButton extends ConsumerStatefulWidget {
  const CommentVoteButton({
    super.key,
    required this.topicId,
    required this.comment,
  });

  final String topicId;
  final Comment comment;

  @override
  ConsumerState<CommentVoteButton> createState() => _CommentVoteButtonState();
}

class _CommentVoteButtonState extends ConsumerState<CommentVoteButton> {
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
    return InkWell(
      onTap: (_voted || _loading) ? null : _onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 8, top: 4, bottom: 4),
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------

/// Photo grid for a comment or reply. Opens a full-screen viewer on tap.
class CommentPhotos extends StatelessWidget {
  const CommentPhotos({super.key, required this.photos});

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
      ImageViewerPage.route(
        urls: urls,
        initialIndex: initialIndex.clamp(0, urls.length - 1),
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
        if (isAnimated) const GifBadge(),
      ],
    );
  }
}
