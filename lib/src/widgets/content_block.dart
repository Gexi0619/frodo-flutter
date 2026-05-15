import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

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
  const ImageBlock({required this.url, this.caption, this.bgColor});
  final String url;
  final String? caption;
  final Color? bgColor;
}

final class VideoBlock extends ContentBlock {
  const VideoBlock({required this.bvid, this.title});
  final String bvid;
  final String? title;

  /// B 站移动端嵌入播放器，与 Douban 内嵌 iframe 保持一致。
  String get embedUrl =>
      'https://www.bilibili.com/blackboard/html5mobileplayer.html?bvid=$bvid';
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
List<ContentBlock> parseTopicContent(String html) {
  final doc = html_parser.parse(html);
  final root = doc.getElementById('content') ?? doc.body;
  if (root == null) return [];

  final blocks = <ContentBlock>[];
  for (final el in root.children) {
    final block = _parseElement(el);
    if (block != null) blocks.add(block);
  }
  return blocks;
}

ContentBlock? _parseElement(dom.Element el) {
  switch (el.localName) {
    case 'p':
      return _parseParagraph(el);
    case 'div':
      if (el.classes.contains('image-container')) return _parseImageContainer(el);
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

ImageBlock? _parseImageContainer(dom.Element el) {
  final img = el.querySelector('img');
  final src = _normalizeUrl(img?.attributes['src']);
  if (src == null) return null;
  final caption = el.querySelector('.image-caption')?.text.trim();
  return ImageBlock(
    url: src,
    caption: (caption == null || caption.isEmpty) ? null : caption,
    bgColor: _parseColor(img?.attributes['style']),
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
        final href = _normalizeUrl(node.attributes['href']);
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

String? _normalizeUrl(String? src) {
  if (src == null || src.isEmpty) return null;
  if (src.startsWith('//')) return 'https:$src';
  if (src.startsWith('http')) return src;
  return null;
}

/// 从 `style="background-color: #rrggbb"` 提取占位背景色。
Color? _parseColor(String? style) {
  if (style == null) return null;
  final m = RegExp(r'background-color:\s*#([0-9a-fA-F]{6})').firstMatch(style);
  if (m == null) return null;
  return Color(int.parse('FF${m.group(1)!}', radix: 16));
}
