import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show TabController;

import '../theme.dart';

/// 搜索类页面顶部 chrome 的容器：撑开状态栏高度 + surface 底色，把传入的若干行
/// （搜索框 / 段控等）垂直居中排布。配 [TabbedSearchPageState] 的
/// `PreferredSizeWidget` appBar 槽位使用。
///
/// 自身即 [PreferredSizeWidget]：高度 = 状态栏 [topPadding] + 内容 [contentHeight]。
/// [topPadding] 由调用方在有 MediaQuery 的 build 上下文里算好传入（appBar 槽位
/// 取不到自己的 padding）。
class SearchHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchHeaderBar({
    super.key,
    required this.topPadding,
    required this.contentHeight,
    required this.children,
  });

  final double topPadding;

  /// 不含状态栏的内容高度。
  final double contentHeight;
  final List<Widget> children;

  @override
  Size get preferredSize => Size.fromHeight(topPadding + contentHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.scheme.surface,
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

/// 与 [TabController] 双向同步的 iOS 段控：点某段 → `animateTo`，滑动切 tab →
/// 监听 controller 把高亮挪过去。[labels] 按序对应各 tab。
///
/// [trailingBuilder] 可按当前 index 在段控右侧放一个附加按钮（如「实时」tab 的
/// 视图模式切换）；返回 null 则只渲染段控本身。
class TabSegmentedControl extends StatelessWidget {
  const TabSegmentedControl({
    super.key,
    required this.controller,
    required this.labels,
    this.trailingBuilder,
  });

  final TabController controller;
  final List<String> labels;
  final Widget? Function(int index)? trailingBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final segmented = CupertinoSlidingSegmentedControl<int>(
          groupValue: controller.index,
          onValueChanged: (i) {
            if (i != null) controller.animateTo(i);
          },
          children: {
            for (final (i, label) in labels.indexed) i: Text(label),
          },
        );
        final trailing = trailingBuilder?.call(controller.index);
        if (trailing == null) return segmented;
        return Row(
          children: [Expanded(child: segmented), trailing],
        );
      },
    );
  }
}
