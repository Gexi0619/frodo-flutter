import 'package:flutter/material.dart';

/// 固定高度吸顶 sliver 的行为。
enum StickyHeaderMode {
  /// 始终钉在顶部，不随内容滚动。
  pinned,

  /// 下滑时随内容滚出视口，上滑时立刻吸回顶部。
  floating,

  /// 跟随内容自然滚动（无吸附）。
  scroll,
}

/// 把任意固定高度的 widget 放进 [CustomScrollView] 时的标准吸顶/收起容器。
///
/// 用法：
/// ```dart
/// CustomScrollView(slivers: [
///   StickyHeaderSliver(
///     height: MyBar.height,
///     mode: StickyHeaderMode.floating,
///     child: MyBar(),
///   ),
///   PagedSliverList(...),
/// ])
/// ```
class StickyHeaderSliver extends StatelessWidget {
  const StickyHeaderSliver({
    super.key,
    required this.height,
    required this.child,
    this.mode = StickyHeaderMode.floating,
  });

  final double height;
  final Widget child;
  final StickyHeaderMode mode;

  @override
  Widget build(BuildContext context) {
    if (mode == StickyHeaderMode.scroll) {
      return SliverToBoxAdapter(
        child: SizedBox(height: height, child: child),
      );
    }
    return SliverPersistentHeader(
      pinned: mode == StickyHeaderMode.pinned,
      floating: mode == StickyHeaderMode.floating,
      delegate: _FixedHeightDelegate(height: height, child: child),
    );
  }
}

class _FixedHeightDelegate extends SliverPersistentHeaderDelegate {
  const _FixedHeightDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  bool shouldRebuild(covariant _FixedHeightDelegate old) =>
      old.height != height || old.child != child;
}
