import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'frodo_image.dart';

/// 项目内统一的 HTML 渲染组件。
///
/// 内置 `<img>` 拦截：转交 [FrodoImage]，自动带防盗链 header。
/// 以后碰到分享卡片 / 投票 / 引用块等特殊标签，调用方通过 [extensions]
/// 追加自定义 `HtmlExtension` 即可，不会绕过图片处理。
class FrodoHtml extends StatelessWidget {
  const FrodoHtml({
    super.key,
    required this.data,
    this.extensions = const [],
  });

  final String data;
  final List<HtmlExtension> extensions;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      extensions: [
        TagExtension(
          tagsToExtend: const {'img'},
          builder: (ctx) {
            final src = _normalize(ctx.attributes['src']);
            if (src == null) return const SizedBox.shrink();
            return FrodoImage(imageUrl: src);
          },
        ),
        ...extensions,
      ],
    );
  }

  /// 处理 src 边角情况：空 / `data:` URI / protocol-relative。
  static String? _normalize(String? src) {
    if (src == null || src.isEmpty) return null;
    if (src.startsWith('//')) return 'https:$src';
    if (src.startsWith('http://') || src.startsWith('https://')) return src;
    return null;
  }
}
