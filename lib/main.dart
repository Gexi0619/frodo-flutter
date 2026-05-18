import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/font_loader.dart';
import 'src/pages/settings/providers.dart';
import 'src/router.dart';
import 'src/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // dart:io HttpClient 默认带 "Dart/x.x (dart:io)" UA。
  // extended_image 用 headers.add() 叠加自定义 UA，导致双 UA 并存，
  // 豆瓣 CDN 认出非豆瓣 UA 后返回 1 字节垃圾数据（假 200）。
  // 这里把默认 UA 置空，确保 add() 后只有豆瓣 UA 生效。
  HttpOverrides.global = _NullUserAgentOverrides();

  // 后台加载字体，不阻塞启动。字体就绪后 Flutter 自动重绘文字。
  unawaited(AppFontLoader.load());

  runApp(const ProviderScope(child: FrodoApp()));
}

class _NullUserAgentOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)..userAgent = null;
}

class FrodoApp extends ConsumerWidget {
  const FrodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final font = ref.watch(fontFamilyProvider);
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Frodo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(font),
      darkTheme: AppTheme.dark(font),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
