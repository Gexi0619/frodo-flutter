import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// 从 CDN 下载霞鹜文楷，缓存到磁盘，并通过 FontLoader 注册到 Flutter 字体系统。
/// 注册完成后 Flutter 自动触发重绘，无需手动通知。
class AppFontLoader {
  AppFontLoader._();

  static const fontFamily = 'LXGWWenKai';

  // 字体直链（GitHub Releases v1.522）
  static const _url =
      'https://github.com/lxgw/LxgwWenKai/releases/download/v1.522/LXGWWenKai-Regular.ttf';

  static const _cacheFile = 'lxgw_wenkai_regular.ttf';

  static bool _loaded = false;

  /// 启动时调用一次即可，不需要 await（后台加载，加载完 Flutter 自动重绘）。
  static Future<void> load() async {
    if (_loaded) return;
    try {
      final bytes = await _getOrDownload();
      final loader = FontLoader(fontFamily);
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
      await loader.load();
      _loaded = true;
      debugPrint('AppFontLoader: $fontFamily 加载完成');
    } catch (e, st) {
      // 失败时静默降级为系统字体
      debugPrint('AppFontLoader: 加载失败 – $e\n$st');
    }
  }

  static Future<Uint8List> _getOrDownload() async {
    final dir = await getApplicationCacheDirectory();
    final file = File('${dir.path}/$_cacheFile');

    if (await file.exists()) {
      debugPrint('AppFontLoader: 使用磁盘缓存');
      return file.readAsBytes();
    }

    debugPrint('AppFontLoader: 开始下载 $_url');
    final dio = Dio();
    final resp = await dio.get<List<int>>(
      _url,
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = Uint8List.fromList(resp.data!);
    await file.writeAsBytes(bytes);
    debugPrint('AppFontLoader: 下载完成，已缓存至 ${file.path}');
    return bytes;
  }
}
