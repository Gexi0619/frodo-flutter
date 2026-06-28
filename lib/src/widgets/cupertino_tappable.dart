import 'package:flutter/cupertino.dart';

/// iOS 风格的可点容器，替代 Material 的 `InkWell` / `InkResponse`
/// （安卓水波纹在全 Cupertino 的 App 里不合适）。
///
/// 反馈方式与 [CupertinoButton] 一致：按下时整体**瞬间**渐隐到 [pressedOpacity]，
/// 抬起 / 取消时再用 ~150ms 淡回，给出克制的 iOS 点按感，不裁剪、不涟漪。
///
/// [onTap] 与 [onLongPress] 都为 null 时不拦截手势、也无反馈，等价于纯 [child]，
/// 因此可以无脑包裹而不必担心拿不到回调时还吃掉点击。
class CupertinoTappable extends StatefulWidget {
  const CupertinoTappable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.pressedOpacity = 0.55,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// 按下时的不透明度（0~1），越小越"按得深"。
  final double pressedOpacity;
  final HitTestBehavior behavior;

  @override
  State<CupertinoTappable> createState() => _CupertinoTappableState();
}

class _CupertinoTappableState extends State<CupertinoTappable> {
  bool _pressed = false;

  bool get _enabled => widget.onTap != null || widget.onLongPress != null;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return widget.child;
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedOpacity(
        opacity: _pressed ? widget.pressedOpacity : 1.0,
        // 按下瞬间立刻变暗；松手再淡回，贴近 CupertinoButton 的手感。
        duration: Duration(milliseconds: _pressed ? 0 : 150),
        child: widget.child,
      ),
    );
  }
}
