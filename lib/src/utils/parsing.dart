import 'package:flutter/material.dart';

/// 解析形如 `#rrggbb` / `rrggbb` 的 hex 字符串。解析失败时回退到 [fallback]。
Color hexToColor(String? hex, {Color fallback = const Color(0xFF6B6B6B)}) {
  if (hex == null || hex.isEmpty) return fallback;
  final cleaned = hex.startsWith('#') ? hex.substring(1) : hex;
  if (cleaned.length != 6) return fallback;
  final value = int.tryParse(cleaned, radix: 16);
  if (value == null) return fallback;
  return Color(0xFF000000 | value);
}

/// 处理 src / href 的边角情况：空 / `data:` URI / protocol-relative。
/// 返回 null 表示无法当作 http(s) URL 使用。
String? normalizeUrl(String? src) {
  if (src == null || src.isEmpty) return null;
  if (src.startsWith('//')) return 'https:$src';
  if (src.startsWith('http://') || src.startsWith('https://')) return src;
  return null;
}

/// 小组色块上的 header 前景色：尽量用白色（小组背景多为深色遮罩），
/// 仅当背景明显偏亮时才退回深色，避免白字在浅底上不可读。
Color headerForeground(Color background) =>
    background.computeLuminance() > 0.6 ? Colors.black87 : Colors.white;

/// 根据背景亮度返回前景色（深色背景配白字，浅色背景配黑字）。
Color contrastOn(Color background) =>
    ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white
        : Colors.black;
