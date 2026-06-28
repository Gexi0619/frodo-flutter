import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 主题：壳仍是 Material（MaterialApp + Theme.of(context).colorScheme），
/// 但每个 ColorScheme 槽位都被改成 Apple 的语义系统色（[CupertinoColors]），
/// 让全 App 的背景 / 文字 / 分隔线 / 占位色都符合 iOS 规范，同时不必逐个改
/// 页面里已有的 `colorScheme.xxx` 调用。配色随亮 / 暗自动取 iOS 的明暗变体。
///
/// 槽位映射（按本仓库的实际用法，而非 Material 原义）：
///   primary                 → 豆瓣绿 seed（品牌强调色，保持精确值）
///   surface                 → systemBackground（页面底色）
///   onSurface               → label（主文字）
///   onSurfaceVariant        → secondaryLabel（次要文字）
///   outline                 → secondaryLabel（本仓库把 outline 当“弱化文字/图标
///                              色”用：时间、计数、占位符、chevron，而非边框）
///   outlineVariant          → separator（真正的分隔线 / 边框走这里）
///   surfaceContainerHighest → secondarySystemBackground（图片 / 填充占位）
///   error                   → systemRed
class AppTheme {
  static const Color defaultSeed = Color(0xFF42BD56); // 豆瓣绿

  /// 全平台统一走 iOS 风格转场：右滑入场 + 边缘左滑返回手势。
  /// [CupertinoPageTransitionsBuilder] 会经由 CupertinoRouteTransitionMixin
  /// 给可返回的路由挂上边缘返回手势检测器，所以 go_router 的 MaterialPage
  /// （MaterialPageRoute）无需逐个改成 CupertinoPage 即可获得滑动返回。
  /// 注意：不要再用 PredictiveBackPageTransitionsBuilder，它是 Android 系统
  /// 预测式返回，与 iOS 边缘滑动返回互斥。
  static const PageTransitionsTheme _pageTransitions = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
    },
  );

  static ThemeData light(String? fontFamily, {Color seed = defaultSeed}) =>
      _build(Brightness.light, fontFamily, seed);

  static ThemeData dark(String? fontFamily, {Color seed = defaultSeed}) =>
      _build(Brightness.dark, fontFamily, seed);

  static ThemeData _build(Brightness brightness, String? fontFamily, Color seed) {
    final scheme = _iosColorScheme(brightness, seed);
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final text = _textTheme(fontFamily, base.textTheme);
    return base.copyWith(
      textTheme: text,
      extensions: [AppTextStyles.from(text)],
      // 页面底色用 iOS systemBackground（亮=白 / 暗=纯黑）；想要分组列表灰底的
      // 页面自行用 CupertinoColors.systemGroupedBackground 覆盖。
      scaffoldBackgroundColor: scheme.surface,
      // iOS 导航栏：纯色底 + 无 M3 紫色叠色、无滚动阴影，扁平干净。
      // 需要分隔线的页面自己加 BorderSide(color: outlineVariant)。
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      // iOS 发丝级分隔线：0.5px + separator 色。
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 0.5),
      badgeTheme: _badgeTheme(scheme, text),
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: _pageTransitions,
      // Cupertino 原生控件（CupertinoSwitch / 导航栏 / 选择器等）也吃品牌绿。
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: seed,
      ),
    );
  }

  /// 把 Material 的 ColorScheme 槽位全部改写成 Apple 的语义系统色。
  /// 以 [ColorScheme.fromSeed] 打底（让少用的 secondary/tertiary 等槽位仍有
  /// 协调的取值），再 copyWith 覆盖 App 里真正会用到的槽位为 iOS 系统色。
  static ColorScheme _iosColorScheme(Brightness brightness, Color seed) {
    final dark = brightness == Brightness.dark;
    Color ios(CupertinoDynamicColor c) => dark ? c.darkColor : c.color;
    return ColorScheme.fromSeed(seedColor: seed, brightness: brightness).copyWith(
      primary: seed,
      onPrimary: CupertinoColors.white,
      error: ios(CupertinoColors.systemRed),
      onError: CupertinoColors.white,
      surface: ios(CupertinoColors.systemBackground),
      onSurface: ios(CupertinoColors.label),
      onSurfaceVariant: ios(CupertinoColors.secondaryLabel),
      surfaceContainerHighest: ios(CupertinoColors.secondarySystemBackground),
      outline: ios(CupertinoColors.secondaryLabel),
      outlineVariant: ios(CupertinoColors.separator),
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

/// 主题读取的便捷扩展，省掉满屏的 `Theme.of(context).colorScheme` /
/// `Theme.of(context).extension<AppTextStyles>()?`。[AppTextStyles] 由
/// [AppTheme._build] 始终注册，故 [texts] 直接非空返回。
extension AppThemeContext on BuildContext {
  /// = `Theme.of(context).colorScheme`（槽位语义见 [AppTheme]）。
  ColorScheme get scheme => Theme.of(this).colorScheme;

  /// = `Theme.of(context).extension<AppTextStyles>()!`，取 micro 等补充字号。
  AppTextStyles get texts => Theme.of(this).extension<AppTextStyles>()!;
}
