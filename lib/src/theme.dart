import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Material 3 主题。豆瓣绿做种子色，字体由 [fontFamily] 参数决定。
class AppTheme {
  static const Color _seed = Color(0xFF42BD56); // 豆瓣绿

  static ThemeData light(String? fontFamily) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.light),
    );
    final text = _textTheme(fontFamily, base.textTheme);
    return base.copyWith(
      textTheme: text,
      extensions: [AppTextStyles.from(text)],
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0.6,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      badgeTheme: _badgeTheme(base.colorScheme, text),
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData dark(String? fontFamily) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
    );
    final text = _textTheme(fontFamily, base.textTheme);
    return base.copyWith(
      textTheme: text,
      extensions: [AppTextStyles.from(text)],
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0.6, centerTitle: false),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      badgeTheme: _badgeTheme(base.colorScheme, text),
    );
  }

  /// 角标统一用主题主色（豆瓣绿），而非 M3 默认的 error 红；
  /// 文字走 Micro(12)——比默认的 labelSmall(本刻度=14)小一档。
  static BadgeThemeData _badgeTheme(ColorScheme scheme, TextTheme text) =>
      BadgeThemeData(
        backgroundColor: scheme.primary,
        textColor: scheme.onPrimary,
        textStyle: AppTextStyles.from(text).micro,
      );

  static TextTheme _textTheme(String? fontFamily, TextTheme base) {
    final withFont = switch (fontFamily) {
      'Noto Sans SC' => GoogleFonts.notoSansScTextTheme(base),
      'Noto Serif SC' => GoogleFonts.notoSerifScTextTheme(base),
      _ => base, // null 或未知 = 系统字体
    };
    return _scale(withFont);
  }

  /// 全 App 字号刻度的唯一出处。极简：内容只有 3 个字号 18 / 16 / 14，
  /// 层级靠“字号 + 字重”两轴，相近的字号一律并为同一角色。
  /// 想整体调大/调小可读性，只改这里。所有文字都应映射到这些语义角色，
  /// 不在 widget 里写裸 `fontSize`，否则会绕过本刻度。
  ///
  ///  语义        M3 role            字号/字重  用途
  ///  Title       titleLarge         18 / 600   页面 / AppBar 标题、统计大数字
  ///  Subtitle    titleMedium        16 / 600   帖子标题、小组名、用户名
  ///  Body        bodyLarge/Medium   16 / 400   所有正文：详情、摘要、描述、评论
  ///  Emphasis    titleSmall         14 / 600   需强调的 Caption：列表项标题等
  ///  Caption     bodySmall/label*   14 / 400   作者 / 时间 / 计数 / 角标
  ///  Micro       AppTextStyles.micro 12 / 400  次要元信息：IP 属地 / 时间戳等需弱化的 caption
  ///
  /// Emphasis = 加重版 Caption（14/600），给列表项标题这类“比正文小、但要比同
  /// 行 caption 突出”的文字。想强调就用 titleSmall，不要在 widget 里写裸字重。
  ///
  /// Micro 没有合适的 M3 槽位（label* 最小已是 14），故走 [AppTextStyles]
  /// ThemeExtension，仍由本文件统一定义，不在 widget 里写裸 `fontSize`。
  /// （labelLarge=14 为按钮文字，属 Material 自带体系，不动。）
  static TextTheme _scale(TextTheme t) => t.copyWith(
        titleLarge: t.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: t.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: t.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: t.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
        bodyMedium: t.bodyMedium?.copyWith(fontSize: 16, height: 1.5),
        bodySmall: t.bodySmall?.copyWith(fontSize: 14),
        labelMedium: t.labelMedium?.copyWith(fontSize: 14),
        labelSmall: t.labelSmall?.copyWith(fontSize: 14),
      );
}

/// M3 字号刻度之外的补充角色。见 [AppTheme] 中的字号刻度说明。
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({required this.micro});

  /// Micro 11 / 400 —— 次要元信息（IP 属地、时间戳等）比 Caption 再弱一档。
  final TextStyle micro;

  /// 从字号刻度派生，承接 [TextTheme.labelSmall] 的字体/字重，仅缩小到 11。
  factory AppTextStyles.from(TextTheme text) =>
      AppTextStyles(micro: text.labelSmall!.copyWith(fontSize: 12));

  @override
  AppTextStyles copyWith({TextStyle? micro}) =>
      AppTextStyles(micro: micro ?? this.micro);

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(micro: TextStyle.lerp(micro, other.micro, t)!);
  }
}
