import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'content_block.dart';
import 'frodo_image.dart';

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
    final linkStyle = bodyStyle?.copyWith(
      color: linkColor,
      decoration: TextDecoration.underline,
      decorationColor: linkColor,
    );

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

  void _play() {
    setState(() {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..loadRequest(Uri.parse(widget.block.embedUrl));
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
    final placeholderColor = block.bgColor ?? scheme.surfaceContainerHighest;

    Widget image = ClipRRect(
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
    );

    if (block.aspectRatio != null) {
      image = AspectRatio(aspectRatio: block.aspectRatio!, child: image);
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
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _ImageViewerPage(
          images: allImages,
          initialIndex: imageIndex,
          heroTag: _heroTag,
        ),
      ),
    );
  }
}

// ─── 全屏图片翻阅器 ───────────────────────────────────────────────────────────

class _ImageViewerPage extends StatefulWidget {
  const _ImageViewerPage({
    required this.images,
    required this.initialIndex,
    required this.heroTag,
  });

  final List<ImageBlock> images;
  final int initialIndex;
  final String heroTag;

  @override
  State<_ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<_ImageViewerPage> {
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
    final caption = widget.images[_current].caption;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: widget.images.length > 1
            ? Text(
                '${_current + 1} / ${widget.images.length}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            : null,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) {
              final isInitial = i == widget.initialIndex;
              final child = LayoutBuilder(
                builder: (context, constraints) => InteractiveViewer(
                  maxScale: 4,
                  child: Center(
                    child: FrodoImage(
                      imageUrl: widget.images[i].url,
                      fit: BoxFit.contain,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                  ),
                ),
              );
              if (isInitial) return Hero(tag: widget.heroTag, child: child);
              return child;
            },
          ),
          if (caption != null && caption.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 16 + bottomPad),
                  child: Text(
                    caption,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
