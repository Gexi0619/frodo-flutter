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
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 2 && _visible.value) {
        _visible.value = false;
      } else if (delta < -2 && !_visible.value) {
        _visible.value = true;
      }
    } else if (notification is ScrollEndNotification) {
      if (notification.metrics.pixels <= 0) _visible.value = true;
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
