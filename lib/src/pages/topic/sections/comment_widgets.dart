import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/comment.dart';
import '../../../theme.dart';
import '../../../repositories/topic_repository.dart';
import '../../../ui/dimens.dart';
import '../../../utils/link_launcher.dart';
import '../../../utils/parsing.dart';
import '../../../utils/time.dart';
import '../../settings/providers.dart';
import '../../../widgets/frodo_image.dart';
import '../../../widgets/image_viewer_page.dart';
import '../../../widgets/user_avatar.dart';

/// 评论 / 回复的统一行排版：头像 + 作者 + 元信息 + 正文（引用块 / 可折叠文本 /
/// 图片）+ 点赞按钮。主评论列表与楼中楼弹层共用，保证两处排版一致。
///
/// 水平内边距由本组件承担（[horizontalPadding]）并包在 [InkWell] 内，
/// 这样点击高亮可以顶到列表左右两边——外层 sliver 不应再加水平内边距。
/// [actions] 追加到点赞按钮所在行（如主列表的回复气泡）；
/// [footer] 追加到整行底部（如主列表的楼中楼预览）。
class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.topicId,
    required this.comment,
    this.onTap,
    this.actions = const [],
    this.footer,
    this.opAuthorId,
    this.horizontalPadding = Dim.lg,
  });

  final String topicId;
  final Comment comment;
  final VoidCallback? onTap;
  final List<Widget> actions;
  final Widget? footer;

  /// 帖子楼主的用户 id；与评论作者 id 相等时在用户名后加「楼主」标签。
  final String? opAuthorId;

  /// 内容到列表左右边缘的水平内边距。点击高亮覆盖整行宽度，内容保持此缩进。
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final metaParts = [
      if (comment.ipLocation != null) comment.ipLocation!,
      if (comment.createTime != null)
        formatRelativeTime(comment.createTime) ?? comment.createTime!,
    ];
    final metaLabel = metaParts.isEmpty ? null : metaParts.join(' | ');
    // 楼中楼里直接回复父楼时 ref_comment.id == parent_comment_id，引用与父楼重复，隐藏。
    final ref = comment.refComment;
    final showRef = ref != null && ref.id != comment.parentCommentId;
    // 纯图片评论的 text 是空串而非 null，需判空避免渲染出一行空白。
    final bodyText = comment.text?.trim();
    final hasBody = bodyText != null && bodyText.isNotEmpty;
    final isOp = opAuthorId != null && comment.author?.id == opAuthorId;

    return InkWell(
      onTap: onTap,
      child: Padding(
        // 上 sm；下 xs——点赞按钮自带 xs 内边距，合计约 sm，与顶部对称，
        // 同时收紧按钮到分割线的间隔。水平内边距在此（InkWell 内），让点击区顶边。
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          top: Dim.sm,
          bottom: Dim.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(
                  url: comment.author?.avatar,
                  radius: Dim.avatarSm,
                  userId: comment.author?.id,
                ),
                const SizedBox(width: Dim.sm),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          comment.author?.name ?? '匿名',
                          overflow: TextOverflow.ellipsis,
                          style: theme.extension<AppTextStyles>()?.micro
                              .copyWith(
                            fontWeight: FontWeight.w600,
                            color: scheme.outline,
                          ),
                        ),
                      ),
                      if (isOp) ...[
                        const SizedBox(width: Dim.xs),
                        _TagPill(text: '楼主', color: scheme.primary),
                      ],
                      if (comment.author?.isManager == true) ...[
                        const SizedBox(width: Dim.xs),
                        _TagPill(text: '管理员', color: scheme.primary),
                      ],
                      if (comment.author?.memberTitle case final title?
                          when title.isNotEmpty) ...[
                        const SizedBox(width: Dim.xs),
                        _MemberTitleTag(
                          title: title,
                          color: comment.author?.memberTitleColor,
                        ),
                      ],
                    ],
                  ),
                ),
                if (metaLabel != null)
                  Text(
                    metaLabel,
                    style: theme.extension<AppTextStyles>()?.micro
                        .copyWith(color: scheme.outline),
                  ),
              ],
            ),
            const SizedBox(height: Dim.sm),
            if (showRef) ...[
              CommentRefQuote(
                authorName: ref.author?.name ?? '用户',
                text: ref.text ?? '',
              ),
              const SizedBox(height: Dim.sm),
            ],
            if (comment.isFolded) ...[
              _FoldedNotice(
                reason: comment.foldedReasonText ?? comment.foldedMessage,
              ),
              const SizedBox(height: Dim.sm),
            ],
            if (hasBody)
              CollapsibleText(
                bodyText,
                // 行高对齐 post 正文（topic_content 的 1.65），读感更松。
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.65),
              ),
            if (comment.photos.isNotEmpty) ...[
              const SizedBox(height: Dim.sm),
              CommentPhotos(photos: comment.photos),
            ],
            const SizedBox(height: Dim.xs),
            Row(
              children: [
                CommentVoteButton(topicId: topicId, comment: comment),
                ...actions,
              ],
            ),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}

