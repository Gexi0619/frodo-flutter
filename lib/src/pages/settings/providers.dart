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

// ── 主题色 ────────────────────────────────────────────────────────────────────

typedef SeedColorOption = ({Color color, String label});

/// 第一项是默认（豆瓣绿），其余为可选预设。
const kSeedColorOptions = <SeedColorOption>[
  (color: Color(0xFF42BD56), label: '豆瓣绿'),
  (color: Color(0xFF1E88E5), label: '蓝'),
  (color: Color(0xFF8E24AA), label: '紫'),
  (color: Color(0xFFE53935), label: '红'),
  (color: Color(0xFFFB8C00), label: '橙'),
  (color: Color(0xFF00897B), label: '青'),
  (color: Color(0xFF546E7A), label: '灰蓝'),
];

const kDefaultSeedColor = Color(0xFF42BD56); // 豆瓣绿

class SeedColorNotifier extends StateNotifier<Color> {
  SeedColorNotifier() : super(kDefaultSeedColor) {
    _load();
  }

  static const _key = 'seed_color';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getInt(_key);
    if (raw != null) state = Color(raw);
  }

  Future<void> select(Color color) async {
    state = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, color.toARGB32());
  }
}

final seedColorProvider = StateNotifierProvider<SeedColorNotifier, Color>(
  (ref) => SeedColorNotifier(),
);

// ── 小组页布局 ────────────────────────────────────────────────────────────────

enum GroupsLayout {
  /// 顶部横向 2 行网格（默认）。
  topGrid,

  /// 底部粘底浮层，一行圆形头像。
  bottomDock,
}

typedef GroupsLayoutOption = ({GroupsLayout layout, String label, String hint});

const kGroupsLayoutOptions = <GroupsLayoutOption>[
  (
    layout: GroupsLayout.topGrid,
    label: '顶部网格',
    hint: '小组以 2 行横向网格置于推荐讨论上方',
  ),
  (
    layout: GroupsLayout.bottomDock,
    label: '底部 Dock',
    hint: '小组以一行圆形头像粘在底部，类似 Discord 服务器栏',
  ),
];

class GroupsLayoutNotifier extends StateNotifier<GroupsLayout> {
  GroupsLayoutNotifier() : super(GroupsLayout.topGrid) {
    _load();
  }

  static const _key = 'groups_layout';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    state = GroupsLayout.values
        .firstWhere((e) => e.name == raw, orElse: () => GroupsLayout.topGrid);
  }

  Future<void> select(GroupsLayout layout) async {
    state = layout;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, layout.name);
  }
}

final groupsLayoutProvider =
    StateNotifierProvider<GroupsLayoutNotifier, GroupsLayout>(
  (ref) => GroupsLayoutNotifier(),
);

// ── 滚动隐藏底部栏 ─────────────────────────────────────────────────────────────

class HideNavOnScrollNotifier extends StateNotifier<bool> {
  HideNavOnScrollNotifier() : super(false) {
    _load();
  }

  static const _key = 'hide_nav_on_scroll';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? true;
  }

  Future<void> toggle(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}

final hideNavOnScrollProvider = StateNotifierProvider<HideNavOnScrollNotifier, bool>(
  (ref) => HideNavOnScrollNotifier(),
);

// ── 会员头衔标签配色 ───────────────────────────────────────────────────────────
// true（默认）= 使用头衔原始颜色；false = 统一用主题色。
class MemberTitleOriginalColorNotifier extends StateNotifier<bool> {
  MemberTitleOriginalColorNotifier() : super(true) {
    _load();
  }

  static const _key = 'member_title_original_color';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? true;
  }

  Future<void> toggle(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}

final memberTitleOriginalColorProvider =
    StateNotifierProvider<MemberTitleOriginalColorNotifier, bool>(
  (ref) => MemberTitleOriginalColorNotifier(),
);

// ── 评论翻页按钮样式 ───────────────────────────────────────────────────────────

enum CommentPagerStyle {
  /// 圆环进度（默认）：用环形进度条表示「当前页 / 总页数」。
  circle,

  /// 文字：直接显示「当前页/总页数」文字加展开箭头。
  text,
}

typedef CommentPagerStyleOption = ({
  CommentPagerStyle style,
  String label,
  String hint,
});

const kCommentPagerStyleOptions = <CommentPagerStyleOption>[
  (
    style: CommentPagerStyle.circle,
    label: '圆环进度',
    hint: '用环形进度表示当前所在页',
  ),
  (
    style: CommentPagerStyle.text,
    label: '页码文字',
    hint: '直接显示「当前页/总页数」',
  ),
];

class CommentPagerStyleNotifier extends StateNotifier<CommentPagerStyle> {
  CommentPagerStyleNotifier() : super(CommentPagerStyle.circle) {
    _load();
  }

  static const _key = 'comment_pager_style';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    state = CommentPagerStyle.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => CommentPagerStyle.circle,
    );
  }

  Future<void> select(CommentPagerStyle style) async {
    state = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, style.name);
  }
}

final commentPagerStyleProvider =
    StateNotifierProvider<CommentPagerStyleNotifier, CommentPagerStyle>(
  (ref) => CommentPagerStyleNotifier(),
);
