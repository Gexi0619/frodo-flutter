import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import '../utils/parsing.dart';

sealed class ContentBlock {
  const ContentBlock();
}

final class TextBlock extends ContentBlock {
  const TextBlock(this.text);
  final String text;
}

/// 含内联链接的段落，需要 rich text 渲染。
final class RichTextBlock extends ContentBlock {
  const RichTextBlock(this.spans);
  final List<InlineContent> spans;
}

final class ImageBlock extends ContentBlock {
  const ImageBlock({
    required this.url,
    this.caption,
    this.bgColor,
    this.aspectRatio,
    this.isGif = false,
  });
  final String url;
  final String? caption;
  final String? bgColor; // CSS hex, e.g. "#201820"
  final double? aspectRatio;
  final bool isGif;
}

final class VideoBlock extends ContentBlock {
  const VideoBlock({required this.bvid, this.title});
  final String bvid;
  final String? title;
}

// ─── 内联内容类型（用于 RichTextBlock）───────────────────────────────────────

sealed class InlineContent {
  const InlineContent();
}

final class PlainText extends InlineContent {
  const PlainText(this.text);
  final String text;
}

final class LinkText extends InlineContent {
  const LinkText({required this.displayText, required this.url});
  final String displayText;
  final String url;
}

// ─── 解析器 ───────────────────────────────────────────────────────────────────

/// 将 topic content 字段（富文本 HTML）解析为有类型的 block 列表。
///
/// 豆瓣 Frodo 富文本结构顶层元素：
///   - `<p>` → TextBlock / RichTextBlock
///   - `<div class="image-container">` → ImageBlock
///   - `<div class="video-wrapper">` → VideoBlock
List<ContentBlock> parseTopicContent(
  String html, {
  Map<String, double> photoSizes = const {},
}) {
  final doc = html_parser.parse(html);
  final root = doc.getElementById('content') ?? doc.body;
  if (root == null) return [];

  final blocks = <ContentBlock>[];
  for (final el in root.children) {
    final block = _parseElement(el, photoSizes);
    if (block != null) blocks.add(block);
  }
  return blocks;
}

ContentBlock? _parseElement(dom.Element el, Map<String, double> photoSizes) {
  switch (el.localName) {
    case 'p':
      return _parseParagraph(el);
    case 'div':
      if (el.classes.contains('image-container')) return _parseImageContainer(el, photoSizes);
      if (el.classes.contains('video-wrapper')) return _parseVideoWrapper(el);
      return null;
    default:
      return null;
  }
}

/// 段落含 `<a>` → RichTextBlock；否则 → TextBlock。
ContentBlock? _parseParagraph(dom.Element el) {
  if (el.querySelector('a') == null) {
    final text = _extractText(el).trim();
    return text.isEmpty ? null : TextBlock(text);
  }

  final spans = _extractSpans(el);
  if (spans.isEmpty) return null;
  return RichTextBlock(spans);
}

ImageBlock? _parseImageContainer(dom.Element el, Map<String, double> photoSizes) {
  final img = el.querySelector('img');
  // GIF images store the animated original in data-original-url; fall back to src.
  final isGif = img?.attributes['data-render-type'] == 'gif';
  final rawUrl = isGif
      ? (img?.attributes['data-original-url'] ?? img?.attributes['src'])
      : img?.attributes['src'];
  final src = normalizeUrl(rawUrl);
  if (src == null) return null;
  final caption = el.querySelector('.image-caption')?.text.trim();
  // photoSizes is keyed by the webp thumbnail URL; look up via src attr as fallback.
  final thumbUrl = normalizeUrl(img?.attributes['src']);
  final aspectRatio = photoSizes[thumbUrl] ?? photoSizes[src];
  return ImageBlock(
    url: src,
    caption: (caption == null || caption.isEmpty) ? null : caption,
    bgColor: _parseBgColorHex(img?.attributes['style']),
    aspectRatio: aspectRatio,
    isGif: isGif,
  );
}

VideoBlock? _parseVideoWrapper(dom.Element el) {
  final src = el.querySelector('iframe')?.attributes['src'];
  if (src == null) return null;
  final bvid = Uri.tryParse(src)?.queryParameters['bvid'];
  if (bvid == null || bvid.isEmpty) return null;
  final title = el.querySelector('.video-title')?.text.trim();
  return VideoBlock(
    bvid: bvid,
    title: (title == null || title.isEmpty) ? null : title,
  );
}

/// 递归提取纯文本，将 `<br>` 转换为换行符。
String _extractText(dom.Element el) {
  final buf = StringBuffer();
  for (final node in el.nodes) {
    if (node.nodeType == dom.Node.TEXT_NODE) {
      buf.write(node.text);
    } else if (node is dom.Element) {
      buf.write(node.localName == 'br' ? '\n' : _extractText(node));
    }
  }
  return buf.toString();
}

/// 递归提取内联 span 列表，`<a>` 节点转为 [LinkText]。
List<InlineContent> _extractSpans(dom.Element el) {
  final spans = <InlineContent>[];
  for (final node in el.nodes) {
    if (node.nodeType == dom.Node.TEXT_NODE) {
      final text = node.text ?? '';
      if (text.isNotEmpty) spans.add(PlainText(text));
    } else if (node is dom.Element) {
      if (node.localName == 'br') {
        spans.add(const PlainText('\n'));
      } else if (node.localName == 'a') {
        final href = _resolveHref(node.attributes['href']);
        final text = node.text.trim();
        if (href != null && text.isNotEmpty) {
          spans.add(LinkText(displayText: text, url: href));
        } else if (text.isNotEmpty) {
          spans.add(PlainText(text));
        }
      } else {
        spans.addAll(_extractSpans(node));
      }
    }
  }
  return spans;
}

/// 解包豆瓣跳转链接 `douban.com/link2/?url=<encoded>`，返回原始 URL。
String? _resolveHref(String? raw) {
  final url = normalizeUrl(raw);
  if (url == null) return null;
  final uri = Uri.tryParse(url);
  if (uri != null && uri.host.contains('douban.com') && uri.path == '/link2/') {
    final inner = uri.queryParameters['url'];
    if (inner != null && inner.isNotEmpty) return normalizeUrl(inner) ?? url;
  }
  return url;
}

/// 从 `style="background-color: #rrggbb"` 提取 hex 字符串，如 `"#201820"`。
String? _parseBgColorHex(String? style) {
  if (style == null) return null;
  return RegExp(r'background-color:\s*(#[0-9a-fA-F]{6})').firstMatch(style)?.group(1);
}
