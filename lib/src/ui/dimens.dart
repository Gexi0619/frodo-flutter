import 'package:flutter/widgets.dart';

/// UI 设计令牌：间距 / 圆角 / 固定尺寸的唯一出处。
///
/// 约定：widget 里不再写裸数字（padding、SizedBox、圆角、头像尺寸等），
/// 一律从这里取。需要随明暗主题变化的值放 ThemeExtension，不放这里；
/// 字号 / 字重 / 行高一律走 `Theme.of(context).textTheme`，不在此定义。
abstract final class Dim {
  Dim._();

  // ── 间距（t-shirt，4pt 栅格）────────────────────────────
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// 页面 / 列表的默认水平边距。
  static const double pageH = lg;

  // ── 圆角 ────────────────────────────────────────────────
  static const double radiusXs = 4; // 九宫格图片
  static const double radiusSm = 6; // 缩略图、mini 头像
  static const double radiusMd = 12;
  static const double radiusLg = 16; // 卡片

  // ── 固定元素尺寸 ────────────────────────────────────────
  static const double avatarSm = 16; // 行内 mini 头像
  static const double avatarMd = 40; // 列表头像（CircleAvatar radius 20）
  static const double avatarLg = 64; // 主页大头像
  static const double coverTile = 58; // 列表右侧封面缩略图
  static const double iconBadge = 36; // 评论数气泡等小徽标

  // ── 图标尺寸 ────────────────────────────────────────────
  static const double iconXs = 14; // 元信息行的小图标
  static const double iconSm = 16; // 行内强调图标（已认证等）
  static const double iconMd = 24; // 标准操作图标

  // ── 常用复合 padding（直接复用，省得重复拼）──────────────
  /// 列表项标准内边距：水平 16 / 垂直 12。
  static const EdgeInsets tile = EdgeInsets.symmetric(horizontal: lg, vertical: md);

  /// 页面水平内边距。
  static const EdgeInsets pageHInsets = EdgeInsets.symmetric(horizontal: pageH);
}
