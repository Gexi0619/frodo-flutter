import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/parsing.dart';
import 'content_block.dart';
import 'frodo_image.dart';
import 'image_viewer_page.dart';

/// 渲染解析后的富文本 block 列表。
///
/// 每种 block 对应独立 widget，互不耦合：
///   - [TextBlock] → [SelectableText]（支持长按复制）
///   - [ImageBlock] → [_ImageTile]（tap 进全屏 Hero 动画翻阅器）
class TopicContent extends StatelessWidget {
  const TopicContent({super.key, required this.blocks});

  final List<ContentBlock> blocks;

  @override
  Widget build(BuildContext context) {
    final imageBlocks = blocks.whereType<ImageBlock>().toList();

    final children = <Widget>[];
    int imageCounter = 0;

    for (final block in blocks) {
      if (children.isNotEmpty) children.add(const SizedBox(height: 12));

      if (block is TextBlock) {
        children.add(SelectableText(
          block.text,
          style: Theme.of(context).textTheme.bodyMedium,
        ));
      } else if (block is RichTextBlock) {
        children.add(_RichTextTile(spans: block.spans));
      } else if (block is ImageBlock) {
        children.add(_ImageTile(
          block: block,
          imageIndex: imageCounter,
          allImages: imageBlocks,
        ));
        imageCounter++;
      } else if (block is VideoBlock) {
        children.add(_VideoTile(block: block));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

// ─── 富文本段落（含链接）─────────────────────────────────────────────────────

class _RichTextTile extends StatefulWidget {
  const _RichTextTile({required this.spans});
  final List<InlineContent> spans;

  @override
  State<_RichTextTile> createState() => _RichTextTileState();
}

class _RichTextTileState extends State<_RichTextTile> {
  final _recognizers = <TapGestureRecognizer>[];
  final _tapCallbacks = <VoidCallback>[];

  @override
  void initState() {
    super.initState();
    for (final span in widget.spans) {
      if (span is LinkText) {
        final url = span.url;
        void onTap() {
          Clipboard.setData(ClipboardData(text: url));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('链接已复制'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        _tapCallbacks.add(onTap);
        _recognizers.add(TapGestureRecognizer()..onTap = onTap);
      }
    }
  }

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    final linkColor = Theme.of(context).colorScheme.primary;
    final linkStyle = bodyStyle?.copyWith(color: linkColor);

    int linkIdx = 0;
    final textSpans = <InlineSpan>[];
    for (final span in widget.spans) {
      if (span is PlainText) {
        textSpans.add(TextSpan(text: span.text, style: bodyStyle));
      } else if (span is LinkText) {
        final idx = linkIdx++;
        textSpans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: _tapCallbacks[idx],
            child: Icon(Icons.open_in_new_rounded, size: 14, color: linkColor),
          ),
        ));
        textSpans.add(TextSpan(
          text: ' ${span.displayText}',
          style: linkStyle,
          recognizer: _recognizers[idx],
        ));
      }
    }

    return SelectableText.rich(TextSpan(children: textSpans));
  }
}

// ─── 视频卡片 ─────────────────────────────────────────────────────────────────

class _VideoTile extends StatefulWidget {
  const _VideoTile({required this.block});
  final VideoBlock block;

  @override
  State<_VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<_VideoTile> {
  WebViewController? _controller;

  String get _embedUrl =>
      'https://www.bilibili.com/blackboard/html5mobileplayer.html?bvid=${widget.block.bvid}';

  void _play() {
    setState(() {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..loadRequest(Uri.parse(_embedUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _controller != null
                ? WebViewWidget(controller: _controller!)
                : InkWell(
                    onTap: _play,
                    child: ColoredBox(
                      color: scheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.play_circle_outline_rounded,
                          size: 56,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        if (widget.block.title != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.block.title!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ],
    );
  }
}

// ─── 图片缩略图 ───────────────────────────────────────────────────────────────

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.block,
    required this.imageIndex,
    required this.allImages,
  });

  final ImageBlock block;
  final int imageIndex;
  final List<ImageBlock> allImages;

  String get _heroTag => 'topic_img_${block.url.hashCode}';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholderColor = block.bgColor != null
        ? hexToColor(block.bgColor!)
        : scheme.surfaceContainerHighest;

    final Widget image;
    if (block.aspectRatio != null) {
      image = AspectRatio(
        aspectRatio: block.aspectRatio!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ColoredBox(
            color: placeholderColor,
            child: FrodoImage(
              imageUrl: block.url,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      );
    } else {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FrodoImage(
          imageUrl: block.url,
          fit: BoxFit.fitWidth,
          width: double.infinity,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openViewer(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(tag: _heroTag, child: image),
          if (block.caption != null) ...[
            const SizedBox(height: 4),
            Text(
              block.caption!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.outline,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  void _openViewer(BuildContext context) {
    Navigator.push(
      context,
      ImageViewerPage.route(
        urls: allImages.map((b) => b.url).toList(),
        captions: allImages.map((b) => b.caption).toList(),
        initialIndex: imageIndex,
        heroTag: _heroTag,
      ),
    );
  }
}

// ─── 图片讨论帖画廊 ───────────────────────────────────────────────────────────

/// 图片模式帖子（abstract == "[图片讨论]"）的横向翻页画廊。
class PicModeGallery extends StatefulWidget {
  const PicModeGallery({super.key, required this.images});

  final List<ImageBlock> images;

  @override
  State<PicModeGallery> createState() => _PicModeGalleryState();
}

class _PicModeGalleryState extends State<PicModeGallery> {
  late final PageController _controller;
  var _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _heroTag(int i) => 'pic_gallery_${widget.images[i].url.hashCode}';

  void _open(BuildContext context, int index) {
    Navigator.push(
      context,
      ImageViewerPage.route(
        urls: widget.images.map((b) => b.url).toList(),
        captions: widget.images.map((b) => b.caption).toList(),
        initialIndex: index,
        heroTag: _heroTag(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total = widget.images.length;

    if (total == 1) {
      final block = widget.images.first;
      final ratio = block.aspectRatio ?? 3 / 4;
      return GestureDetector(
        onTap: () => _open(context, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: ratio,
            child: Hero(
              tag: _heroTag(0),
              child: FrodoImage(
                imageUrl: block.url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: scheme.surfaceContainerHighest),
                PageView.builder(
                  controller: _controller,
                  itemCount: total,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (_, i) {
                    final block = widget.images[i];
                    return GestureDetector(
                      onTap: () => _open(context, i),
                      child: Hero(
                        tag: _heroTag(i),
                        child: FrodoImage(
                          imageUrl: block.url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      child: Text(
                        '${_current + 1} / $total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(total, (i) {
            final active = i == _current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: active ? 16 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: active ? scheme.primary : scheme.outlineVariant,
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─── 全屏图片翻阅器 ───────────────────────────────────────────────────────────

