import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../utils/link_launcher.dart';

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
