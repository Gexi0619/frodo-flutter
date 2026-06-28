import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 全 App 统一的滚动行为：所有平台都走 iOS 弹性回弹，并去掉安卓默认的蓝色
/// 辉光（overscroll glow），与全局 Cupertino 风格一致。挂到 [MaterialApp.scrollBehavior]。
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}

/// 下拉刷新所在滚动视图的物理：iOS 弹性 + 始终可滚动，保证即使内容不满一屏
/// 也能下拉触发 [CupertinoSliverRefreshControl]。
const kRefreshScrollPhysics = BouncingScrollPhysics(
  parent: AlwaysScrollableScrollPhysics(),
);
