import 'package:flutter/material.dart';

/// 滚动超过该距离即显示"回到顶部" FAB。
const double _kScrollToTopThreshold = 300;

/// 给 [State] 提供一个 `_showScrollToTopFab` 布尔位 + 公共阈值。
/// 调用方在 controller / notification 回调里转发 `pixels`，由 mixin 决定
/// 是否触发 setState。
mixin FabVisibilityMixin<W extends StatefulWidget> on State<W> {
  bool _showScrollToTopFab = false;
  bool get showScrollToTopFab => _showScrollToTopFab;

  void updateFabVisibility(double pixels) {
    final show = pixels > _kScrollToTopThreshold;
    if (show != _showScrollToTopFab) {
      setState(() => _showScrollToTopFab = show);
    }
  }
}

/// 项目内统一的回到顶部动画（时长 + 曲线）。
Future<void> animateScrollToTop(ScrollController c) {
  if (!c.hasClients) return Future.value();
  return c.animateTo(
    0,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOutCubic,
  );
}

/// Animated "scroll to top" FAB. Place as [Scaffold.floatingActionButton].
///
/// Caller is responsible for:
/// - toggling [visible] via scroll notifications
/// - providing [onPressed] that actually scrolls to top
class ScrollToTopFab extends StatelessWidget {
  const ScrollToTopFab({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: IgnorePointer(
        ignoring: !visible,
        child: FloatingActionButton(
          onPressed: onPressed,
          tooltip: '回到顶部',
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }
}
