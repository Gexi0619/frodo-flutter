import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── 字体 ────────────────────────────────────────────────────────────────────

class FontOption {
  final String? fontFamily; // null = 系统默认
  final String label;
  const FontOption(this.fontFamily, this.label);
}

const kFontOptions = [
  FontOption(null, '系统默认'),
  FontOption('Noto Sans SC', '思源黑体 (Noto Sans SC)'),
  FontOption('Noto Serif SC', '思源宋体 (Noto Serif SC)'),
];

class FontFamilyNotifier extends StateNotifier<String?> {
  FontFamilyNotifier() : super(null) {
    _load();
  }

  static const _key = 'font_family';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key);
  }

  Future<void> select(String? fontFamily) async {
    state = fontFamily;
    final prefs = await SharedPreferences.getInstance();
    fontFamily == null
        ? await prefs.remove(_key)
        : await prefs.setString(_key, fontFamily);
  }
}

final fontFamilyProvider = StateNotifierProvider<FontFamilyNotifier, String?>(
  (ref) => FontFamilyNotifier(),
);

// ── 主题模式 ──────────────────────────────────────────────────────────────────

typedef ThemeModeOption = ({ThemeMode mode, String label});

const kThemeModeOptions = <ThemeModeOption>[
  (mode: ThemeMode.system, label: '跟随系统'),
  (mode: ThemeMode.light, label: '浅色'),
  (mode: ThemeMode.dark, label: '深色'),
];

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  static const _key = 'theme_mode';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = switch (prefs.getString(_key)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> select(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);
