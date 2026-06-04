import 'package:flutter/material.dart';

/// 贴在右端的滚动指示条：一段随滚动位置上下移动的"滑块"，
/// 长度按视口/内容比例缩放，类似系统滚动条的 thumb。
///
/// 只在滚动时重绘自身，不触发外层 rebuild。建议放进 [Stack] 中，
/// 配合 `Positioned(top: 0, bottom: 0, right: 0)` 贴边显示。
class ReadingProgressBar extends StatelessWidget {
  const ReadingProgressBar({
    super.key,
    required this.controller,
    this.width = 3,
    this.minThumbLength = 36,
  });

  final ScrollController controller;
  final double width;

  /// 滑块的最小长度，内容很长时避免缩成一个点。
  final double minThumbLength;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withValues(alpha: 0.5);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          // 仅当恰好附着一个滚动位置时才读取 position：NestedScrollView 在
          // 重建/加载过渡期可能短暂附着多个位置，此时 position 会断言失败。
          if (controller.positions.length != 1) {
            return const SizedBox.shrink();
          }
          final pos = controller.position;
          // 帖子加载时滚动视图尚未完成首帧布局，pixels / 内容尺寸 / 视口尺寸
          // 都还没算出来，此时读取会断言失败（红屏）。等布局就绪再显示。
          if (!pos.hasPixels ||
              !pos.hasContentDimensions ||
              !pos.hasViewportDimension) {
            return const SizedBox.shrink();
          }
          final max = pos.maxScrollExtent;
          if (max <= 0) return const SizedBox.shrink(); // 不可滚动则不显示

          final t = (pos.pixels / max).clamp(0.0, 1.0);
          final viewport = pos.viewportDimension;
          final content = max + viewport;

          return LayoutBuilder(
            builder: (context, constraints) {
              final track = constraints.maxHeight;
              final thumb = content > 0
                  ? (viewport / content * track).clamp(minThumbLength, track)
                  : minThumbLength;
              // Alignment.y: -1 贴顶、1 贴底，已自动扣除滑块自身高度。
              return Align(
                alignment: Alignment(0, t * 2 - 1),
                child: Container(
                  width: width,
                  height: thumb,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(width / 2),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
