import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;

/// iOS 风格红色未读角标：systemRed 药丸 + 11px 白字，超过 99 显示 `99+`。
///
/// 两种用法，替代原先散落在底栏 / 消息段控 / 私信列表 / 小组宫格的 4 份复制实现：
/// - [CountBadge]：独立药丸，直接放进 Row/Column（如段控标签、列表尾部）。
///   `count <= 0` 渲染为空。
/// - [CountBadge.overlay]：把药丸浮在 [child] 右上角（如头像、底栏图标）。
///   `count <= 0` 时只返回 [child]。
class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.count, this.border = false})
      : child = null,
        top = 0,
        right = 0;

  const CountBadge.overlay({
    super.key,
    required this.count,
    required Widget this.child,
    this.top = -6,
    this.right = -6,
    this.border = true,
  });

  final int count;

  /// 叠加模式下被角标覆盖的内容；独立模式为 null。
  final Widget? child;

  /// 叠加模式下角标相对右上角的偏移。
  final double top;
  final double right;

  /// 是否描一圈与背景同色的边——叠在头像上时用来"挖空"出间隙。
  final bool border;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return child ?? const SizedBox.shrink();
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      constraints: const BoxConstraints(minWidth: 18),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CupertinoColors.systemRed,
        borderRadius: const BorderRadius.all(Radius.circular(9)),
        border: border
            ? Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 1.5,
              )
            : null,
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      ),
    );
    if (child == null) return pill;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(top: top, right: right, child: pill),
      ],
    );
  }
}
