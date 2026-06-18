import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/link_launcher.dart';

/// 把纯文本里的 http/https URL 渲染成可点击链接（点击走 [openLink]，与帖子正文、
/// 评论里的链接行为一致），其余部分按普通文本显示，整体可长按选择复制。
///
/// 仅做「裸 URL → 链接」的轻量识别，不解析 HTML——小组简介 / 规则等字段是纯文本。
class LinkifiedText extends StatefulWidget {
  const LinkifiedText(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  State<LinkifiedText> createState() => _LinkifiedTextState();
}

class _LinkifiedTextState extends State<LinkifiedText> {
  /// 匹配 http/https URL，到下一处空白为止；常见尾随标点在生成 span 时再剥离。
  static final _urlPattern = RegExp(r'https?://\S+');
  static final _trailingPunctPattern =
      RegExp(r'[.,;:!?)\]}>"。，；：！？]+$');

  final _recognizers = <TapGestureRecognizer>[];

  @override
  void didUpdateWidget(LinkifiedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) _disposeRecognizers();
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

  /// 把文本切成普通段与链接段。每次构建前重置 recognizer，避免泄漏。
  List<InlineSpan> _buildSpans(BuildContext context) {
    _disposeRecognizers();
    final linkColor = Theme.of(context).colorScheme.primary;
    final spans = <InlineSpan>[];
    final text = widget.text;
    var last = 0;
    for (final m in _urlPattern.allMatches(text)) {
      final url = m.group(0)!.replaceFirst(_trailingPunctPattern, '');
      if (url.isEmpty) continue;
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start)));
      }
      final recognizer = TapGestureRecognizer()
        ..onTap = () => openLink(context, url);
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

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        style: widget.style ?? DefaultTextStyle.of(context).style,
        children: _buildSpans(context),
      ),
    );
  }
}
