import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 滚动方向驱动的底部栏显隐控制器。
///
/// 用法：在宿主 Scaffold 内创建一个 [ScrollHideBar]，把 [onNotification] 接到
/// `body` 的 [NotificationListener]，再用 [wrap] 包住 `bottomNavigationBar`。
/// [enabled] 为 false 时永远显示，便于跟随用户设置开关。
class ScrollHideBar {
  ScrollHideBar();

  final ValueNotifier<bool> _visible = ValueNotifier<bool>(true);

  ValueListenable<bool> get visible => _visible;

  void dispose() => _visible.dispose();

  void show() {
    if (!_visible.value) _visible.value = true;
  }

  bool onNotification(ScrollNotification notification) {
    // 只跟随竖直方向的滚动。body 子树里还有横向滚动源（feed 的 TabBarView、
    // 图片翻页等），它们的通知同样会冒泡到这里——按竖直处理就会让底栏乱弹。
    if (notification.metrics.axis != Axis.vertical) return false;

    if (notification is ScrollUpdateNotification) {
      // 只认用户手指拖动（dragDetails 非空）。惯性滑动、滑到底加载更多时的
      // 列表增长/回弹都没有 dragDetails，正是这些「非手势」位移在莫名弹出底栏。
      final delta = notification.dragDetails != null
          ? (notification.scrollDelta ?? 0)
          : 0;
      if (delta > 0.5) {
        _visible.value = false; // 手指上滑、内容上移 → 收起
      } else if (delta < -0.5) {
        _visible.value = true; // 手指下滑、内容下移 → 展开
      }
    } else if (notification is ScrollEndNotification) {
      // 真正停在顶部时保证露出；用 minScrollExtent 而非 0，兼容有顶部 inset 的列表。
      if (notification.metrics.pixels <= notification.metrics.minScrollExtent) {
        _visible.value = true;
      }
    }
    return false;
  }

  /// 将 [child] 包成可垂直折叠的底栏；[enabled] 关闭时直接返回 [child]。
  Widget wrap({required Widget child, required bool enabled}) {
    if (!enabled) return child;
    return ValueListenableBuilder<bool>(
      valueListenable: _visible,
      builder: (_, v, c) => AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        heightFactor: v ? 1.0 : 0.0,
        child: c,
      ),
      child: child,
    );
  }
}
