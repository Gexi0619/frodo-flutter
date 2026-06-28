import 'package:flutter/material.dart';

import '../ui/dimens.dart';

/// 圆角小标签（药丸）：可选前置图标 + 文字，圆角彩底。
///
/// 统一原先散落的近似实现（账号「当前」标、豆列公开/私密 Chip、动态流类型标签等）。
/// 默认走 `secondaryContainer / onSecondaryContainer` 中性配色与 `labelSmall` 字号；
/// 需要别的配色 / 字号 / 圆角时按需覆盖。
class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.text,
    this.icon,
    this.background,
    this.foreground,
    this.textStyle,
    this.padding =
        const EdgeInsets.symmetric(horizontal: Dim.sm, vertical: Dim.xxs),
    this.radius = Dim.radiusSm,
  });

  final String text;

  /// 可选前置图标（如锁 / 地球）。
  final IconData? icon;

  /// 背景色，默认 `colorScheme.secondaryContainer`。
  final Color? background;

  /// 前景色（文字 + 图标），默认 `colorScheme.onSecondaryContainer`。
  final Color? foreground;

  /// 文字样式，默认 `textTheme.labelSmall`；最终会套上 [foreground]。
  final TextStyle? textStyle;

  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = foreground ?? scheme.onSecondaryContainer;
    final style = (textStyle ?? theme.textTheme.labelSmall)?.copyWith(color: fg);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: icon == null
          ? Text(text, style: style)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 12, color: fg),
                const SizedBox(width: 3),
                Text(text, style: style),
              ],
            ),
    );
  }
}