/// 用户名后的小药丸标签：指定色的浅底 + 同色加粗文字。楼主 / 管理员 / 会员头衔共用。
class _TagPill extends StatelessWidget {
  const _TagPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final micro = Theme.of(context).extension<AppTextStyles>()?.micro;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dim.xs, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dim.radiusXs),
      ),
      child: Text(
        text,
        style: micro?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}

/// 被折叠评论的提示条：仍展示正文，但在上方加一条说明折叠原因的浅底标注。
class _FoldedNotice extends StatelessWidget {
  const _FoldedNotice({this.reason});

  final String? reason;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final micro = Theme.of(context).extension<AppTextStyles>()?.micro;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dim.sm,
        vertical: Dim.xs,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(Dim.radiusSm),
      ),
      child: Row(
        children: [
          Icon(
            Icons.visibility_off_outlined,
            size: Dim.iconXs,
            color: scheme.outline,
          ),
          const SizedBox(width: Dim.xs),
          Expanded(
            child: Text(
              reason ?? '该内容已被折叠',
              style: micro?.copyWith(color: scheme.outline),
            ),
          ),
        ],
      ),
    );
  }
}

/// 用户名后的会员头衔小标签（如「朋丫」）。默认取 `member_title_color` 原色，
/// 用户可在设置里改成统一主题色。
class _MemberTitleTag extends ConsumerWidget {
  const _MemberTitleTag({required this.title, this.color});

  final String title;
  final String? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final useOriginal = ref.watch(memberTitleOriginalColorProvider);
    final c = useOriginal
        ? hexToColor(color, fallback: scheme.primary)
        : scheme.primary;
    return _TagPill(text: title, color: c);
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
    final style = Theme.of(context).extension<AppTextStyles>()?.micro;
    return Container(
      padding: const EdgeInsets.all(Dim.sm),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(Dim.radiusSm),
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
        // 可折叠时，点击正文区域即展开 / 收起；正文内的链接 span 仍由各自的
        // recognizer 优先响应，不受影响。
        GestureDetector(
          onTap: _onToggle,
          child: _content(maxLines: _expanded ? null : _maxLines),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: _onToggle,
            child: Text(
              _expanded ? '收起' : '展开',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
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
      borderRadius: BorderRadius.circular(Dim.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dim.xs, vertical: Dim.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 始终渲染文本（无赞时为空串），用其行高把按钮高度固定下来，
            // 使 0 赞与有赞数时的上下边距一致；空串宽度为 0，故只在有数字时留间距。
            Text(
              _count > 0 ? '$_count' : '',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: color),
            ),
            if (_count > 0) const SizedBox(width: Dim.xxs),
            Icon(
              _voted ? Icons.thumb_up : Icons.thumb_up_outlined,
              size: Dim.iconXs,
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
          borderRadius: BorderRadius.circular(Dim.radiusSm),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160, maxHeight: 160),
            child: inner,
          ),
        ),
      );
    }

    const size = 72.0;
    const spacing = Dim.xs;
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
                  borderRadius: BorderRadius.circular(Dim.radiusXs),
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
