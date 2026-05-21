import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../routing/app_routes.dart';

/// 打开 URL：能识别为豆瓣内部链接则路由到 app 对应页面，否则交给系统默认浏览器。
///
/// 失败（URL 不合法、找不到浏览器、跳转抛错）时退化为剪贴板复制并提示。
Future<void> openLink(BuildContext context, String url) async {
  final unwrapped = _unwrapDoubanRedirect(url);
  final uri = Uri.tryParse(unwrapped);
  if (uri == null || !uri.hasScheme) {
    _fallbackCopy(context, unwrapped);
    return;
  }

  final route = _resolveInternalRoute(uri);
  if (route != null) {
    context.push(route);
    return;
  }

  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) _fallbackCopy(context, unwrapped);
  } catch (_) {
    if (context.mounted) _fallbackCopy(context, unwrapped);
  }
}

/// 豆瓣跳转链接 `*.douban.com/link2/?url=<encoded>` 解包为原始 URL。
String _unwrapDoubanRedirect(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return url;
  if (!_isDoubanHost(uri.host) || uri.path != '/link2/') return url;
  final inner = uri.queryParameters['url'];
  return (inner != null && inner.isNotEmpty) ? inner : url;
}

/// 将豆瓣站内 URL 映射到 app 内部路由路径；不匹配返回 null。
///
/// 已支持：讨论(group/topic)、小组(group)、豆列(doulist)。
/// 其余子站（movie/book/music/...）暂未对应内部页面，交给浏览器。
String? _resolveInternalRoute(Uri uri) {
  if (!_isDoubanHost(uri.host)) return null;
  final seg = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (seg.isEmpty) return null;

  if (seg.length >= 3 && seg[0] == 'group' && seg[1] == 'topic') {
    return AppRoutes.topic(seg[2]);
  }
  if (seg.length >= 2 && seg[0] == 'group') {
    return AppRoutes.group(seg[1]);
  }
  if (seg.length >= 2 && seg[0] == 'doulist') {
    return AppRoutes.doulist(seg[1]);
  }
  return null;
}

/// 主站 host：仅 www / m / 裸域，避免误把 movie.douban.com 等子站当成内部页。
bool _isDoubanHost(String host) {
  final h = host.toLowerCase();
  return h == 'www.douban.com' || h == 'm.douban.com' || h == 'douban.com';
}

void _fallbackCopy(BuildContext context, String url) {
  Clipboard.setData(ClipboardData(text: url));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('无法打开链接，已复制：$url'),
      duration: const Duration(seconds: 2),
    ),
  );
}
